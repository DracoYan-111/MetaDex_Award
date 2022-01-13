// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Events {

    /*
    * New payment pool event
    * blockTimestamp,tokenAddress,newMerkleDistributor
    */
    event newPaymentPool(uint256 blockTimestamp,address tokenAddress,address newMerkleDistributor);


}
