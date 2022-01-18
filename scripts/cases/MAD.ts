// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import * as fs from 'fs';
import * as path from 'path';

const hre = require('hardhat')

import {BigNumber, ethers} from 'ethers'
import {ArgumentParser} from 'argparse';

const MerkleDistributorFactoryAbi = require('../artifacts/contracts/MerkleDistributorFactory.sol/MerkleDistributorFactory.json');
const TestERC20 = require('../artifacts/contracts/test/TestERC20.sol/TestERC20.json');
const contractAddr = require('../../other/contractAddr.json');
const global = require('../../other/global.json');


async function main() {

    /*
    const parser = new ArgumentParser({
            add_help: true,
             description: 'call claim transaction'
         });

         parser.add_argument('--userPrk', {required: true, help: 'user prite key'});
         parser.add_argument('--tokenAddress', {required: true, help: 'pay token address'});
         parser.add_argument('--contractAddress', {
             required: true,
             help: 'NFT Factory Contract address'
         });
     const args = parser.parse_args(process.argv.slice(2));
     let contractProxy = args.contractAddress;
     let privateKey = args.userPrk;
     console.log(privateKey);*/

    let merkleDistributorFactory = wallets(contractAddr.MerkleDistributorFactory, MerkleDistributorFactoryAbi.abi);
    let testERC20 = wallets(contractAddr.TestERC20, TestERC20.abi);
    //==================== todo approve ====================
    let tokenAllowance = await testERC20.allowance(global.loaclhost.user_address, contractAddr.MerkleDistributorFactory);
    console.log("allowance quantity:" + tokenAllowance);
    if (tokenAllowance < 100000000000000000) {
        //==================== Approve operation ====================
        let tokenApprove = await testERC20.approve(contractAddr.MerkleDistributorFactory, BigNumber.from("0xffffffffffffffffffffffffffffffff"));
        console.log("approve hash:" + tokenApprove.hash);
        await tokenApprove.wait();
        console.log("approve Finish");
    }

    //==================== todo New Merkle Distributor ====================
    let newMerkleDistributor = await merkleDistributorFactory.newMerkleDistributor("1000000000000000", contractAddr.TestERC20, "0x8bda2ad46429ff995636c7f4c624c2bf47017376b261721bb9b04f0bbefcc736");
    console.log("newMerkleDistributor hash:" + newMerkleDistributor.hash);
    await newMerkleDistributor.wait();
    console.log("newMerkleDistributor finish");

    //==================== todo User Item Claim ====================
    let itemClaim = await merkleDistributorFactory.itemClaim(0, 2, "0x0222",["0x2eb1bdabfaf6baa162de3126116ae6b0f352f688c5c2d89c02c573953eda23c0", "0xbe7c59713e084733946836a49a99055ca86ba699623bcae6ae9fef88239e8361"]);
    console.log("itemClaim hash:" + itemClaim.hash);
    await itemClaim.wait();
    console.log("itemClaim finish");

}


function wallets(addr, abi) {
    let provider = ethers.getDefaultProvider(global.loaclhost.work);
    let privateKey = global.loaclhost.private_key;
    let contract = new ethers.Contract(addr, abi, provider);
    // 从私钥获取一个签名器 Signer
    let wallet = new ethers.Wallet(privateKey, provider);
    // 使用签名器创建一个新的合约实例，它允许使用可更新状态的方法
    return contract.connect(wallet);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });

