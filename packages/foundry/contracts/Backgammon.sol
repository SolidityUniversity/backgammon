// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Backgammon {
    uint256[30] public white;
    uint256[30] public black;

    bool public isItBlackTurn;

    event WhiteTurn(uint256 _from, uint256 _to);

    constructor() {
        // black: [0,0,0,0,0,5,0,3,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,2]
        black[6] = 5;
        black[8] = 3;
        black[13] = 5;
        black[24] = 2;

        // white: [2,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,3,0,5,0,0,0,0,0]
        white[1] = 2;
        white[12] = 5;
        white[17] = 3;
        white[19] = 5;
    }

    function _moveWhite(uint256 _from, uint256 _to) public {
        //msg.sender = whiteplayer?
        require(!isItBlackTurn, "Is Black Turn");
        // require(deadWhiteCheckers == 0, "There is Dead white checkers");
        require(_from != _to, "_from and _to should be different");
        require(_from < 24 && _to < 24, "_from or _to out of game range");

        require(white[_from] > 0, "There is no white checkers on _from");
        require(black[_to] < 2, "White cant go there");

        white[_from] -= 1;

        if (black[_to] == 1) {
            black[_to] -= 1;
            black[0]++;
        }

        white[_to] += 1;
        emit WhiteTurn(_from, _to);
    }
}
