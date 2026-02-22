// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "forge-std/Script.sol";
import "../src/ERC20.sol";
import "../src/saveTokens.sol";
import "../src/saveEther.sol";
import "../src/schoolMgn.sol";
import "../src/Todo.sol";

contract DeployScript is Script {
    ERC20 public erc20Token;
    SaveEther public saveEther;
    SaveTokens public saveTokens;
    schoolMgn public schoolManagement;
    Todo public todo;

    uint8 decimals = 18;
    uint256 initialSupply = 200_000 * 10 ** uint256(decimals);

    function run() external {
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        deployContracts();

        vm.stopBroadcast();
    }

    function deployContracts() internal {
        erc20Token = new ERC20("Dolapo", "DP", decimals);
        saveTokens = new SaveTokens(address(erc20Token));
        saveEther = new SaveEther();
        schoolManagement= new schoolMgn(address(erc20Token));
        todo = new Todo();
    }

}