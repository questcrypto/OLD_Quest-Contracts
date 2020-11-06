const { assert } = require('chai')
// const { Container } = require('react-bootstrap/lib/Tab')
// const { Item } = require('react-bootstrap/lib/Breadcrumb')

const Factory = artifacts.require('./Factory.sol');


require('chai')
.use(require('chai-as-promised'))
.should()

let contra;

before(async () =>{
     contra = await Factory.deployed();
  })

  contract('Factory', (accounts)=>{
    describe('deployment', async() => {
    it('Factory deployed Successfully', async() => {
        const address = contra.address
        console.log(address)
        assert.notEqual(address,0*0);
        assert.notEqual(address,'');
        assert.notEqual(address, undefined);
        assert.notEqual(address,null)
         })

  })

  it('has a string', async()=>{
    const name = await contra.give

    console.log(name);
    // assert.equal(name,'Factory')
  })

//   Minting

describe('Generate New Token', async()=>{

    it("Token Generated", async() =>{
        const result = await contra.deployNewToken("Prop","PRO","0xDB3D49B8f3D35902901311e573de3194c7DCf477");
        console.log(result);
        console.log("8************************")
    })
})
  
});
