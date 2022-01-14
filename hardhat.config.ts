import '@nomiclabs/hardhat-waffle';
import '@nomiclabs/hardhat-etherscan';
import 'hardhat-typechain';
import 'hardhat-contract-sizer';
import "hardhat-gas-reporter";
import "@nomiclabs/hardhat-etherscan";


const BSC_TESTNET_PRIVATE_KEY = "";
const BSC_MAINNET_PRIVATE_KEY = "";
const LOCALHOST_PRIVATE_KEY = "";
const API_KEY = "";
/**
 * @type import('hardhat/config').HardhatUserConfig
 *
 */
module.exports = {
    solidity: {
        version: '0.8.9',
        settings: {
            optimizer: {
                enabled: true,
                runs: 200
            }
        }
    },
    gasReporter: {
        enabled: false,
        currency: 'CHF',
        gasPrice: 30000000000
    },
    contractSizer: {
        runOnCompile: false
    },
    defaultNetwork: "bsc_testnet",
    networks: {
        localhost: {
            url: "http://127.0.0.1:8545",
            gasPrice: 20000000000,
            accounts: [`0X${LOCALHOST_PRIVATE_KEY}`]
        },
        hardhat: {
            allowUnlimitedContractSize: true
        },
        bsc_testnet: {
            url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
            chainId: 97,
            gasPrice: 20000000000,
            accounts: [`0x${BSC_TESTNET_PRIVATE_KEY}`]
        },
        bsc_mainnet: {
            url: "https://bsc-dataseed.binance.org/",
            chainId: 56,
            gasPrice: 20000000000,
            accounts: [`0x${BSC_MAINNET_PRIVATE_KEY}`]
        }
    },
    etherscan: {
        apiKey: "" + API_KEY + ""
    },
};

