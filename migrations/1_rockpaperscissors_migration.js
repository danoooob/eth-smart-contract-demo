var RockPaperScissors = artifacts.require("./RockPaperScissors.sol");

module.exports = function(deployer) {
    // Demo is the contract's name
    deployer.deploy(RockPaperScissors);
};
