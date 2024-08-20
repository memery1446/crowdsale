import { useEffect, useState } from 'react'
import { Container } from 'react-bootstrap'
import { ethers } from 'ethers'

//components
import Navigation from './Navigation';
import Info from './Info';


function App() {

    const [account, setAccount] = useState(null)




    // account -> variable of current acct value
    // setAccount -> function to update account value
    // null is a default value

    const loadBlockchainData = async () => {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
    

      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' })
      const account = ethers.utils.getAddress(accounts[0])
      setAccount(account)


    
    }

    useEffect(() => {
      loadBlockchainData()
    });

  return(
  <Container>
  <Navigation />
  <hr />
  {account && (
  
  <Info account={account} />
  )}
  </Container>    
  )
}

export default App;