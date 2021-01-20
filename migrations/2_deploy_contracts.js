//var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var SLF = artifacts.require("./SLF.sol");
var SLC = artifacts.require("./SLC.sol");
var Strings = artifacts.require("./Strings.sol");
module.exports = function(deployer, network, accounts) {
  deployer.deploy(Strings,{from: accounts[0]});
  deployer.link(Strings,SLF,{from: accounts[0]});
  deployer.deploy(SLF,{from: accounts[0]});
  deployer.deploy(SLC,100000,{from: accounts[0]});
};
