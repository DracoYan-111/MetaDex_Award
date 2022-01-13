// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./interfaces/IMerkleDistributor.sol";

contract MerkleDistributor is IMerkleDistributor, Ownable {
    address public immutable override token;
    bytes32 public immutable override merkleRoot;

    // This is a packed array of booleans.
    mapping(uint256 => uint256) private claimedBitMap;
    mapping(address => bool)public blackListUser;

    event blackListStart(uint256 blockTimestamp, address userAddress, bool state);

    /*
    * @dev Create a payment pool for users to receive the corresponding amount
    * @param token_ The token address paid by this payment pool to the user
    * @param merkleRoot_ The merkle Root to check for this payment pool
    * @param owner_ The administrator address of this payment pool
    */
    constructor(
        address token_,
        bytes32 merkleRoot_){
        token = token_;
        merkleRoot = merkleRoot_;
    }

    /*
    * @notice Check whether the user corresponding to
              the index has already received it
    * @dev Use an algorithm to achieve state uniqueness for each number
    * @param index The state of the index in this payout pool
    * @return the state of the incoming index
    */
    function isClaimed(
        uint256 index
    ) public view override returns (bool) {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        uint256 claimedWord = claimedBitMap[claimedWordIndex];
        uint256 mask = (1 << claimedBitIndex);
        return claimedWord & mask == mask;
    }

    /*
    * @dev Modify the state corresponding to
           the user index when the user successfully receives it
    * @param index The state of the index in this payout pool
    */
    function _setClaimed(
        uint256 index
    ) private {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
    }

    /*
    * @notice Users receive their own rewards
    * @dev After successful claim, modify the state corresponding to
           the user index and trigger the Claimed event
    * @param index The state of the index in this payout pool
    * @param account The address of the user in this payment pool
    * @param amount The amount corresponding to the user in this payment pool
    * @param merkleProof Merkle Proof of users in this payment pool
    */
    function claim(
        uint256 index,
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof
    ) external override {
        require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
        require(!blackListUser[account], "MerkleDistributor: Has been blacklisted.");
        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(index, account, amount));
        require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');

        // Mark it claimed and send the token.
        _setClaimed(index);
        require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');

        emit Claimed(index, account, amount);
    }

    /*
    * @notice Add user to blacklist
    * @dev Only the owner can use it, add the user to
           the blacklist, and trigger the black List Start event
    * @param userList User address array
    * @param state Blacklist status corresponding to user address
    */
    function blackList(
        address[] calldata userList,
        bool state
    ) external onlyOwner {
        for (uint256 i = 0; i < userList.length; i++) {
            blackListUser[userList[i]] = state;
            emit blackListStart(block.timestamp, userList[i], state);
        }
    }

    /*
    * @notice The administrator withdraws the remaining tokens in this payment pool
    * @dev Only the owner can use it
    * @param tokenAddress The received token address
    * @param from Receive the transfer user address
    * @param count Number of transfers
    */
    function extract(
        address tokenAddress,
        address from,
        uint256 count
    ) external onlyOwner {
        IERC20(tokenAddress).transfer(from, count);
    }
}
