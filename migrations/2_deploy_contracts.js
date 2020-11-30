const Property = artifacts.require("Property");
const ERC721 = artifacts.require("ERC721");
const Strings = artifacts.require("Strings");
const ERC20 = artifacts.require("ERC20");

module.exports = function(deployer) {

   deployer.deploy(Strings);
   deployer.link(Strings,Property);
   deployer.then(async () => {
      await deployer.deploy(ERC721);
      await deployer.deploy(ERC20,"VOUCHER","*V*");
      await  deployer.deploy(Property, ERC721.address,ERC20.address);
  });
  

  
};