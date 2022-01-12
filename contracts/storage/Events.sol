// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Events {

    /*
    * New payment pool event
    * blockTimestamp,tokenAddress,merkleRoot
    */
    event newPaymentPool(uint256 blockTimestamp,address tokenAddress,bytes32 merkleRoot);


}
