// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract SempoiMapping {
    mapping(uint256 => address) private ntfs;
    uint256 counter = 0;
    
    // Function untuk return address nft dari _id
    function getNFTAddress(uint256 _id) public view returns(address) {
        return nfts(id);
    }
    
    // Function untuk mint address ke nft dengan _id incremental
    function mintNFT(address _address) public {
        ntfs[counter] = _address;
        counter++;
    }
}
