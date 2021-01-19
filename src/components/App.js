import React, { Component } from 'react';
import Web3 from 'web3'
import './App.css';
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
    const chainId = await web3.eth.getChainId();
    console.log(chainId);
    console.log(networkId);
    console.log("2345678");
    console.log(accounts);
    if(networkData){
      const abi = Property.abi;
      const address = networkData.address;
      const contract = new web3.eth.Contract(abi, address);
      const totalSupply = await contract.methods.totalSupply().call();
      this.setState({contract});
      this.setState({totalSupply});
      
      console.log("hi");
      let prop;
      let orgValue;
      let coins;
      let propert_image;
      let pro_add_details;
      let prop_tax;
      let prop_insurance;
      let prop_maintainence;
      let features_prop;
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

  mint = (property,orgValue,coins,propert_image,pro_add_details,prop_tax,prop_insurance,prop_maintainence,features_prop) => {
    console.log("I was called")
    console.log(property);
    this.state.contract.methods.mint(property,orgValue,coins,propert_image,pro_add_details,prop_tax,prop_insurance,prop_maintainence,features_prop).send({ from: this.state.account })
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
                      let img = ["abc","def"];
                      let orval=50000;
                      let tx =550;
                      let otdetail = "{'Roof':'Asphault Shingle','Heating':'Forced Air','AirConditioning':'Central','FloorHardwood':'Carpet','WindowCovering':'None','Pool':'Yes','PoolFeatures':'Heated, filtered','Exterior':'Brick 70%','Landscaping':'Yes','LotFacts':'.25 Acre','ExteriorFeatures':'Brick','InteriorFeatures':'','Amenities':'','Zoning':'Residential','Type':'SFR','Style':'Rambler','YearBuilt':'1977','Acres':'0.25', 'Deck':'Yes','Patio':'Yes','Garage':'2 Car','Carport':'No','ParkingSpaces':'3','FinBsmt':'95%','Basement':'Yes','Driveway':'Yes','Water':'City','WaterShares':'None','Spa':'None','Comments':'Central Valley Home In Taylorsville with a large backyard pool. Completely remodeled in 2016 everything up to date. 6 Bedrooms and 2 Full bathrooms.Living Room and Downstairs family room laundry room etc… and a true 2 car garage'}";
                      let add=["{'Address1':'5284 S Ridgecrest','Address2':'','City':'Taylorsville','State':'UT','PostalCode':'84129','County/region':'Salt Lake County','Subdivision':'Heinz 57','TaxID': '01-2222-548','Zoning':'R-1','SchoolDistrict':'Granite','Elementary':'Eccles', 'JrHigh':'Johnson','HighSchool':'Bennion'}"]
                      this.mint(propStr,orval,orval,img,add,tx,tx,tx,otdetail);
                    }}>
                      <label>
                      Enter Property Name:
                      <input type="text" name="property"  ref={(input) => { this.prop = input }} />
                      </label>
                      <label>
                      Enter Assessed value:
                      <input type="text" name="property"  ref={(input) => { this.orgValue = input }} />
                      </label>
                      <label>
                      Initial No. of Prop Tokens
                      <input type="text" name="property"  ref={(input) => { this.coins = input }} />
                      </label>
                      <label>
                      URL for Property Images:
                      <input type="text" name="property"  ref={(input) => { this.propert_image = input }} />
                      </label>
                      <label>
                      Enter Property Address
                      <input type="text" name="property"  ref={(input) => { this.pro_add_details = input }} />
                      </label>
                      <label>
                      Enter Tax Amount:
                      <input type="text" name="property"  ref={(input) => { this.prop_tax = input }} />
                      </label>
                      <label>
                      Enter Insurance Amount:
                      <input type="text" name="property"  ref={(input) => { this.prop_insurance = input }} />
                      </label>
                      <label>
                      Enter Maintenance Amount:
                      <input type="text" name="property"  ref={(input) => { this.prop_maintainence= input }} />
                      </label>
                      <label>
                      Property Features
                      <input type="text" name="property"  ref={(input) => { this.features_prop = input }} />
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
