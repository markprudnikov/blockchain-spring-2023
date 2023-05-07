// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CurrencyExchangeOffice {

    uint public currency;
    address public owner;
    mapping(address => uint) public balances;

    constructor() {
        owner = msg.sender;
        currency = 42;
    }

    function setCurrency(uint newCurrency) public {
        require(msg.sender == owner, "Only owner can change the currency");
        currency = newCurrency;
    }

    function buy() public payable {
        require(msg.value > 0, "Amount should be greater than zero");
        
        uint tokens = (msg.value / 1 ether) * currency;
        balances[msg.sender] += tokens;
    }

    function sell(uint tokens) public {
        require(tokens > 0, "Amount of tokens should be greater than zero");
        require(balances[msg.sender] >= tokens, "You don't have such amount of tokens");
        
        uint amount = tokens / currency;
        require(address(this).balance >= amount, "Not enough Ether in the contract. Try again later.");
        
        (bool isSuccess, ) = msg.sender.call{value: amount * 1 ether}(string.concat("Exchanged tokens to Ether."));
        require(isSuccess, "Failed to transfer Ether");

        balances[msg.sender] -= tokens;
    }

    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw Ether");

        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }
}
