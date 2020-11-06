
const Factory = artifacts.require("Factory");
const Property = artifacts.require("Property");
const QuestToken = artifacts.require("QuestToken");
const newProp = artifacts.require("newProp");

module.exports = function(deployer) {
 
  deployer.deploy(Factory);
  deployer.deploy(Property);
  deployer.deploy(QuestToken);
  deployer.deploy(newProp);
};