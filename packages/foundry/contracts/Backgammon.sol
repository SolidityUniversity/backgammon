// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Backgammon {
    uint256[24] public white;
    uint256[24] public black;

    constructor() {
        // black: [0,0,0,0,0,5,0,3,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,2]
        black[5] = 5;
        black[7] = 3;
        black[12] = 5;
        black[23] = 2;

        // white: [2,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,3,0,5,0,0,0,0,0]
        white[0] = 2;
        white[11] = 5;
        white[16] = 3;
        white[18] = 5;
    }
}
