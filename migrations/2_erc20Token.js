const ERC20Token = artifacts.require("ERC20Token");

module.exports = function (deployer,network,accounts) {
  deployer.deploy(ERC20Token,1000000000,'Supply_Token',1000000,'SUP');
};