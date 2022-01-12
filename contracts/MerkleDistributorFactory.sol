// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";

import "./storage/Storage.sol";
import "./storage/Events.sol";
import "./storage/Managers.sol";

import "./MerkleDistributor.sol";

contract MerkleDistributorFactory is AccessControlEnumerableUpgradeable, Storage, Events, Managers {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _merkleDistributorIds;


    /*
    * @notice Initialization method
    * @dev Initialization method, can only be used once,
    *      And set project default administrator
    */
    function initialize(
    ) public initializer {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    /*
    * @notice Create a new merkle payment pool
    * @dev Upload merkle Root at the end of each contest
    * @param tokenAddress_ The token address sent by this payment pool
    * @param merkleRoot_ Merkle Root of this payout pool
    */
    function newMerkleDistributor(
        address tokenAddress_,
        bytes32 merkleRoot_
    ) external {
        merkleDistributorIds[_merkleDistributorIds.current()] =
        address(new MerkleDistributor(tokenAddress_, merkleRoot_, _msgSender()));
        emit newPaymentPool(block.timestamp, tokenAddress_, merkleRoot_);
    }

}
