const { expect } = require('chai');
const { ethers } = require('hardhat');

const tokens = (n) => {
  return ethers.utils.parseUnits(n.toString(), 'ether')
}

describe('Crowdsale', () => {
  let crowdsale, token
  let accounts, deployer, user1

  beforeEach(async () => {
      //load contracts//

    const Crowdsale = await ethers.getContractFactory('Crowdsale')
    const Token = await ethers.getContractFactory('Token')

      //Deploy token//
    token = await Token.deploy('Dapp University', 'DAPP', '1000000')

      // Configure accounts//
    accounts = await ethers.getSigners()
      deployer = accounts[0]
      user1 = accounts[1]

      //deploy crowdsale//
    crowdsale = await Crowdsale.deploy(token.address)

      //send tokens to crowdsale//
    let transaction = token.connect(deployer).transfer(crowdsale.address, tokens(1000000))
    })

  describe('Deployment', () => {


    it('sends tokens to the Crowdsale contract', async () => {
      expect(await crowdsale.token()).to.equal(token.address)
    })
  

    it('returns token address', async () => {
      expect(await crowdsale.token()).to.equal(token.address)
    })
  })

  describe('Buying Tokens', () => {
    let amount = tokens(10)

    describe('Success', () => {
      it('transfers tokens', async () => {
        let transaction = await crowdsale.connect(user1).buyTokens(amount)
        let result = await transaction.wait()
        expect(await token.balanceOf(crowdsale.address)).to.equal(tokens(999990))
        expect(await token.balanceOf(user1.address)).to.equal(amount)
    })

    
    })
  })
})

