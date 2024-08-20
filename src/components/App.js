import { useEffect, useState } from 'react'
import { Container } from 'react-bootstrap'
import { ethers } from 'ethers'

//components
import Navigation from './Navigation';



function App() {

    const [account, setAccount] = useState(null)

    // account -> variable of current acct value
    // setAccount -> function to update account value
    // null is a default value

    const loadBlockchainData = async () => {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      console.log(provider)

      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' })
      const account = ethers.utils.getAddress(accounts[0])
      console.log(account)


        //add to state
    }

    useEffect(() => {
      loadBlockchainData()
    });

  return(
  <Container>
  <Navigation />
  {/* {read from state */}}
  </Container>    
  )
}

export default App;