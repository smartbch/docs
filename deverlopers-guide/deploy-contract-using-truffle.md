# Deploy contract using Truffle

This article takes [Pet-Shop](https://www.trufflesuite.com/tutorials/pet-shop) as an example to introduce how to deploy smart contract into smartBCH chain using [truffle](https://www.trufflesuite.com/truffle).



## Start smartBCH single testing node

Please flow [this doc](runsinglenode.md) to start smartBCH single testing node. When the test node is started using default options, it will serve JSON-RPC on localhost:8485. You can using the following cmd to see if node works well:

```bash
$ curl -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":67}' \
		-H "Content-Type: application/json" http://localhost:8545

{"jsonrpc":"2.0","id":67,"result":"1337"}
```

You can also use this public test node (deployed by smartBCH community) if you do not want to deploy your local node:

```bash
$ curl -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":67}' \
		-H "Content-Type: application/json" https://smartbch.greyh.at

{"jsonrpc":"2.0","id":67,"result":"1337"}
```



## Instll Truffle

You need to install Node.js first, [here](https://nodejs.org/en/download/package-manager/) are detailed information about how to install it on various platforms. Then, run the following cmd to install truffle:

```bash
$ npm install -g truffle
```

And run the following cmd the see if truffle was installed successfully:

```bash
$ truffle version

Truffle v5.1.63 (core: 5.1.63)
Solidity v0.5.16 (solc-js)
Node v15.10.0
Web3.js v1.2.9
```



## Clone Pet-Shop

Using `git clone` cmd to clone pet-shop source code into you local directory:

```bash
$ cd somedir
$ git clone https://github.com/trufflesuite/pet-shop-tutorial.git
$ cd pet-shop-tutorial
```

Modify truffle-config.js, change development network port to match your local node (e.g. 8545):

```javascript
module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    }
  }
};
```

You can modify truffle-config.js further and add a network config like this if your want to use greyh's test node too:

```javascript
const Web3 = require('web3');

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
    greyh: {
      provider: () => new Web3.providers.HttpProvider('https://smartbch.greyh.at'),
      network_id: "*"
    },
  }
};
```

Do not forget to install web3 through `npm install` cmd if you use public test node:

```bash
$ npm install web3
```



## Deploy to smartBCH

In directory pet-shop-tutorial, using `truffle migrate`  cmd to deploy Pet-Shop contract into smartBCH local testing node:

```bash
$ truffle migrate --network development
# truffle migrate --network greyh # deploy to greyh's testing node
```

The output looks like this:

```
Compiling your contracts...
===========================
> Compiling ./contracts/Adoption.sol
> Artifacts written to /Users/zxh/bitmain/github/truffle_suite/pet-shop-tutorial/build/contracts
> Compiled successfully using:
   - solc: 0.5.16+commit.9c3226ce.Emscripten.clang



Starting migrations...
======================
> Network name:    'development'
> Network id:      1337
> Block gas limit: 200000000 (0xbebc200)


1_initial_migration.js
======================

   Replacing 'Migrations'
   ----------------------
   > transaction hash:    0xdd1548be1a2448b471390a309ca50a3168a8c690438329d71acd07ccfeab4736
   > Blocks: 0            Seconds: 0
   > contract address:    0xC7BBd3373c6D9f582102c332bE91e8dCDd087e35
   > block number:        156
   > block timestamp:     1618372330
   > account:             0x09F236e4067f5FcA5872d0c09f92Ce653377aE41
   > balance:             9.99549526
   > gas used:            225237 (0x36fd5)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.00450474 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.00450474 ETH


2_deploy_contracts.js
=====================

   Replacing 'Adoption'
   --------------------
   > transaction hash:    0x5143aaff4315c7fca0e762422dcb7daedcfbbdea047668922948ede2a982e97f
   > Blocks: 0            Seconds: 0
   > contract address:    0x531f499C35945C83C87B5f33b56a5aFFa9CF0d05
   > block number:        160
   > block timestamp:     1618372334
   > account:             0x09F236e4067f5FcA5872d0c09f92Ce653377aE41
   > balance:             9.99057146
   > gas used:            203827 (0x31c33)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.00407654 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.00407654 ETH


Summary
=======
> Total deployments:   2
> Final cost:          0.00858128 ETH
```

