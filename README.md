<div align="center">

<img src="denWordmarkBlack.svg" alt="den" width="300"/>

# Matter Ethereum Smart Contract

Matter (MTR) is an [ERC-20](https://eips.ethereum.org/EIPS/eip-20) token used by the Dragon Den social media platform to equitably divvy up NRG between users.
</div>


## Deployed Contracts

| Network | Contract Address |
| ------- | ---------------- |
| Ropsten  Temp | [0x7BA85BE2fe2918547a8Cf9A673C8b26f18Ed331e](https://ropsten.etherscan.io/address/0x7BA85BE2fe2918547a8Cf9A673C8b26f18Ed331e) |


## Etherscan: Verify & Publish Contract Source Code
- Install global dependency: [truffle-flattener](https://www.npmjs.com/package/truffle-flattener)
- Run below command
```bash
npx truffle-flattener ./contracts/Matter.sol > ./contracts/FlatMatter.sol
```
- Upload FlatMatter.sol to [Etherscan](https://etherscan.io/verifyContract)


## Development

- Install dependencies: `npm install`
- Create .env file with the below variables:
 ```yaml
 MNEMONIC="ethereum wallet mnemonic phrase used by metamask"
 INFURA_ROPSTEN_API_KEY=YOUR INFURA API KEY
 ```
- Compile contracts: `truffle compile`
- Deploy contracts: `truffle migrate --network NETWORK_NAME`

## Specification

### ERC-20

```solidity
function approve(address _spender, uint256 _value);
function transfer(address _to, uint256 _value);
function transferFrom(address _from, address _to, uint256 _value);

function totalSupply();
function balanceOf(address _owner);
function allowance(address _owner, address _spender);

event Transfer(address indexed _from, address indexed _to, uint256 _value);
event Approval(address indexed _owner, address indexed _spender, uint256 _value);
```

Refer to [ERC-20 standard](https://eips.ethereum.org/EIPS/eip-20) for detailed specification.

### Minting 

The `mint()` function can be called by anyone during the minting hour (defaulted to 23:00-23:59) as long as it's been at least 10 hours since the last mint

## Contributors

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/hemlokc">
        <img src="https://avatars0.githubusercontent.com/u/34429267?&v=4" width="100px;" alt=""/><br />
        <sub><b>hemlokc</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/lancekrogers">
        <img src="https://avatars0.githubusercontent.com/u/12162551?v=4" width="100px;" alt=""/><br />
        <sub><b>lancekrogers</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/emtesenair">
        <img src="https://avatars1.githubusercontent.com/u/993202?v=4" width="100px;" alt=""/><br />
        <sub><b>emtesenair</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/j0j0r0">
        <img src="https://avatars3.githubusercontent.com/u/19333206?v=4" width="100px;" alt=""/><br />
        <sub><b>j0j0r0</b></sub>
      </a>
    </td>
  <tr>
</table>
