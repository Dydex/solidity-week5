// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract TokenVault {
    
    mapping(address => uint256) public etherBalances;
    
    
    mapping(address => mapping(address => uint256)) public tokenBalances;
    
   
    event EtherDeposited(address indexed user, uint256 amount);
    event TokenDeposited(address indexed user, address indexed token, uint256 amount);
    event EtherWithdrawn(address indexed user, uint256 amount);
    event TokenWithdrawn(address indexed user, address indexed token, uint256 amount);
    
   
    function depositEther() external payable {
        require(msg.value > 0, "Must send ETH");
        etherBalances[msg.sender] += msg.value;
        emit EtherDeposited(msg.sender, msg.value);
    }
    
   
    function depositToken(address tokenAddress, uint256 amount) external {
        require(amount > 0, "Must deposit positive amount");
        IERC20 token = IERC20(tokenAddress);
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        tokenBalances[msg.sender][tokenAddress] += amount;
        emit TokenDeposited(msg.sender, tokenAddress, amount);
    }
    
   
    function withdrawEther(uint256 amount) external {
        require(etherBalances[msg.sender] >= amount, "Insufficient balance");
        etherBalances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "ETH transfer failed");
        emit EtherWithdrawn(msg.sender, amount);
    }
    
    
    function withdrawToken(address tokenAddress, uint256 amount) external {
        require(tokenBalances[msg.sender][tokenAddress] >= amount, "Insufficient balance");
        tokenBalances[msg.sender][tokenAddress] -= amount;
        IERC20 token = IERC20(tokenAddress);
        require(token.transfer(msg.sender, amount), "Transfer failed");
        emit TokenWithdrawn(msg.sender, tokenAddress, amount);
    }
    
    
    receive() external payable {
        etherBalances[msg.sender] += msg.value;
        emit EtherDeposited(msg.sender, msg.value);
    }
}


  

    