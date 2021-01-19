const Property = artifacts.require("Property");
const ERC721 = artifacts.require("ERC721");
const Strings = artifacts.require("Strings");
const ERC20 = artifacts.require("ERC20");
const MarketPlace = artifacts.require("MarketPlace");

module.exports = function(deployer) {

   deployer.deploy(Strings);
   deployer.link(Strings,ERC721);
   deployer.deploy(Strings);
   deployer.link(Strings,Property);
   deployer.deploy(Strings);
   deployer.link(Strings,MarketPlace);
   deployer.then(async () => {
      await deployer.deploy(ERC721,"QuestNonFungible","QNF");
      await deployer.deploy(ERC20,"QuestVOUCHER","QV");
      await deployer.deploy(Property,ERC20.address,ERC721.address);
      await deployer.deploy(MarketPlace,ERC20.address,Property.address); 
  });
  

  
};