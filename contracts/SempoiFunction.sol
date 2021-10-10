// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SempoiFunction{
    
    uint256 sayaInt = 23;
    string sayaString = "Hantu";
    bool sayaBool = true;
    uint256[] sayaArr = [3,2,1];
    
    function fungsiPure(uint256 _x, uint256 _y) public pure returns(uint256 xy){
        return _x * _y;
    }
    
    function fungsiView() internal view returns (string memory){
        return sayaString;
    }
    
    function fungsiUpdate() public returns(string memory){
        sayaString = "Kak Limah";
        string memory simpanString = fungsiView();
        return simpanString;
    }
    
    function fungsiReturn() external view returns (uint256, string memory, bool, uint256[] memory){
        return (sayaInt, sayaString, sayaBool, sayaArr);
    }
    
    function fungsiNoReturn() external {
        sayaBool = false;
    }

}
