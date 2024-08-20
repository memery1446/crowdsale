import { useEffect, useState } from 'react'
import { Container } from 'react-bootstrap'
import { ethers } from 'ethers'

//components
import Navigation from './Navigation';
import Info from './Info';
import Progress from './Progress';
import Loading from './Loading';



// ABI's

import TOKEN_ABI from '../abis/Token.json'
import CROWDSALE_ABI from '../abis/Crowdsale.json'

import config from '../config.json'

function App() {
  const [provider, setProvider] = useState(null)
  const [crowdsale, setCrowdsale] = useState(null)

    const [account, setAccount] = useState(null)
    const [accountBalance, setAccountBalance] = useState(0)

    const [price, setPrice] = useState(0)
    const [maxTokens, setMaxTokens] = useState(0)
    const [tokensSold, setTokensSold] = useState(0)

    const [isLoading, setIsLoading] = useState(true)

    // account -> variable of current acct value
    // setAccount -> function to update account value
    // null is a default value

    const loadBlockchainData = async () => {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      setProvider(provider)
    

    const token = new ethers.Contract(config[31337].token.address, TOKEN_ABI, provider)
    const crowdsale = new ethers.Contract(config[31337].crowdsale.address, CROWDSALE_ABI, provider)
    setCrowdsale(crowdsale)


      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' })
      const account = ethers.utils.getAddress(accounts[0])
      setAccount(account)

      //fetch acct bal
      const accountBalance = ethers.utils.formatUnits(await token.balanceOf(account), 18) 
      setAccountBalance(accountBalance)

      const price = ethers.utils.formatUnits(await crowdsale.price(), 18)
      setPrice(price)

      const maxTokens = ethers.utils.formatUnits(await crowdsale.maxTokens(), 18)
      setMaxTokens(maxTokens)

      const tokensSold = ethers.utils.formatUnits(await crowdsale.tokensSold(), 18)
      setTokensSold(tokensSold)

      setIsLoading(false)

    
    }

    useEffect(() => {
      if (isLoading) {
      loadBlockchainData()

      }
    }, [isLoading])

  return(
    <Container>
      <Navigation />

      <h1 className='my-4 text-center'>Introducing DApp Token!</h1>

      {isLoading ? (
          <Loading />
        ) : (
         <>
            <p className='text-center'><strong>Current Price:</strong> {price} ETH</p>
            <Progress maxTokens={maxTokens} tokensSold={tokensSold} />
         </>
        )}


        <hr />

        {account && (  
  <Info account={account} accountBalance={accountBalance} />
  )}
  </Container>    
  )
}

export default App;