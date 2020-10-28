import React, { Component } from 'react';
import Web3 from 'web3'
// import './App.css';
import Property from '../abis/Property.json'

class App extends Component {

  async componentWillMount() {
    await this.loadWeb3()
    await this.loadBlockchainData()
  }

  async loadWeb3() {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum)
      await window.ethereum.enable()
      
    }
    else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider)
    
    }
    else {
      window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!')
    }
  }

  async loadBlockchainData() {
    const web3 = window.web3
    // Load account
    const accounts = await web3.eth.getAccounts()
    this.setState({ account: accounts[0] })
    
    const networkId = await web3.eth.net.getId();
    const networkData = Property.networks[networkId];
    if(networkData){
      const abi = Property.abi;
      const address = networkData.address;
      const contract = new web3.eth.Contract(abi, address);
      const totalSupply = await contract.methods.totalSupply().call();
      this.setState({contract});
      this.setState({totalSupply});
      
      console.log("hi");
      let prop;
      let length = await contract.methods.totalProperties().call();
      console.log(await contract.methods.getProperties(0).call());
      console.log(Number(length));

      // console.log(length);
      for (var i = 1; i <= Number(length) ; i++) {
        prop = await contract.methods.getProperties(i-1).call();
                // this.setState({properties:prop});
        this.setState({
          properties:[...this.state.properties, prop]
        })
        console.log(this.state.properties)
        
      }

    
    }else{
      window.alert('Smart contract not deployed to detected network.')
    }
  }

  mint = (property) => {
    console.log("I was called")
    console.log(property);
    this.state.contract.methods.mint(property).send({ from: this.state.account })
    .then('receipt', (receipt) => {
      console.log("Got response")
      this.setState({
        properties: [...this.state.properties, property]
      })
    })
  }

  constructor(props) {
    super(props)
    this.state = {
      account: '',
      contract: null,
      totalSupply: 0,
      properties: []
    }
    this.mint = this.mint.bind(this)
  }

  render() {
    return (
      <div>
        <nav className="navbar navbar-light fixed-top shadow">
          <a>
            Property Token
            
          </a>
    <ul className="navbar-nav px-3">
      <li className="nav-item text-nowrap ">
    <small><span id="account">{this.state.account}</span></small>
      </li>
    </ul>
        </nav>
         
         <div className="container-fluid mt-5">
             <div className="row">
               <main role="main" className='col-lg-12 d-flex text-center'>
                   <div className="content mr-auto ml-auto">
                    <form onSubmit={(event)=>{
                      event.preventDefault();
                      const propStr = this.prop.value;
                      this.mint(propStr);
                    }}>
                      <label>
                      Enter Property Name:
                      <input type="text" name="property"  ref={(input) => { this.prop = input }} />
                      </label>
                      <input type="submit" value="Submit" />
                    </form>
                   </div>


               </main>
             </div>
              <hr/>
              <div className="row text-center">
            { this.state.properties.map((colorStr, key) => {
              return (
                <div key={key} className="col-md-3 mb-3">
                  <div className="token" style={ { backgroundColor: colorStr } }></div>
                  <div>{colorStr}</div>
                </div>
              );
            })}
          </div>

         </div>
         
               </div>
    );
  }
}

export default App;
