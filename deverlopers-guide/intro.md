# Introduction

Currently, there are no toolkits dedicatedly designed for smartBCH. Please use the tools from Ethereum's ecosystem \(Remix, truffle, waffle, ganache, etc\) to develop the source code and compile the EVM bytecode. After the DApp works fine on ganache, you can start testing it with smartbchd \(the executable of smartBCH's full node client\), which can [start a single node private testnet](runsinglenode.md).

Through a compatible Web3 API, smartbchd interacts with the wallets \(such as MetaMask\) and DApp's backend, just as an infura node does. We try our best to make it behave the same as infura for compatibility, but there are still missing features and bugs.

For a list of supported RPC endpoints, please see [here](https://github.com/smartbch/docs/blob/main/deverlopers-guide/jsonrpc.md).

We also provide a [backend design](https://github.com/smartbch/BasicBrowser/tree/main/backend) of blockchain explorer for smartBCH. It just has basic functions and is not so powerful as etherscan. If you wants to add a frontend to build a complete explorer, this [API document](browserapi.md) may help you.

If you find a mistake in the document, please tell us by create an issue at [https://github.com/smartbch/docs/issues](https://github.com/smartbch/docs/issues). If a missing feature blocks you, we are sorry but you need to modify your application to bypass it.

