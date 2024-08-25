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

 	mapping(address => bool) public whitelist; 
 			//key    value// //this is the check//





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
	    function addWL(address _address) public onlyOwner {
        whitelist[_address] = true;
    }


	function setDeadline() public {
		deadline = block.timestamp + 100;
	}

    modifier onlyWhileOpen () {
    	require(block.timestamp < deadline, "Currently closed");

    	_;
    }

	receive() external payable {

		uint256 amount = msg.value / price;
		buyTokens(amount * 1e18);
	}


	function crowdsaleOpen() public view returns (bool) {
		return block.timestamp < deadline;
	}


												
	function buyTokens(uint256 _amount) public payable {	

		require(whitelist[msg.sender] = true);

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

