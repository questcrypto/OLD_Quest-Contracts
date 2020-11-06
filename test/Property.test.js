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
      const result = await comp.mint('prop1');
      const totalSupply = await comp.totalSupply()
      // SUCCESS
      assert.equal(totalSupply,1)
      const event = result.logs[0].args;
      assert.equal(event.tokenId.toNumber(),1,'id is correct');
      assert.equal(event.from,'0x0000000000000000000000000000000000000000', 'from is correct');
      assert.equal(event.to,accounts[0], 'to is correct')

      // IF FAILS

      await comp.mint('prop1').should.be.rejected;
    })
  })


  // INDEXING

  describe('indexing', async () => {
    it('lists properties', async () => {
      // Mint 3 more tokens
      await comp.mint('prop2')
      await comp.mint('prop3')
      await comp.mint('prop4')
      // console.log(await comp.prop());
      const totalSupply = await comp.totalSupply()
      console.log(await comp.getProperties(1));
  
      let prop
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




