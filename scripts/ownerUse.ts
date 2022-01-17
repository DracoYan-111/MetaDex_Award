// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import * as fs from 'fs';
import * as path from 'path';

import commands from 'commander'
import {ethers} from 'ethers'

const { Command } = require('commander')
const program = new Command()

const hre = require('hardhat')
const MerkleDistributorFactoryAbi = require('../artifacts/contracts/MerkleDistributorFactory.sol/MerkleDistributorFactory.json');
const TestERC20 = require('../artifacts/contracts/test/TestERC20.sol/TestERC20.json');
const global = require('../other/contractAddr.json');

program
    .version('0.0.0')
    .requiredOption(
        '-i, --input <path>',
        'input JSON file location containing a map of account addresses to string balances'
    )
