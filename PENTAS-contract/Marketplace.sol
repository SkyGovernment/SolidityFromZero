// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./PentasNFT.sol";

contract Marketplace is Initializable, ContextUpgradeable, OwnableUpgradeable {
  /**
   * @dev Pentas NFT contract
   */
  PentasNFT private _pentasNFT;

  /**
   * @dev To map tokenId to price
   */
  mapping(uint256 => uint256) private _tokenPrice;

  /**
   * @dev Marketplace fee
   */
  uint32 private _fee;

  function initialize() public initializer {
    __Ownable_init();
  }

  /**
   * @dev Assign Pentas NFT contract.
   * Permission: Contract owner.
   * @param pentasAddress Pentas contract address.
   */
  function setPentasNFTContract(address pentasAddress) external onlyOwner {
    _pentasNFT = PentasNFT(pentasAddress);
  }

  /**
   * @dev Getter for Pentas NFT contract address.
   */
  function pentasNFTContract() external view returns (address) {
    return address(_pentasNFT);
  }

  /**
   * @dev Set token selling price.
   * @param tokenId Token ID.
   * @param price Token selling price.
   */
  function setSalePrice(uint256 tokenId, uint256 price) external {
    // Check for approval
    require(
      _pentasNFT.getApproved(tokenId) == address(this),
      "Marketplace: Require owner approval"
    );

    // Caller must be token owner or Pentas address
    require(
      (_pentasNFT.ownerOf(tokenId) == _msgSender()) ||
        (address(_pentasNFT) == _msgSender()),
      "Marketplace: Caller must be a token owner or from Pentas address"
    );

    // Assign price value
    _tokenPrice[tokenId] = price;
  }

  /**
   * @dev Getter for selling price.
   * @param tokenId Token ID.
   */
  function salePrice(uint256 tokenId) external view returns (uint256) {
    return _tokenPrice[tokenId];
  }

  /**
   * @dev Set fee imposed to selling token.
   * @param __fee Fee.
   */
  function setFee(uint32 __fee) external onlyOwner {
    _fee = __fee;
  }

  /**
   * @dev Getter for current fee.
   */
  function fee() external view returns (uint32) {
    return _fee;
  }

  /**
   * @dev Purchase a token.
   * @param tokenId Token ID.
   */
  function purchase(uint256 tokenId) external payable {
    // Check for approval
    require(
      _pentasNFT.getApproved(tokenId) == address(this),
      "Marketplace: Require owner approval"
    );

    // Not allow to purchase own token
    require(
      _pentasNFT.ownerOf(tokenId) != _msgSender(),
      "Marketplace: Token is owned by the caller"
    );

    // Selling price must be bigger than 0
    require(
      _tokenPrice[tokenId] > 0,
      "Marketplace: Selling price should not be zero"
    );

    uint256 sellingPrice = _tokenPrice[tokenId];
    uint256 netFee = (sellingPrice / 100000) * _fee;

    // Payment should be more than the asking price
    require(msg.value >= sellingPrice, "Marketplace: Payment not enough");

    // Royalty infomation based on EIP-2981
    uint256 netRoyalty;
    address minter;
    (minter, netRoyalty) = _pentasNFT.royaltyInfo(tokenId, sellingPrice);

    // Royalty payment
    address payable creator = payable(minter);
    (bool paidMinter, ) = creator.call{ value: netRoyalty }("");
    require(paidMinter, "Marketplace: Fail to transfer payment to minter");

    // Seller earnings after deduct royalty and fee
    address payable seller = payable(_pentasNFT.ownerOf(tokenId));
    (bool paidSeller, ) = seller.call{
      value: (sellingPrice - netRoyalty - netFee)
    }("");
    require(paidSeller, "Marketplace: Fail to transfer payment to seller");

    // Marketplace earnings
    address payable owner = payable(owner());
    (bool paidOwner, ) = owner.call{ value: netFee }("");
    require(
      paidOwner,
      "Marketplace: Fail to transfer payment to contract owner"
    );

    // Conduct token transfer
    _pentasNFT.safeTransferFrom(
      _pentasNFT.ownerOf(tokenId),
      _msgSender(),
      tokenId
    );

    // Reset sale price back to zero
    _tokenPrice[tokenId] = 0;
  }
}
