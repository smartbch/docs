# Deploy contract using Truffle (on testnet)

This article takes [Pet-Shop](https://www.trufflesuite.com/tutorial) as an example to introduce how to deploy smart contract into smartBCH testnet using [truffle](https://www.trufflesuite.com/truffle). 




## Build smartbchd and generate a test key

Please flow [this document](runsinglenode.md) to clone and build `smartbchd`. We need a test account and associated private key, `smartbchd` provides a sub-command to generate them for us:

```bash
$ cd path/to/your/smartbch/dir # and build smartbchd following the given doc
$ ./smartbchd gen-test-keys -n 1 --show-address
```

The output looks like this (the generated private key and address are seperated by a space):

```
09c57df30208bdc056144c32d607f0719bdb0f8ac5f0a3259720d9e4d28d999b 0xab83b691Bc12Aae947B2ca240F1732fa792dE246
```

Go to [smartBCH testnet faucet](http://54.169.31.93:8080/faucet) to fund our newly generated address some BCH.



## Install Truffle

We need to install Node.js first, [here](https://nodejs.org/en/download/package-manager/) are detailed information about how to install it on various platforms. Then, run the following cmd to install truffle:

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



## Clone Pet-Shop and add testnet config

Using `git clone` cmd to clone pet-shop source code into you local directory:

```bash
$ cd somedir
$ git clone https://github.com/trufflesuite/pet-shop-tutorial.git
$ cd pet-shop-tutorial
```

Install [truffle hdwallet-provider](https://www.npmjs.com/package/@truffle/hdwallet-provider) v1.2.6 (for some unknown reason, the latest version v1.3.x may not work with private keys, so we use v1.2.x here):

```bash
$ npm install @truffle/hdwallet-provider@1.2.6 --save-dev
```

Modify truffle-config.js, add smartBCH testnet network configuration using you test key like bellow (you can find more smartBCH testnet RPC URLs [here](../testnets.md)):

```javascript
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    sbch_testnet: {
      network_id: "10001",
      gasPrice: 0,
      provider: () => new HDWalletProvider({
        providerOrUrl: "http://35.220.203.194:8545",
        privateKeys: [
          "09c57df30208bdc056144c32d607f0719bdb0f8ac5f0a3259720d9e4d28d999b",
        ],
      }),
    }
  }
};
```



## Deploy Pet-Shop to smartBCH testnet

In directory pet-shop-tutorial, using `truffle migrate`  cmd to deploy Pet-Shop contract into smartBCH testnet:

```bash
$ truffle migrate --network sbch_testnet
```

The output looks like this:

```
Compiling your contracts...
===========================
> Everything is up to date, there is nothing to compile.



Starting migrations...
======================
> Network name:    'sbch_testnet'
> Network id:      10001
> Block gas limit: 200000000 (0xbebc200)


1_initial_migration.js
======================

   Deploying 'Migrations'
   ----------------------
   > transaction hash:    0xd03a612ec8ff3800fdaba8eab70230575cf5b6ed9c1eeecfa5595b20d7553281
   > Blocks: 1            Seconds: 8
   > contract address:    0x12033fAFdd217E1fF8F247D9C6E9a0606f75c813
   > block number:        71514
   > block timestamp:     1619962004
   > account:             0xab83b691Bc12Aae947B2ca240F1732fa792dE246
   > balance:             0.01
   > gas used:            225225 (0x36fc9)
   > gas price:           0 gwei
   > value sent:          0 ETH
   > total cost:          0 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:                   0 ETH


2_deploy_contracts.js
=====================

   Deploying 'Adoption'
   --------------------
   > transaction hash:    0xc5137d30a6b065bfac3b6a3b8a321ffc338366c110e56315f9e601bca56e344b
   > Blocks: 2            Seconds: 8
   > contract address:    0x7D268085bDa90c0F9bC1c16c5bE6632958470B89
   > block number:        71518
   > block timestamp:     1619962024
   > account:             0xab83b691Bc12Aae947B2ca240F1732fa792dE246
   > balance:             0.01
   > gas used:            203827 (0x31c33)
   > gas price:           0 gwei
   > value sent:          0 ETH
   > total cost:          0 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:                   0 ETH


Summary
=======
> Total deployments:   2
> Final cost:          0 ETH
```

Wow! You have deployed Pet-Shop into smartBCH testnet. Thank you for testing smartBCH testnet 😊