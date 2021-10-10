//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SempoiStruct{
  struct NFT {
        string name;
        uint256 dna;
    }
    
    NFT[] public nftList;
    
    function addNFT(string memory _name, uint256 _dna) public {
        // NFT memory newNFT;
        // newNFT.name = _name;
        // newNFT.dna = _dna;
        NFT memory newNFT = NFT(_name, _dna); // This is the same as 3 lines of code above
        nftList.push(newNFT);
    }
    
    function addNFTS(NFT[] calldata _nfts) public {
        //calldata only for Array
        nftList = _nfts;
    }
    
    function updateNFTStorage(uint256 _index, string memory _name) public {
        NFT storage nftToBeUpdated = nftList[_index];
        nftToBeUpdated.name = _name;
    }
    
    function updateNFTMemory(uint256 _index, string memory _name) public {
        NFT memory nftToBeUpdated = nftList[_index];
        nftToBeUpdated.name = _name;
        nftList[_index] = nftToBeUpdated; // need this or error
    }
    
    function getNftName(uint256 _index) public view returns(string memory){
        return nftList[_index].name;
    }
}
