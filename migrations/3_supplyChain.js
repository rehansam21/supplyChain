const supplyChain = artifacts.require("supplyChain");

module.exports = function (deployer,network,accounts) {
  deployer.deploy(supplyChain);
};