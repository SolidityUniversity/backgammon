// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Backgammon {
    uint256[26] public white;
    uint256[26] public black;

    bool public isItBlackTurn;

    // Flag to check if white player has rolled dice for current turn
    bool public whiteDiceRolled;
    // Flag to check if black player has rolled dice for current turn
    bool public blackDiceRolled;

    // Available moves for white player (up to 4 moves for doubles)
    // Value 0 means the move is used/unavailable
    uint256[4] public whiteAvailableMoves;
    uint256 public whiteMovesCount; // Number of available moves (2 for normal, 4 for doubles)

    // Available moves for black player (up to 4 moves for doubles)
    // Value 0 means the move is used/unavailable
    uint256[4] public blackAvailableMoves;
    uint256 public blackMovesCount; // Number of available moves (2 for normal, 4 for doubles)

    event WhiteTurn(uint256 _from, uint256 _to);
    event BlackTurn(uint256 _from, uint256 _to);
    event DiceRolled(bool isBlack, uint256 dice1, uint256 dice2);
    event TurnSwitched(bool isBlackTurn);

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

    // Generate pseudo-random dice values (1-6)
    function _generateRandomDice()
        internal
        view
        returns (uint256 dice1, uint256 dice2)
    {
        // Use block properties and sender address for pseudo-randomness
        uint256 seed = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.prevrandao,
                    blockhash(block.number - 1),
                    msg.sender
                )
            )
        );

        // Generate first dice (1-6)
        dice1 = (seed % 6) + 1;

        // Generate second dice from different part of seed
        uint256 seed2 = uint256(
            keccak256(abi.encodePacked(seed, block.timestamp))
        );
        dice2 = (seed2 % 6) + 1;
    }

    // Roll dice for white player with auto-generated random values
    function rollDiceWhite() public returns (uint256 dice1, uint256 dice2) {
        require(!isItBlackTurn, "Is Black Turn");

        // Generate random dice values
        (uint256 _dice1, uint256 _dice2) = _generateRandomDice();

        // Mark that dice have been rolled for this turn
        whiteDiceRolled = true;

        // Reset all moves
        for (uint256 i = 0; i < 4; i++) {
            whiteAvailableMoves[i] = 0;
        }

        // Check if it's a double (same value on both dice)
        if (_dice1 == _dice2) {
            // Double: player gets 4 moves with the same value
            whiteMovesCount = 4;
            for (uint256 i = 0; i < 4; i++) {
                whiteAvailableMoves[i] = _dice1;
            }
        } else {
            // Normal roll: player gets 2 moves with different values
            whiteMovesCount = 2;
            whiteAvailableMoves[0] = _dice1;
            whiteAvailableMoves[1] = _dice2;
        }

        emit DiceRolled(false, _dice1, _dice2);

        // Check if there are any possible moves after rolling dice
        // If no moves are possible, switch turn to black
        if (!hasWhitePossibleMove()) {
            isItBlackTurn = true;
            whiteDiceRolled = false; // Reset dice flag for next turn
            blackDiceRolled = false; // Reset black dice flag
            emit TurnSwitched(true);
        }

        // Return the dice values
        return (_dice1, _dice2);
    }

    // Move white checker - validates that the move distance matches an available move
    function moveWhite(uint256 _from, uint256 _to) public {
        require(!isItBlackTurn, "Is Black Turn");
        require(whiteDiceRolled, "Must roll dice before making a move");
        require(_from != _to, "_from and _to should be different");
        require(white[_from] > 0, "There is no white checkers on _from");

        // Handle bear off (moving to position 25)
        if (_to == 25) {
            _handleBearOff(_from);
            return;
        }

        // Regular move validation
        require(black[_to] < 2, "White cant go there");

        // If there are dead checkers, must move them first
        if (white[0] != 0) {
            require(_from == 0, "You must move dead checkers first");
        }

        // Calculate move distance (white moves from lower to higher numbers: 0->1->24->25)
        uint256 moveDistance;
        if (_to > _from) {
            moveDistance = _to - _from;
        } else {
            // Can't move backwards
            revert("Invalid move direction");
        }

        // Find and use an available move that matches the distance
        bool moveFound = false;
        for (uint256 i = 0; i < whiteMovesCount; i++) {
            if (whiteAvailableMoves[i] == moveDistance) {
                whiteAvailableMoves[i] = 0; // Mark as used
                moveFound = true;
                break;
            }
        }

        require(moveFound, "Move distance must match an available move");

        // Execute the move
        _executeWhiteMove(_from, _to);

        // Check if player can continue: must have moves left AND possible moves available
        if (_hasWhiteMovesLeft() == false || !hasWhitePossibleMove()) {
            isItBlackTurn = true;
            whiteDiceRolled = false; // Reset dice flag for next turn
            blackDiceRolled = false; // Reset black dice flag
            emit TurnSwitched(true);
        }
    }

    // Handle bear off (moving checkers off the board to position 25)
    function _handleBearOff(uint256 _from) internal {
        // Check bear off conditions: no dead checkers and all checkers in home board (19-24)
        require(white[0] == 0, "Cannot bear off while there are dead checkers");
        require(
            _isAllCheckersInHomeBoard(),
            "All checkers must be in home board (19-24) to bear off"
        );
        require(
            _from >= 19 && _from <= 24,
            "Can only bear off from positions 19-24"
        );
        require(white[_from] > 0, "No checkers on this position");

        // Find the furthest position with checkers (19-24)
        uint256 furthestPosition = 0;
        for (uint256 pos = 19; pos <= 24; pos++) {
            if (white[pos] > 0) {
                furthestPosition = pos;
            }
        }

        // Calculate required distance to bear off from _from
        uint256 requiredDistance = 25 - _from;

        // Find and use an available move
        bool moveFound = false;
        uint256 usedDiceIndex = 0;
        uint256 usedDiceValue = 0;

        // Find smallest available dice >= requiredDistance
        uint256 smallestDice = 7; // Greater than max dice value
        for (uint256 i = 0; i < whiteMovesCount; i++) {
            if (
                whiteAvailableMoves[i] >= requiredDistance &&
                whiteAvailableMoves[i] < smallestDice
            ) {
                smallestDice = whiteAvailableMoves[i];
                usedDiceIndex = i;
                moveFound = true;
            }
        }

        require(moveFound, "No available dice for bear off");

        usedDiceValue = whiteAvailableMoves[usedDiceIndex];
        whiteAvailableMoves[usedDiceIndex] = 0;

        // If dice value is greater than required (overkill), must bear off from furthest position
        if (usedDiceValue > requiredDistance) {
            require(
                _from == furthestPosition,
                "When using overkill dice, must bear off from furthest position"
            );
        }
        // If dice value equals required distance, can bear off from any position (no restriction)

        // Execute the bear off move
        white[_from] -= 1;
        white[25] += 1; // Move to saved checkers area
        emit WhiteTurn(_from, 25);

        // Check if player can continue: must have moves left AND possible moves available
        if (_hasWhiteMovesLeft() == false || !hasWhitePossibleMove()) {
            isItBlackTurn = true;
            whiteDiceRolled = false; // Reset dice flag for next turn
            blackDiceRolled = false; // Reset black dice flag
            emit TurnSwitched(true);
        }
    }

    // Check if all white checkers are in home board (positions 19-24)
    function _isAllCheckersInHomeBoard() internal view returns (bool) {
        // Check positions 1-18 (should be empty)
        for (uint256 i = 1; i <= 18; i++) {
            if (white[i] > 0) {
                return false;
            }
        }
        return true;
    }

    // Check if white player has any moves left (available dice)
    function _hasWhiteMovesLeft() internal view returns (bool) {
        for (uint256 i = 0; i < whiteMovesCount; i++) {
            if (whiteAvailableMoves[i] > 0) {
                return true;
            }
        }
        return false;
    }

    // Check if white player has any physically possible move
    function hasWhitePossibleMove() public view returns (bool) {
        // If there are no available dice, no moves possible
        if (!_hasWhiteMovesLeft()) {
            return false;
        }

        // Check each available move
        for (uint256 i = 0; i < whiteMovesCount; i++) {
            uint256 moveDistance = whiteAvailableMoves[i];
            if (moveDistance == 0) continue; // Skip used moves

            // If there are dead checkers, check if we can move them
            if (white[0] > 0) {
                uint256 to = moveDistance; // From 0 (dead) to moveDistance
                if (to <= 24 && black[to] < 2) {
                    return true; // Can move dead checker
                }
            } else {
                // Check if all checkers are in home board (can bear off)
                bool canBearOff = _isAllCheckersInHomeBoard();

                // Find furthest position with checkers (for bear off logic)
                uint256 furthestPosition = 0;
                if (canBearOff) {
                    for (uint256 pos = 19; pos <= 24; pos++) {
                        if (white[pos] > 0) {
                            furthestPosition = pos;
                        }
                    }
                }

                // Check all positions with white checkers
                for (uint256 from = 1; from <= 24; from++) {
                    if (white[from] > 0) {
                        uint256 to = from + moveDistance;
                        // Check if move is valid (within board or bear off)
                        if (to <= 25) {
                            // Regular move within board
                            if (to <= 24 && black[to] < 2) {
                                return true; // Valid move found
                            }
                            // Bear off (to == 25)
                            if (to == 25 && canBearOff) {
                                uint256 requiredDistance = 25 - from;
                                // If dice exactly matches required distance, can bear off from any position
                                if (moveDistance == requiredDistance) {
                                    return true;
                                }
                                // If dice is greater (overkill), can only bear off from furthest position
                                if (
                                    moveDistance > requiredDistance &&
                                    from == furthestPosition
                                ) {
                                    return true;
                                }
                            }
                        }
                    }
                }
            }
        }

        return false; // No valid moves found
    }

    // Internal function to execute white checker movement
    function _executeWhiteMove(uint256 _from, uint256 _to) internal {
        // Move checker from source to destination
        white[_from] -= 1;

        // If landing on opponent's single checker, send it to bar
        if (black[_to] == 1) {
            black[_to] -= 1;
            black[25]++; // Black's dead checkers go to cell 25
        }

        white[_to] += 1;
        emit WhiteTurn(_from, _to);
    }

    // Internal function for testing/debugging (can be removed later)
    function _moveWhite(uint256 _from, uint256 _to) public {
        require(!isItBlackTurn, "Is Black Turn");
        require(_from != _to, "_from and _to should be different");
        require(white[_from] > 0, "There is no white checkers on _from");
        require(black[_to] < 2, "White cant go there");
        if (white[0] != 0) {
            require(_from == 0, "You must move dead checkers");
        }

        white[_from] -= 1;

        if (black[_to] == 1) {
            black[_to] -= 1;
            black[25]++;
        }

        white[_to] += 1;
        emit WhiteTurn(_from, _to);
    }

    // ============ BLACK PLAYER FUNCTIONS ============

    // Roll dice for black player with auto-generated random values
    function rollDiceBlack() public returns (uint256 dice1, uint256 dice2) {
        require(isItBlackTurn, "Is White Turn");

        // Generate random dice values
        (uint256 _dice1, uint256 _dice2) = _generateRandomDice();

        // Mark that dice have been rolled for this turn
        blackDiceRolled = true;

        // Reset all moves
        for (uint256 i = 0; i < 4; i++) {
            blackAvailableMoves[i] = 0;
        }

        // Check if it's a double (same value on both dice)
        if (_dice1 == _dice2) {
            // Double: player gets 4 moves with the same value
            blackMovesCount = 4;
            for (uint256 i = 0; i < 4; i++) {
                blackAvailableMoves[i] = _dice1;
            }
        } else {
            // Normal roll: player gets 2 moves with different values
            blackMovesCount = 2;
            blackAvailableMoves[0] = _dice1;
            blackAvailableMoves[1] = _dice2;
        }

        emit DiceRolled(true, _dice1, _dice2);

        // Check if there are any possible moves after rolling dice
        // If no moves are possible, switch turn to white
        if (!hasBlackPossibleMove()) {
            isItBlackTurn = false;
            blackDiceRolled = false; // Reset dice flag for next turn
            whiteDiceRolled = false; // Reset white dice flag
            emit TurnSwitched(false);
        }

        // Return the dice values
        return (_dice1, _dice2);
    }

    // Move black checker - validates that the move distance matches an available move
    function moveBlack(uint256 _from, uint256 _to) public {
        require(isItBlackTurn, "Is White Turn");
        require(blackDiceRolled, "Must roll dice before making a move");
        require(_from != _to, "_from and _to should be different");
        require(black[_from] > 0, "There is no black checkers on _from");

        // Handle bear off (moving to position 0)
        if (_to == 0) {
            _handleBlackBearOff(_from);
            return;
        }

        // Regular move validation
        require(white[_to] < 2, "Black cant go there");

        // If there are dead checkers, must move them first
        if (black[25] != 0) {
            require(_from == 25, "You must move dead checkers first");
        }

        // Calculate move distance (black moves from higher to lower numbers: 25->24->1->0)
        uint256 moveDistance;
        if (_to < _from) {
            moveDistance = _from - _to;
        } else {
            // Can't move forwards (for black, forwards means higher numbers)
            revert("Invalid move direction");
        }

        // Find and use an available move that matches the distance
        bool moveFound = false;
        for (uint256 i = 0; i < blackMovesCount; i++) {
            if (blackAvailableMoves[i] == moveDistance) {
                blackAvailableMoves[i] = 0; // Mark as used
                moveFound = true;
                break;
            }
        }

        require(moveFound, "Move distance must match an available move");

        // Execute the move
        _executeBlackMove(_from, _to);

        // Check if player can continue: must have moves left AND possible moves available
        if (_hasBlackMovesLeft() == false || !hasBlackPossibleMove()) {
            isItBlackTurn = false;
            blackDiceRolled = false; // Reset dice flag for next turn
            whiteDiceRolled = false; // Reset white dice flag
            emit TurnSwitched(false);
        }
    }

    // Handle black bear off (moving checkers off the board to position 0)
    function _handleBlackBearOff(uint256 _from) internal {
        // Check bear off conditions: no dead checkers and all checkers in home board (6-1)
        require(
            black[25] == 0,
            "Cannot bear off while there are dead checkers"
        );
        require(
            _isAllCheckersInHomeBoardBlack(),
            "All checkers must be in home board (6-1) to bear off"
        );
        require(
            _from >= 1 && _from <= 6,
            "Can only bear off from positions 1-6"
        );
        require(black[_from] > 0, "No checkers on this position");

        // Find the furthest position with checkers (6-1, furthest means highest number)
        uint256 furthestPosition = 0;
        for (uint256 pos = 1; pos <= 6; pos++) {
            if (black[pos] > 0) {
                furthestPosition = pos;
            }
        }

        // Calculate required distance to bear off from _from
        // For black: from position _from to position 0, distance is _from
        uint256 requiredDistance = _from;

        // Find and use an available move
        bool moveFound = false;
        uint256 usedDiceIndex = 0;
        uint256 usedDiceValue = 0;

        // Find smallest available dice >= requiredDistance
        uint256 smallestDice = 7; // Greater than max dice value
        for (uint256 i = 0; i < blackMovesCount; i++) {
            if (
                blackAvailableMoves[i] >= requiredDistance &&
                blackAvailableMoves[i] < smallestDice
            ) {
                smallestDice = blackAvailableMoves[i];
                usedDiceIndex = i;
                moveFound = true;
            }
        }

        require(moveFound, "No available dice for bear off");

        usedDiceValue = blackAvailableMoves[usedDiceIndex];
        blackAvailableMoves[usedDiceIndex] = 0;

        // If dice value is greater than required (overkill), must bear off from furthest position
        if (usedDiceValue > requiredDistance) {
            require(
                _from == furthestPosition,
                "When using overkill dice, must bear off from furthest position"
            );
        }
        // If dice value equals required distance, can bear off from any position (no restriction)

        // Execute the bear off move
        black[_from] -= 1;
        black[0] += 1; // Move to saved checkers area (position 0 for black)
        emit BlackTurn(_from, 0);

        // Check if player can continue: must have moves left AND possible moves available
        if (_hasBlackMovesLeft() == false || !hasBlackPossibleMove()) {
            isItBlackTurn = false;
            blackDiceRolled = false; // Reset dice flag for next turn
            whiteDiceRolled = false; // Reset white dice flag
            emit TurnSwitched(false);
        }
    }

    // Check if all black checkers are in home board (positions 6-1)
    function _isAllCheckersInHomeBoardBlack() internal view returns (bool) {
        // Check positions 7-24 (should be empty)
        for (uint256 i = 7; i <= 24; i++) {
            if (black[i] > 0) {
                return false;
            }
        }
        return true;
    }

    // Check if black player has any moves left (available dice)
    function _hasBlackMovesLeft() internal view returns (bool) {
        for (uint256 i = 0; i < blackMovesCount; i++) {
            if (blackAvailableMoves[i] > 0) {
                return true;
            }
        }
        return false;
    }

    // Check if black player has any physically possible move
    function hasBlackPossibleMove() public view returns (bool) {
        // If there are no available dice, no moves possible
        if (!_hasBlackMovesLeft()) {
            return false;
        }

        // Check each available move
        for (uint256 i = 0; i < blackMovesCount; i++) {
            uint256 moveDistance = blackAvailableMoves[i];
            if (moveDistance == 0) continue; // Skip used moves

            // If there are dead checkers, check if we can move them
            if (black[25] > 0) {
                // From 25 (dead) to position, must move backwards
                // Check for underflow: can only move if moveDistance <= 25
                if (moveDistance <= 25) {
                    uint256 to = 25 - moveDistance;
                    // Can move to positions 1-24 (regular move) or 0 (not allowed from dead)
                    if (to >= 1 && to <= 24 && white[to] < 2) {
                        return true; // Can move dead checker
                    }
                }
            } else {
                // Check if all checkers are in home board (can bear off)
                bool canBearOff = _isAllCheckersInHomeBoardBlack();

                // Find furthest position with checkers (for bear off logic)
                uint256 furthestPosition = 0;
                if (canBearOff) {
                    for (uint256 pos = 1; pos <= 6; pos++) {
                        if (black[pos] > 0) {
                            furthestPosition = pos;
                        }
                    }
                }

                // Check all positions with black checkers
                for (uint256 from = 1; from <= 24; from++) {
                    if (black[from] > 0) {
                        // Black moves backwards, so to = from - moveDistance
                        // Check for underflow: can only move if moveDistance <= from
                        if (moveDistance <= from) {
                            uint256 to = from - moveDistance;
                            // Regular move within board
                            if (to >= 1 && to <= 24 && white[to] < 2) {
                                return true; // Valid move found
                            }
                        }
                        // Bear off (to == 0) - check if moveDistance >= from
                        if (canBearOff && moveDistance >= from) {
                            uint256 requiredDistance = from; // Distance from from to 0
                            // If dice exactly matches required distance, can bear off from any position
                            if (moveDistance == requiredDistance) {
                                return true;
                            }
                            // If dice is greater (overkill), can only bear off from furthest position
                            if (
                                moveDistance > requiredDistance &&
                                from == furthestPosition
                            ) {
                                return true;
                            }
                        }
                    }
                }
            }
        }

        return false; // No valid moves found
    }

    // Internal function to execute black checker movement
    function _executeBlackMove(uint256 _from, uint256 _to) internal {
        // Move checker from source to destination
        black[_from] -= 1;

        // If landing on opponent's single checker, send it to bar
        if (white[_to] == 1) {
            white[_to] -= 1;
            white[0]++; // White's dead checkers go to cell 0
        }

        black[_to] += 1;
        emit BlackTurn(_from, _to);
    }
}
