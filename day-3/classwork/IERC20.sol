// SPDX-License-Identifier: MIT    
pragma solidity ^0.8.3;

interface IERC20 {
        function transfer(address to, uint value) external returns (bool);
        function transferFrom(address from, address to, uint value) external returns (bool);
        function balanceOf(address owner) external view returns (uint256);            
}