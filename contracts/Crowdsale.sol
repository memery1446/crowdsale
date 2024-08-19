// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Token.sol";

contract Crowdsale {
	address public owner;
	Token public token; 
	uint256 public price;
	uint256 public maxTokens;
	uint256 public tokensSold;

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

		//owner calls the constructor function with deployment
		//doesn't need to be added to arg's
	}

	receive() external payable {
		uint256 amount = msg.value / price;
		buyTokens(amount * 1e18);
	}

	function buyTokens(uint256 _amount) public payable {		
		require(msg.value == (_amount / 1e18) * price);
		require(token.balanceOf(address(this)) >= _amount);		
		require(token.transfer(msg.sender, _amount));

		tokensSold += _amount;
		

		emit Buy(_amount, msg.sender);
	}

	function finalize() public {
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

