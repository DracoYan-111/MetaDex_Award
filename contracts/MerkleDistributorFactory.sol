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
        address tokenAddress,
        bytes32 merkleRoot
    ) external {
        merkleDistributorIds[_merkleDistributorIds.current()] =
        address(new MerkleDistributor(tokenAddress, merkleRoot));
        emit newPaymentPool(block.timestamp, tokenAddress, merkleDistributorIds[_merkleDistributorIds.current()]);
    }

    /*
    * @notice The user receives the reward of the item corresponding to the id
    * @dev Call the claim method of MerkleDistributor
    * @param id Item Number
    * @param index Id corresponds to the user index of the payment pool
    * @param account Id corresponds to the user address of the payment pool
    * @param amount id corresponds to the amount received from the payment pool
    * @param merkleProof The id corresponds to the Merkle Proof of the payment pool
    */
    function itemClaim(
        uint256 id,
        uint256 index,
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof) external {
        MerkleDistributor(merkleDistributorIds[id]).claim(index,
            account,
            amount,
            merkleProof);
    }

    /*
    * @notice Add the user to the payment pool blacklist corresponding to the id
    * @dev Call the blackList method of MerkleDistributor, Project administrators use
    * @param id Item Number
    * @param userList User address array
    * @param state Blacklist status corresponding to user address
    */
    function itemBlackList(
        uint256 id,
        address[] calldata userList,
        bool state
    ) external onlyRole(PROJECT_ADMINISTRATORS){
        MerkleDistributor(merkleDistributorIds[id]).blackList(
            userList,
            state
        );
    }

    /*
    * @notice Extract the remaining tokens of the payment pool corresponding to the id
    * @dev Call the extract method of MerkleDistributor, financial administrator use
    * @param id Item Number
    * @param tokenAddress The received token address
    * @param from Receive the transfer user address
    * @param count Number of transfers
    */
    function itemExtract(
        uint256 id,
        address tokenAddress,
        address from,
        uint256 count
    ) external onlyRole(FINANCIAL_ADMINISTRATOR){
        MerkleDistributor(merkleDistributorIds[id]).extract(
            tokenAddress,
            from,
            count
        );
    }
}
