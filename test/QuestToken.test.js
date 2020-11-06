const { assert } = require('chai')
// const { Container } = require('react-bootstrap/lib/Tab')
// const { Item } = require('react-bootstrap/lib/Breadcrumb')

const QuestToken = artifacts.require('./QuestToken.sol');


require('chai')
.use(require('chai-as-promised'))
.should()

let quest;

before(async () =>{
     quest = await QuestToken.deployed();
  })

  contract('QuestToken', (accounts)=>{
    describe('deployment', async() => {
    it('QuestToken deployed Successfully', async() => {
        const address = quest.address
        console.log(address)
        assert.notEqual(address,0*0);
        assert.notEqual(address,'');
        assert.notEqual(address, undefined);
        assert.notEqual(address,null)
         })

  })


//   Minting

describe('Mint New Voucher Token', async()=>{

    it("Voucher Token Successfully Minted", async() =>{
        const result = await quest.mint("0xDB3D49B8f3D35902901311e573de3194c7DCf477",194903934);
        console.log(result);
        console.log("8************************")
    })
})
  
});
