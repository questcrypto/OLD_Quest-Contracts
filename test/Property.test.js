const { assert } = require('chai')
// const { Container } = require('react-bootstrap/lib/Tab')
// const { Item } = require('react-bootstrap/lib/Breadcrumb')

const Property = artifacts.require('./Property.sol');
const ERC20 = artifacts.require('./ERC20.sol');
const ERC721 = artifacts.require('./ERC721.sol');

require('chai')
.use(require('chai-as-promised'))
.should()

let comp;
let erc20;
let erc721;
let prop_address;
let erc20address;
let erc721address;

contract('Property', (accounts)=>{

  let property
  describe('deployment', async() => {
    before(async () =>{
      comp = await Property.deployed()
      erc20 = await ERC20.deployed()
      erc721 = await ERC721.deployed()
    })
   
    it('deployed Successfully', async() => {
   prop_address = comp.address
   erc20address = erc20.address
   erc721address = erc721.address
   console.log(prop_address)
   console.log(erc20address);
   console.log(erc721address);
   assert.notEqual(prop_address,0*0);
   assert.notEqual(prop_address,'');
   assert.notEqual(prop_address, undefined);
   assert.notEqual(prop_address,null)
   assert.notEqual(erc20address,0*0);
   assert.notEqual(erc20address,'');
   assert.notEqual(erc20address, undefined);
   assert.notEqual(erc20address,null)
   assert.notEqual(erc721address,0*0);
   assert.notEqual(erc721address,'');
   assert.notEqual(erc721address, undefined);
   assert.notEqual(erc721address,null)
    })


  })
})


  describe('minting', async() =>{

    it('creates a new token', async() =>{
      
      let result = await comp.mint("prop1","50000","2500","jhdjcjdbjcbjkbbbx",["{'Address1':'5284 S Ridgecrest','Address2':'','City':'Taylorsville','State':'UT','PostalCode':'84129','County/region':'Salt Lake County','Subdivision':'Heinz 57','TaxID': '01-2222-548','Zoning':'R-1','SchoolDistrict':'Granite','Elementary':'Eccles', 'JrHigh':'Johnson','HighSchool':'Bennion'}"],"550","3800","555","{'Roof':'Asphault Shingle','Heating':'Forced Air','AirConditioning':'Central','FloorHardwood':'Carpet','WindowCovering':'None','Pool':'Yes','PoolFeatures':'Heated, filtered','Exterior':'Brick 70%','Landscaping':'Yes','LotFacts':'.25 Acre','ExteriorFeatures':'Brick','InteriorFeatures':'','Amenities':'','Zoning':'Residential','Type':'SFR','Style':'Rambler','YearBuilt':'1977','Acres':'0.25', 'Deck':'Yes','Patio':'Yes','Garage':'2 Car','Carport':'No','ParkingSpaces':'3','FinBsmt':'95%','Basement':'Yes','Driveway':'Yes','Water':'City','WaterShares':'None','Spa':'None','Comments':'Central Valley Home In Taylorsville with a large backyard pool. Completely remodeled in 2016 everything up to date. 6 Bedrooms and 2 Full bathrooms.Living Room and Downstairs family room laundry room etc… and a true 2 car garage'}");
      console.log(result);
      // const event = result.logs[0].args;
      // // console.log(comp.proptest);
      // console.log(event.tokenId.toNumber());
      // console.log("Above this000");
      // assert.equal(event.tokenId.toNumber(),1,'id is correct');
      // assert.equal(event.from,'0x0000000000000000000000000000000000000000', 'from is correct');
      // assert.equal(event.to,accounts[0], 'to is correct')

      // IF FAILS

      // await comp.mint('prop1').should.be.rejected;
    })
  })
 
  describe('minting', async() =>{

    it('creates a new token', async() =>{
      
      let result = await comp.mint("prop2","60000","2500","jhdjcjdbjcbjkbbbx",["{'Address1':'5284 S Ridgecrest','Address2':'','City':'Taylorsville','State':'UT','PostalCode':'84129','County/region':'Salt Lake County','Subdivision':'Heinz 57','TaxID': '01-2222-548','Zoning':'R-1','SchoolDistrict':'Granite','Elementary':'Eccles', 'JrHigh':'Johnson','HighSchool':'Bennion'}"],"550","3800","555","{'Roof':'Asphault Shingle','Heating':'Forced Air','AirConditioning':'Central','FloorHardwood':'Carpet','WindowCovering':'None','Pool':'Yes','PoolFeatures':'Heated, filtered','Exterior':'Brick 70%','Landscaping':'Yes','LotFacts':'.25 Acre','ExteriorFeatures':'Brick','InteriorFeatures':'','Amenities':'','Zoning':'Residential','Type':'MFR','Style':'Rambler','YearBuilt':'1977','Acres':'0.25', 'Deck':'Yes','Patio':'Yes','Garage':'2 Car','Carport':'No','ParkingSpaces':'3','FinBsmt':'95%','Basement':'Yes','Driveway':'Yes','Water':'City','WaterShares':'None','Spa':'None','Comments':'Central Valley Home In Taylorsville with a large backyard pool. Completely remodeled in 2016 everything up to date. 6 Bedrooms and 2 Full bathrooms.Living Room and Downstairs family room laundry room etc… and a true 2 car garage'}");
      console.log(result);
    })
  })
  describe('minting', async() =>{

    it('creates a new token', async() =>{
      
      let result = await comp.mint("prop3","70000","2500","jhdjcjdbjcbjkbbbx",["{'Address1':'5284 S Ridgecrest','Address2':'','City':'Taylorsville','State':'UT','PostalCode':'84129','County/region':'Salt Lake County','Subdivision':'Heinz 57','TaxID': '01-2222-548','Zoning':'R-1','SchoolDistrict':'Granite','Elementary':'Eccles', 'JrHigh':'Johnson','HighSchool':'Bennion'}"],"550","3800","555","{'Roof':'Asphault Shingle','Heating':'Forced Air','AirConditioning':'Central','FloorHardwood':'Carpet','WindowCovering':'None','Pool':'Yes','PoolFeatures':'Heated, filtered','Exterior':'Brick 70%','Landscaping':'Yes','LotFacts':'.25 Acre','ExteriorFeatures':'Brick','InteriorFeatures':'','Amenities':'','Zoning':'Residential','Type':'MFR','Style':'Rambler','YearBuilt':'1977','Acres':'0.25', 'Deck':'Yes','Patio':'Yes','Garage':'2 Car','Carport':'No','ParkingSpaces':'3','FinBsmt':'95%','Basement':'Yes','Driveway':'Yes','Water':'City','WaterShares':'None','Spa':'None','Comments':'Central Valley Home In Taylorsville with a large backyard pool. Completely remodeled in 2016 everything up to date. 6 Bedrooms and 2 Full bathrooms.Living Room and Downstairs family room laundry room etc… and a true 2 car garage'}");
      console.log(result);
    })
  })


  describe('Display Listed Property according to type MFR', async() =>{

    it('Displays properties with given type', async() =>{

      let no_of_properties = await comp.totalProperties();
      for(let i=1;i<=no_of_properties.words[0];i++){
        let result = await erc721.prop(i);
        let obj = result.property_features;
        let str = obj.replace(/[']/g,'"');

        let obj_str = JSON.parse(str);
        if(obj_str.Type === "MFR")
        console.log(await comp.getProperties(i-1));
      }
     
      
      
    })
  })
  describe('Display Listed Property according to type SFR', async() =>{

    it('Displays properties with given type', async() =>{

      let no_of_properties = await comp.totalProperties();
      for(let i=1;i<=no_of_properties.words[0];i++){
        let result = await erc721.prop(i);
        let obj = result.property_features;
        let str = obj.replace(/[']/g,'"');

        let obj_str = JSON.parse(str);
        if(obj_str.Type === "SFR")
        console.log(await comp.getProperties(i-1));
      }
     
      
      
    })
  })
  describe('Display Listed Property according to their current value', async() =>{

    it('Displays properties with given value greater than equal to 50000', async() =>{
      

      let no_of_properties = await comp.totalProperties();
      for(let i=1;i<=no_of_properties.words[0];i++){
        let result = await erc721.prop(i);
        let value = result.Curr_Value.words[0];
        if(value >= 50000)
        console.log(await comp.getProperties(i-1));
      
      }
     
      
      
    })
    it('Displays properties with given value greater than equal to 60000', async() =>{
      

      let no_of_properties = await comp.totalProperties();
      for(let i=1;i<=no_of_properties.words[0];i++){
        let result = await erc721.prop(i);
        let value = result.Curr_Value.words[0];
        if(value >= 60000)
        console.log(await comp.getProperties(i-1));
      
      }
     
      
      
    })
    it('Displays properties with given value greater than equal to 70000', async() =>{
      

      let no_of_properties = await comp.totalProperties();
      for(let i=1;i<=no_of_properties.words[0];i++){
        let result = await erc721.prop(i);
        let value = result.Curr_Value.words[0];
        if(value >= 70000)
        console.log(await comp.getProperties(i-1));
      
      }
     
      
      
    })
  })
  // INDEXING

  // describe('indexing', async () => {
  //   it('lists properties', async () => {
  //     // Mint 3 more tokens
  //     await comp.mint("prop2","748484900000000000","abdnjddkdnndjdncd",["{'Address1':'5284 S Ridgecrest','Address2':'','City':'Taylorsville','State':'UT','PostalCode':'84129','County/region':'Salt Lake County','Subdivision':'Heinz 57','TaxID': '01-2222-548','Zoning':'R-1','SchoolDistrict':'Granite','Elementary':'Eccles', 'JrHigh':'Johnson','HighSchool':'Bennion'}"],"550","3800","555","{'Roof':'Asphault Shingle','Heating':'Forced Air','AirConditioning':'Central','FloorHardwood':'Carpet','WindowCovering':'None','Pool':'Yes','PoolFeatures':'Heated, filtered','Exterior':'Brick 70%','Landscaping':'Yes','LotFacts':'.25 Acre','ExteriorFeatures':'Brick','InteriorFeatures':'','Amenities':'','Zoning':'Residential','Type':'SFR','Style':'Rambler','YearBuilt':'1977','Acres':'0.25', 'Deck':'Yes','Patio':'Yes','Garage':'2 Car','Carport':'No','ParkingSpaces':'3','FinBsmt':'95%','Basement':'Yes','Driveway':'Yes','Water':'City','WaterShares':'None','Spa':'None','Comments':'Central Valley Home In Taylorsville with a large backyard pool. Completely remodeled in 2016 everything up to date. 6 Bedrooms and 2 Full bathrooms.Living Room and Downstairs family room laundry room etc… and a true 2 car garage'}")
  //    // await comp.mint('prop3',"50000","25000","cbdcbdjcjdcdnjcjd",["{'Address1':'5284 S Ridgecrest','Address2':'','City':'Taylorsville','State':'UT','PostalCode':'84129','County/region':'Salt Lake County','Subdivision':'Heinz 57','TaxID': '01-2222-548','Zoning':'R-1','SchoolDistrict':'Granite','Elementary':'Eccles', 'JrHigh':'Johnson','HighSchool':'Bennion'}"],"550","3800","555","{'Roof':'Asphault Shingle','Heating':'Forced Air','AirConditioning':'Central','FloorHardwood':'Carpet','WindowCovering':'None','Pool':'Yes','PoolFeatures':'Heated, filtered','Exterior':'Brick 70%','Landscaping':'Yes','LotFacts':'.25 Acre','ExteriorFeatures':'Brick','InteriorFeatures':'','Amenities':'','Zoning':'Residential','Type':'SFR','Style':'Rambler','YearBuilt':'1977','Acres':'0.25', 'Deck':'Yes','Patio':'Yes','Garage':'2 Car','Carport':'No','ParkingSpaces':'3','FinBsmt':'95%','Basement':'Yes','Driveway':'Yes','Water':'City','WaterShares':'None','Spa':'None','Comments':'Central Valley Home In Taylorsville with a large backyard pool. Completely remodeled in 2016 everything up to date. 6 Bedrooms and 2 Full bathrooms.Living Room and Downstairs family room laundry room etc… and a true 2 car garage'}")
  //     //await comp.mint('prop4',"50000","25000","jjcjdbcjsjxnjscsj",["{'Address1':'5284 S Ridgecrest','Address2':'','City':'Taylorsville','State':'UT','PostalCode':'84129','County/region':'Salt Lake County','Subdivision':'Heinz 57','TaxID': '01-2222-548','Zoning':'R-1','SchoolDistrict':'Granite','Elementary':'Eccles', 'JrHigh':'Johnson','HighSchool':'Bennion'}"],"550","3800","555","{'Roof':'Asphault Shingle','Heating':'Forced Air','AirConditioning':'Central','FloorHardwood':'Carpet','WindowCovering':'None','Pool':'Yes','PoolFeatures':'Heated, filtered','Exterior':'Brick 70%','Landscaping':'Yes','LotFacts':'.25 Acre','ExteriorFeatures':'Brick','InteriorFeatures':'','Amenities':'','Zoning':'Residential','Type':'SFR','Style':'Rambler','YearBuilt':'1977','Acres':'0.25', 'Deck':'Yes','Patio':'Yes','Garage':'2 Car','Carport':'No','ParkingSpaces':'3','FinBsmt':'95%','Basement':'Yes','Driveway':'Yes','Water':'City','WaterShares':'None','Spa':'None','Comments':'Central Valley Home In Taylorsville with a large backyard pool. Completely remodeled in 2016 everything up to date. 6 Bedrooms and 2 Full bathrooms.Living Room and Downstairs family room laundry room etc… and a true 2 car garage'}")
  //     // console.log(await comp.prop());
  //     const totalSupply = await comp.totalSupply()
  //     console.log(await comp.getProperties(1));  
  //     console.log(await comp.proptest());
  //     let prop;
  //     let result = []
 
  //     for (var i = 1; i <= totalSupply; i++) {
  //       prop = await comp.properties(i - 1)
  //       result.push(prop)
  //     }
  //     console.log(result);
      
  //     let expected = ['prop1', 'prop2', 'prop3', 'prop4']
  //     //assert.equal(result.join(','), expected.join(','))
  //   })
  // })
   





