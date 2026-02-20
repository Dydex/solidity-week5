// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract saveEther {

    mapping(address => uint) savingsBalance;

    event Deposit(address from, uint depositedAmount);
    event Withdrawal(address to, uint withdrawAmount);

    function deposit() external payable {
        require(msg.sender != address(0), "Invalid address" );
        require(msg.value > 0, "Amount must be greater than zero");

       savingsBalance[msg.sender] += msg.value;  

        emit Deposit(msg.sender, msg.value);

    }

    function withdraw(uint _value) external {
        require(msg.sender != address(0), "Invalid Address");
        require(_value > 0, "Invalid amount" );
        require(_value <= savingsBalance[msg.sender], "Insufficient funds" );
       

        savingsBalance[msg.sender] -= _value;

        (bool success, ) = payable(msg.sender).call{value: _value}("");
        require(success, "Transfer failed");
       
       emit Withdrawal(msg.sender, _value); 
    }

    function getUserSavings() external view returns(uint) {
        return savingsBalance[msg.sender];

    }

    function depositBalance() external view returns(uint) {
        return address(this).balance;
    }

    receive()external payable {}
    fallback() external {}

}
