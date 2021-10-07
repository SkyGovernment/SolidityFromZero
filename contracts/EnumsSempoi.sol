//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EnumsSempoi{
    uint8 rarity = 0;
    
    enum Rarity{
        original, // 0
        rare, // 1
        super_rare // 2
    }
    
    Rarity public rarity;
    
    // constructor get call only once during deployment
    // constructor diseru sekali sahaja ketika deployment
    constructor() {
        rarity = Rarity.rare;
    }
    
    function makeSuperRare() public {
        rarity = Rarity.super_rare;
    }
    
}
