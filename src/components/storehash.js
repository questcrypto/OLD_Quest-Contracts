import web3 from './web3';

//access our local copy to contract deployed on rinkeby testnet
//use your own contract address
const address = '0xd9145CCE52D386f254917e481eB44e9943F39138';
//use the ABI from your contract
const abi = [
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "x",
				"type": "string"
			}
		],
		"name": "sendHash",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getHash",
		"outputs": [
			{
				"internalType": "string",
				"name": "x",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
export default new web3.eth.Contract(abi, address);