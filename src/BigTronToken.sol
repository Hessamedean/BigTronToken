// 0.5.1-c8a2
// Enable optimization
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "./TRC20.sol";
import "./TRC20Detailed.sol";

/**
 * @title SimpleToken
 * @dev Very simple TRC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `TRC20` functions.
 */
contract BigTronToken is TRC20, TRC20Detailed {
    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor() TRC20Detailed("BigTronToken", "BTT", 8) {
        _mint(msg.sender, 100000000000 * (10 ** uint256(tokendecimals())));
    }
}
