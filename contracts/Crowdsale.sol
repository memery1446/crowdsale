// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Token.sol";

contract Crowdsale {
	address owner;
	Token public token; 
	uint256 public price;
	uint256 public maxTokens;
	uint256 public tokensSold;


 	mapping(address => bool) public whitelist; 

 			
	event Buy(uint256 amount, address buyer);
	event Finalize(uint256 amount, uint256 ethRaised);
	 
	constructor(
		Token _token,
		uint256 _price,
		uint256 _maxTokens

	) {

		owner = msg.sender;
		token = _token;
		price = _price;
		maxTokens = _maxTokens;	
	}


	modifier onlyOwner() {
		require(msg.sender == owner, "Caller is not the owner");

		_; 
	}

	
	function addToWhitelist(address _address) public onlyOwner {
        whitelist[_address] = true;
    }


	receive() external payable {

		uint256 amount = msg.value / price;
		buyTokens(amount * 1e18);
	}
												      
	function buyTokens(uint256 _amount) public payable {	

			
		require(whitelist[msg.sender] == true, "not on whitelist");

		require(msg.value == (_amount / 1e18) * price, "not enough ether");
		require(token.balanceOf(address(this)) >= _amount, "not enough tokens");		
		
		require(token.transfer(msg.sender, _amount));

		tokensSold += _amount;
		
		emit Buy(_amount, msg.sender);
	}

	function setPrice(uint256 _price) public onlyOwner {
		price = _price;
	}

	function finalize() public onlyOwner {
		require(token.transfer(owner, token.balanceOf(address(this))));

		uint256 value = address(this).balance;
		(bool sent, ) = owner.call{value: value }("");
		require(sent);		

		emit Finalize(tokensSold, value);
	}

}

