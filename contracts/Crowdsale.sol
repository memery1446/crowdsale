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
	uint256 public deadline;
	uint256 public start;
	uint256 public end;

		// Store whitelisted users in smart contract
 	mapping(address => bool) public whitelist; 
 	whitelist[owner.address] true;
 			
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

	modifier crowdsaleIsOver() {
		require(block.timestamp<= end, "Crowdsale is Over");
		_;
	}

	modifier onlyOwner() {
		require(msg.sender == owner, "Caller is not the owner");

		_; 
	}

		// 1. create function to allow only owner to add people to whitelist


	function addToWhitelist(address _address) public onlyOwner {
        whitelist[_address] = true;
    }

// 1. Create a timestamp in your contract that restricts when people can buy.
    function startCrowdsale() public {
    	start = block.timestamp; 
    }
// 2. Require that this date is in the past before the purchase.
    function endCrowdsale() public  {
    	end = start + 2 weeks;
    }

	receive() external payable {

		uint256 amount = msg.value / price;
		buyTokens(amount * 1e18);
	}
												
	function buyTokens(uint256 _amount) public payable {	

			// 2.Only let people who are whitelisted buy tokens
		require(whitelist[msg.sender] == true, "not on whitelist");

		require(block.timestamp > start + 100, "crowdsale is closed");

		require(msg.value == (_amount / 1e18) * price);
		require(token.balanceOf(address(this)) >= _amount);		
		require(token.transfer(msg.sender, _amount));

		tokensSold += _amount;
		

		emit Buy(_amount, msg.sender);
	}

	function setPrice(uint256 _price) public onlyOwner {
		price = _price;
	}

	function finalize() public onlyOwner {

		//send eth to creator
		require(token.transfer(owner, token.balanceOf(address(this))));

		//send remaining tokens to creator
		uint256 value = address(this).balance;
		(bool sent, ) = owner.call{value: value }("");
		require(sent);		


		//preferred pattern for sending eth

		emit Finalize(tokensSold, value);
	}



	
}

