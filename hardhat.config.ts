import '@nomiclabs/hardhat-waffle';
import '@nomiclabs/hardhat-etherscan';
import 'hardhat-typechain';
import 'hardhat-contract-sizer';
import "hardhat-gas-reporter";
import "@nomiclabs/hardhat-etherscan";


const BSC_TESTNET_PRIVATE_KEY = "";
const BSC_MAINNET_PRIVATE_KEY = ""
const ROPSTEN_PRIVATE_KEY = "";
/**
 * @type import('hardhat/config').HardhatUserConfig
 * 0x8626f6940e2eb28930efb4cef49b2d1f2c9c1199
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
    defaultNetwork: "mainnet",
    networks: {
        localhost: {
            url: "http://127.0.0.1:8545",
            gasPrice: 20000000000,
            accounts: [`0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e`]
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
        },
        ropsten: {
            url: "https://ropsten.infura.io/v3/f350ad3f29df430bbcac0ee72826ea6e",
            chainId: 3,
            gasPrice: 30000000000,
            accounts: [`0x${ROPSTEN_PRIVATE_KEY}`]
        },
        mainnet: {
            url: `https://bsc-dataseed.binance.org/`,
        },
        hecomian: {
            url: "https://http-mainnet.hecochain.com/",
            chainId: 128,
            gasPrice: 30000000000,
            accounts: [`0xb4b9f5a08e96f922b8dccfc12d45f4a50f552661fceb53a48fe2f6474c8a1454`]
        }
    },
    etherscan: {
        apiKey: "M4JD44DFERMNVCV9Q5PC4BXNNEKD57QMT8"
    },
};

