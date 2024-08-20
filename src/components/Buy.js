
import Form from 'react-bootstrap/Form'; //1
import Button from 'react-bootstrap/Button';//2
import Row from 'react-bootstrap/Row'; //3
import Col from 'react-bootstrap/Col'; //4
import Spinner from 'react-bootstrap/Spinner'; //5


const Buy = ({ provider, price, crowdsale, setIsLoading }) => {

    const buyHandler = async (e) => {
        e.preventDefault()
        console.log("buying tokens...")
    }
  

    return (
        <Form onSubmit={buyHandler} style={{ maxWidth: '800px', margin: '50px auto' }}>
            <Form.Group as={Row}>
                <Col>
                    <Form.Control type="number" placeholder="Enter amount" />
            
                    </Col>
                    <Col className='text-center'>
                        <Button variant="primary" type="submit" style={{ width: '100%' }}>
                            Buy Tokens
                        </Button>
                </Col>
            </Form.Group>
        </Form>
    )
}

export default Buy;
