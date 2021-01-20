import React, { Component } from "react";
import SLC from "./contracts/SLC.json";
import SLF from "./contracts/SLF.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  
  state = { name: null, 
            web3: null,
            accounts: null, 
            contract: null,
            contractSLF:null,
            pendingTransaction:null,
            transactionSigned:null};

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();
      const accounts = await web3.eth.getAccounts();
    
      console.log(accounts.length)
      const networkId = await web3.eth.net.getId();
      console.log(networkId);
      const deployedNetwork = SLC.networks[networkId];
      const SLFdeployedNetwork = SLF.networks[networkId];
      console.log(deployedNetwork);
      console.log(deployedNetwork.address);
      console.log(SLFdeployedNetwork);
      console.log(SLFdeployedNetwork.address);
      const instance = new web3.eth.Contract(
        SLC.abi,
        deployedNetwork && deployedNetwork.address,
      );
      const SLFinstance = new web3.eth.Contract(
        SLF.abi,
        SLFdeployedNetwork && SLFdeployedNetwork.address,
      );

      
      this.setState({ web3, accounts, contract: instance ,contractSLF:SLFinstance}, this.runExample);

      
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  runExample = async () => {
    const {contract} = this.state;
    
    const response = await contract.methods.name().call();
    this.setState({ name: response});

    //const prop_enlist = await contractSLF.methods.ListProperty_details(1,500000,500000,250000,50).send({from:accounts[0]})
     
    //console.log(prop_enlist);

    const get_pending_transaction = await contract.methods.getPendingTransactions().call();

    console.log(get_pending_transaction);
    
    if(get_pending_transaction.length > 0){
      const trans = await contract.methods._transactions(get_pending_transaction[0]).call();
      this.setState({pendingTransaction:get_pending_transaction[0]});
      console.log(trans);
    }

    const res1 = await contract.methods.signTransaction(1).send({from:"0xa7D9a0B77C956995EA48a725454258cC478Bdf3e"});
  
    console.log(res1);
    //   const res1 = await contract.methods.approve("0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",100).send({
  //     from: accounts[0]
  // })
   // await window.ethereum.enable();
   // await contract.methods.allowance(accounts[0],"0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2").call();
    //console.log(res1);

    //console.log(res2);
    // Update state with the result.
    


  };

  

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Good to Go!</h1>
        <p>Your Truffle Box is installed and ready.</p>
        <h2>Smart Contract Example</h2>
        <p>
          If your contracts compiled and migrated successfully, below will show
          a stored value of name SLC (by default).
        </p>
        <p>
          Try changing the value stored on <strong>line 40</strong> of App.js.
        </p>
        <div>The stored value is: {this.state.name}</div>
        <div>Pending Transaction id: {this.state.pendingTransaction}</div>
      </div>
    );
  }
}

export default App;
