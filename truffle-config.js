const path = require("path");
var HDWalletProvider = require("truffle-hdwallet-provider");
const mnemonic = "comfort file wife floor destroy sleep follow symbol soap legend admit swap";
module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    develop: {
      host:"127.0.0.1",
      network_id:"*",
      port: 8545
    },
    rinkeby:{
      provider: function() { 
        return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/422ff8b52c6a43eb8a2d269ce3495c9f");
       },
       network_id: 4,
       gas: 4500000,
       gasPrice: 10000000000,
    }
  },
  compilers: {
    solc: {
      version: "0.6.2",
    },
  },
};
