const { assert } = require('chai')
// const { Container } = require('react-bootstrap/lib/Tab')
// const { Item } = require('react-bootstrap/lib/Breadcrumb')

const Property = artifacts.require('./Property.sol')

require('chai')
.use(require('chai-as-promised'))
.should()


before(async () =>{
  contract = await Property.deployed()
})
contract('Property', (accounts)=>{

  let property
  describe('deployment', async() => {
    it('deployed Successfully', async() => {
   const address = contract.address
   console.log(address)
   assert.notEqual(address,0*0);
   assert.notEqual(address,'');
   assert.notEqual(address, undefined);
   assert.notEqual(address,null)
    })


    it('has a name', async()=>{
      const name = await contract.name()
      assert.equal(name,'Property')
    })

    it('has a symbol', async()=>{
      const symbol = await contract.symbol()
      assert.equal(symbol,'QST_NFT')
    })
  })


  // Minitng

  describe('minting', async() =>{

    it('creates a new token', async() =>{
      const result = await contract.mint('prop1');
      const totalSupply = await contract.totalSupply()
      // SUCCESS
      assert.equal(totalSupply,1)
      const event = result.logs[0].args;
      assert.equal(event.tokenId.toNumber(),1,'id is correct');
      assert.equal(event.from,'0x0000000000000000000000000000000000000000', 'from is correct');
      assert.equal(event.to,accounts[0], 'to is correct')

      // IF FAILS

      await contract.mint('prop1').should.be.rejected;
    })
  })


  // INDEXING

  describe('indexing', async () => {
    it('lists properties', async () => {
      // Mint 3 more tokens
      await contract.mint('prop2')
      await contract.mint('prop3')
      await contract.mint('prop4')
      // console.log(await contract.prop());
      const totalSupply = await contract.totalSupply()
      console.log(await contract.getProperties(1));
  
      let prop
      let result = []
  
      for (var i = 1; i <= totalSupply; i++) {
        prop = await contract.properties(i - 1)
        result.push(prop)
      }
      console.log(result);
      
      let expected = ['prop1', 'prop2', 'prop3', 'prop4']
      assert.equal(result.join(','), expected.join(','))
    })
  })
  
})





// const Color = artifacts.require('./Color.sol')

// require('chai')
//   .use(require('chai-as-promised'))
//   .should()

// contract('Color', (accounts) => {
//   let contract

//   before(async () => {
//     contract = await Color.deployed()
//   })

//   describe('deployment', async () => {
//     it('deploys successfully', async () => {
//       const address = contract.address
//       assert.notEqual(address, 0x0)
//       assert.notEqual(address, '')
//       assert.notEqual(address, null)
//       assert.notEqual(address, undefined)
//     })

//     it('has a name', async () => {
//       const name = await contract.name()
//       assert.equal(name, 'Color')
//     })

//     it('has a symbol', async () => {
//       const symbol = await contract.symbol()
//       assert.equal(symbol, 'COLOR')
//     })

//   })

//   describe('minting', async () => {

//     it('creates a new token', async () => {
//       const result = await contract.mint('#EC058E')
//       const totalSupply = await contract.totalSupply()
//       // SUCCESS
//       assert.equal(totalSupply, 1)
//       const event = result.logs[0].args
//       assert.equal(event.tokenId.toNumber(), 1, 'id is correct')
//       assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct')
//       assert.equal(event.to, accounts[0], 'to is correct')

//       // FAILURE: cannot mint same color twice
//       await contract.mint('#EC058E').should.be.rejected;
//     })
//   })

  // describe('indexing', async () => {
  //   it('lists colors', async () => {
  //     // Mint 3 more tokens
  //     await contract.mint('#5386E4')
  //     await contract.mint('#FFFFFF')
  //     await contract.mint('#000000')
  //     const totalSupply = await contract.totalSupply()

  //     let color
  //     let result = []

  //     for (var i = 1; i <= totalSupply; i++) {
  //       color = await contract.colors(i - 1)
  //       result.push(color)
  //     }

  //     let expected = ['#EC058E', '#5386E4', '#FFFFFF', '#000000']
  //     assert.equal(result.join(','), expected.join(','))
  //   })
  // })

// })
