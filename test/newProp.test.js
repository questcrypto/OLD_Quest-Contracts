const { assert } = require('chai')
// const { Container } = require('react-bootstrap/lib/Tab')
// const { Item } = require('react-bootstrap/lib/Breadcrumb')

const newProp = artifacts.require('./newProp.sol');


require('chai')
.use(require('chai-as-promised'))
.should()

let newContract;

before(async () =>{
     newContract = await newProp.deployed();
  })

  contract('newProp', (accounts)=>{
    describe('deployment', async() => {
    it('newProp deployed Successfully', async() => {
        const address = newContract.address
        console.log(address)
        assert.notEqual(address,0*0);
        assert.notEqual(address,'');
        assert.notEqual(address, undefined);
        assert.notEqual(address,null)
         })

  })


//   Minting

describe('Enlist a new Property On Quest', async()=>{

    it("Property Successfully Enlisted", async() =>{
        const result = await newContract.setMetaData_of_Property("500000","575000","79","11/5/20","250000",["{'Address1':'5284 S Ridgecrest','Address2':'','City':'Taylorsville','State':'UT','PostalCode':'84129','County/region':'Salt Lake County','Subdivision':'Heinz 57','TaxID':'01-2222-548','Zoning':'R-1','SchoolDistrict':'Granite','Elementary':'Eccles','JrHigh':'Johnson','HighSchool':'Bennion'}"],"2550","550","3800", "{'Roof':'Asphault Shingle','Heating':'Forced Air','AirConditioning':'Central','FloorHardwood':'Carpet','WindowCovering':'None','Pool':'Yes','PoolFeatures':'Heated,filtered','Exterior':'Brick 70%','Landscaping':'Yes','LotFacts':'.25 Acre','ExteriorFeatures':'Brick','InteriorFeatures':'','Amenities':'','Zoning':'Residential','Type':'SFR','Style':'Rambler','YearBuilt':'1977','Acres':'0.25','Deck':'Yes','Patio':'Yes','Garage':'2 Car','Carport':'No','ParkingSpaces':'3','FinBsmt':'95%','Basement':'Yes','Driveway':'Yes','Water':'City','WaterShares':'None','Spa':'None','Comments':''}")
        // console.log(result);
        console.log("Prop-prop-prrop-rprop")
    })
})

describe('Issue Coins for a property', async()=>{

    it("More Coins Issued Successfully", async() =>{
        const result = await newContract.issue_coins_for_Property(0,100000);
        // console.log(result);
        console.log("Prop-prop-prrop-rprop")
    })
})

  
describe('Get Property MetaData by its id', async()=>{

    it("Property MetaData Successfully Displayed", async() =>{
        const result = await newContract.getMetaData(0);
        
        console.log(result);
        console.log("/--------------------------/"+result+"/----------------------------------/");
        console.log(await newContract.prop(0));
        console.log("Prop-prop-prrop-rprop")
    })
})
});
