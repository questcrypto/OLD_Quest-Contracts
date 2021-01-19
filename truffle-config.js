require('babel-register');
require('babel-polyfill');
var HDWalletProvider = require("@truffle/hdwallet-provider");
// const MNEMONIC = 'YOUR WALLET KEY';
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    ropsten: {
      provider: () => new HDWalletProvider("nephew price initial daring travel furnace account venture vote dragon myth enact", "https://ropsten.infura.io/v3/8bf427bef64045af85385810d7e182ff"),
      network_id: "*",
      from: "0xA52627276196dEBb7F34B44a09e779de39b416b6"
    }
  },
  contracts_directory: './src/contracts/',
  contracts_build_directory: './src/abis/',
  plugins: [
    'truffle-contract-size'
  ],
  compilers: {
    solc: {
      version:"0.6.12",
      // version:"0.5.0",
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
}
