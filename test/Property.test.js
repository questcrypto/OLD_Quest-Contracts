const { assert } = require('chai')
// const { Container } = require('react-bootstrap/lib/Tab')
// const { Item } = require('react-bootstrap/lib/Breadcrumb')

const Property = artifacts.require('./Property.sol')

require('chai')
.use(require('chai-as-promised'))
.should()

let comp;
before(async () =>{
  comp = await Property.deployed()
})
contract('Property', (accounts)=>{

  let property
  describe('deployment', async() => {
    it('deployed Successfully', async() => {
   const address = comp.address
   console.log(address)
   assert.notEqual(address,0*0);
   assert.notEqual(address,'');
   assert.notEqual(address, undefined);
   assert.notEqual(address,null)
    })


    it('has a name', async()=>{
      const name = await comp.name()
      assert.equal(name,'Property')
    })

    it('has a symbol', async()=>{
      const symbol = await comp.symbol()
      assert.equal(symbol,'QST_NFT')
    })
  })


  // Minitng

  describe('minting', async() =>{

    it('creates a new token', async() =>{
      const result = await comp.mint("prop1","50000","25000",["abc","def"],["{'Address1':'5284 S Ridgecrest','Address2':'','City':'Taylorsville','State':'UT','PostalCode':'84129','County/region':'Salt Lake County','Subdivision':'Heinz 57','TaxID': '01-2222-548','Zoning':'R-1','SchoolDistrict':'Granite','Elementary':'Eccles', 'JrHigh':'Johnson','HighSchool':'Bennion'}"],"550","3800","555","{'Roof':'Asphault Shingle','Heating':'Forced Air','AirConditioning':'Central','FloorHardwood':'Carpet','WindowCovering':'None','Pool':'Yes','PoolFeatures':'Heated, filtered','Exterior':'Brick 70%','Landscaping':'Yes','LotFacts':'.25 Acre','ExteriorFeatures':'Brick','InteriorFeatures':'','Amenities':'','Zoning':'Residential','Type':'SFR','Style':'Rambler','YearBuilt':'1977','Acres':'0.25', 'Deck':'Yes','Patio':'Yes','Garage':'2 Car','Carport':'No','ParkingSpaces':'3','FinBsmt':'95%','Basement':'Yes','Driveway':'Yes','Water':'City','WaterShares':'None','Spa':'None','Comments':'Central Valley Home In Taylorsville with a large backyard pool. Completely remodeled in 2016 everything up to date. 6 Bedrooms and 2 Full bathrooms.Living Room and Downstairs family room laundry room etc… and a true 2 car garage'}");
      const totalSupply = await comp.totalSupply()
      // SUCCESS
      assert.equal(totalSupply,1)
      const event = result.logs[0].args;
      assert.equal(event.tokenId.toNumber(),1,'id is correct');
      assert.equal(event.from,'0x0000000000000000000000000000000000000000', 'from is correct');
      assert.equal(event.to,accounts[0], 'to is correct')

      // IF FAILS

      // await comp.mint('prop1').should.be.rejected;
    })
  })
 

  // INDEXING

  describe('indexing', async () => {
    it('lists properties', async () => {
      // Mint 3 more tokens
      await comp.mint("prop2","50000","25000",["abc","def"],["{'Address1':'5284 S Ridgecrest','Address2':'','City':'Taylorsville','State':'UT','PostalCode':'84129','County/region':'Salt Lake County','Subdivision':'Heinz 57','TaxID': '01-2222-548','Zoning':'R-1','SchoolDistrict':'Granite','Elementary':'Eccles', 'JrHigh':'Johnson','HighSchool':'Bennion'}"],"550","3800","555","{'Roof':'Asphault Shingle','Heating':'Forced Air','AirConditioning':'Central','FloorHardwood':'Carpet','WindowCovering':'None','Pool':'Yes','PoolFeatures':'Heated, filtered','Exterior':'Brick 70%','Landscaping':'Yes','LotFacts':'.25 Acre','ExteriorFeatures':'Brick','InteriorFeatures':'','Amenities':'','Zoning':'Residential','Type':'SFR','Style':'Rambler','YearBuilt':'1977','Acres':'0.25', 'Deck':'Yes','Patio':'Yes','Garage':'2 Car','Carport':'No','ParkingSpaces':'3','FinBsmt':'95%','Basement':'Yes','Driveway':'Yes','Water':'City','WaterShares':'None','Spa':'None','Comments':'Central Valley Home In Taylorsville with a large backyard pool. Completely remodeled in 2016 everything up to date. 6 Bedrooms and 2 Full bathrooms.Living Room and Downstairs family room laundry room etc… and a true 2 car garage'}")
      await comp.mint('prop3',"50000","25000",["abc","def"],["{'Address1':'5284 S Ridgecrest','Address2':'','City':'Taylorsville','State':'UT','PostalCode':'84129','County/region':'Salt Lake County','Subdivision':'Heinz 57','TaxID': '01-2222-548','Zoning':'R-1','SchoolDistrict':'Granite','Elementary':'Eccles', 'JrHigh':'Johnson','HighSchool':'Bennion'}"],"550","3800","555","{'Roof':'Asphault Shingle','Heating':'Forced Air','AirConditioning':'Central','FloorHardwood':'Carpet','WindowCovering':'None','Pool':'Yes','PoolFeatures':'Heated, filtered','Exterior':'Brick 70%','Landscaping':'Yes','LotFacts':'.25 Acre','ExteriorFeatures':'Brick','InteriorFeatures':'','Amenities':'','Zoning':'Residential','Type':'SFR','Style':'Rambler','YearBuilt':'1977','Acres':'0.25', 'Deck':'Yes','Patio':'Yes','Garage':'2 Car','Carport':'No','ParkingSpaces':'3','FinBsmt':'95%','Basement':'Yes','Driveway':'Yes','Water':'City','WaterShares':'None','Spa':'None','Comments':'Central Valley Home In Taylorsville with a large backyard pool. Completely remodeled in 2016 everything up to date. 6 Bedrooms and 2 Full bathrooms.Living Room and Downstairs family room laundry room etc… and a true 2 car garage'}")
      await comp.mint('pr op4',"50000","25000",["abc","def"],["{'Address1':'5284 S Ridgecrest','Address2':'','City':'Taylorsville','State':'UT','PostalCode':'84129','County/region':'Salt Lake County','Subdivision':'Heinz 57','TaxID': '01-2222-548','Zoning':'R-1','SchoolDistrict':'Granite','Elementary':'Eccles', 'JrHigh':'Johnson','HighSchool':'Bennion'}"],"550","3800","555","{'Roof':'Asphault Shingle','Heating':'Forced Air','AirConditioning':'Central','FloorHardwood':'Carpet','WindowCovering':'None','Pool':'Yes','PoolFeatures':'Heated, filtered','Exterior':'Brick 70%','Landscaping':'Yes','LotFacts':'.25 Acre','ExteriorFeatures':'Brick','InteriorFeatures':'','Amenities':'','Zoning':'Residential','Type':'SFR','Style':'Rambler','YearBuilt':'1977','Acres':'0.25', 'Deck':'Yes','Patio':'Yes','Garage':'2 Car','Carport':'No','ParkingSpaces':'3','FinBsmt':'95%','Basement':'Yes','Driveway':'Yes','Water':'City','WaterShares':'None','Spa':'None','Comments':'Central Valley Home In Taylorsville with a large backyard pool. Completely remodeled in 2016 everything up to date. 6 Bedrooms and 2 Full bathrooms.Living Room and Downstairs family room laundry room etc… and a true 2 car garage'}")
      // console.log(await comp.prop());
      const totalSupply = await comp.totalSupply()
      console.log(await comp.getProperties(1)); 
      console.log(await comp.proptest());
      let prop;
      let result = []
 
      for (var i = 1; i <= totalSupply; i++) {
        prop = await comp.properties(i - 1)
        result.push(prop)
      }
      console.log(result);
      
      let expected = ['prop1', 'prop2', 'prop3', 'prop4']
      assert.equal(result.join(','), expected.join(','))
    })
  })
  
})




