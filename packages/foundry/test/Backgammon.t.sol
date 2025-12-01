// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Backgammon} from "../contracts/Backgammon.sol";

contract BackgammonTest is Test {
    Backgammon public backgammon;

    function setUp() public {
        backgammon = new Backgammon();
    }

    function test_RollDiceGeneratesValidNumbers() public {
        // Test multiple rolls to ensure dice values are always 1-6
        for (uint256 i = 0; i < 100; i++) {
            vm.roll(block.number + 1); // Advance block
            vm.warp(block.timestamp + 1); // Advance time

            backgammon.rollDiceWhite();

            // Check that available moves are valid (1-6)
            uint256 movesCount = backgammon.whiteMovesCount();

            for (uint256 j = 0; j < movesCount; j++) {
                uint256 moveValue = backgammon.whiteAvailableMoves(j);
                assertGe(moveValue, 1, "Dice value should be >= 1");
                assertLe(moveValue, 6, "Dice value should be <= 6");
            }
        }
    }

    function test_RollDiceGeneratesTwoNumbers() public {
        backgammon.rollDiceWhite();

        uint256 movesCount = backgammon.whiteMovesCount();

        // Should be 2 for normal roll or 4 for doubles
        assertTrue(
            movesCount == 2 || movesCount == 4,
            "Should have 2 or 4 moves"
        );

        // First two moves should be non-zero and valid (1-6)
        uint256 move1 = backgammon.whiteAvailableMoves(0);
        uint256 move2 = backgammon.whiteAvailableMoves(1);

        assertGe(move1, 1, "First dice should be >= 1");
        assertLe(move1, 6, "First dice should be <= 6");
        assertGe(move2, 1, "Second dice should be >= 1");
        assertLe(move2, 6, "Second dice should be <= 6");
    }
}
