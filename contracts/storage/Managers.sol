// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Managers {
    // project Manager
    bytes32 public constant PROJECT_MANAGER = keccak256("PROJECT_MANAGER");
    // borrow money Manager
    bytes32 public constant BORROW_MONEY_MANAGER = keccak256("BORROW_MONEY_MANAGER");
    // modify number Manager
    bytes32 public constant MODIFY_NUMBER_MANAGER = keccak256("MODIFY_NUMBER_MANAGER");
    // pool contract Address
    bytes32 public constant MINING_POOL_CONTRACT = keccak256("MINING_POOL_CONTRACT");

}
