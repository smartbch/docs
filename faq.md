# FAQ

> Smart Bitcoin Cash \(smartBCH\): a Bitcoin Cash Sidechain with EVM & Web3 Compatibility

FAQs are in progress and we are continuing to add as new questions arise. If you have a question that is not answered here, please ask in our [Telegram](https://t.me/smartbch_community), [Discord](https://discord.gg/7f6EzYJd), or [Twitter](https://twitter.com/SmartBCH).

See the FAQ sections below for topic-based questions and answers:

- smartBCH Basic
- Development Tools 
- Contact & Media Info

## SmartBCH Basic

### Q: What is smartBCH?

smartBCH is a sidechain for Bitcoin Cash and has an aim to explore new ideas and unlock novel possibilities. A sidechain is a blockchain designed for fast and inexpensive transactions with a special relationship with the main chain because of a two-way peg; in this case between Bitcoin Cash and smartBCH.

By developing optimized, high-throughput, and hardware-friendly libraries compatible with the de facto standards of smart contracts, DeFi applications can be easily migrated into Bitcoin Cash's ecosystem and run fluently at low cost.

### Q: What are smartBCH's key features?

Smart Bitcoin Cash's innovation lies in libraries to provide a compatibility layer supporting EVM and Web3 to users and developers. We are actively working on the following libraries:

* MoeingEVM: MoeingEVM is a parallelized execution engine that currently manages multiple EVM contexts and executes multiple transactions. It adopts several novel techniques to allow transactions from several blocks to be mixed and reordered, such that independent transactions can run in parallel to maximize throughput.
* MoeingADS: MoeingADS uses a single-layer architecture, accessing the file system directly without having to use any other databases. It is a KV database that can provide existence and non-existence proof. It can replace Ethereum's MPT as an authenticated data structure. With MoeingADS, reading a KV pair requires one read to disk, overwriting a KV pair requires one read and one write, inserting requires two reads and two writes, and deleting requires two reads and one write. What’s more, the writes are appending, which is very SSD-friendly. Experiments show that MoeingADS is even faster than LevelDB. The cost is the larger consumption of DRAM: Each key-value pair demands about 16 bytes.
* MoeingDB: MoeingDB is an application-specific database that stores blockchain history. It was developed with blockchain characteristics in mind which enables it to suit a blockchain's workload best. Based on its features, an open-source, high-QPS Web3 API can be built, benefiting both Smart Bitcoin Cash and Ethereum.
* MoeingKV: MoeingKV is a KV storage module much faster than LevelDB in reading and writing, at the cost of removing iteration support. In underlying data structure design and code implementation, MoeingKV produces trade-offs and optimizations to speed up normal read and write operations. It can be used to store the UTXO set of Bitcoin Cash.
* MoeingAOT: MoeingAOT is an ahead-of-time compiler for EVM. MoeingAOT can compile EVM bytecode into native code, which would consequently be saved as a dynamically linked library. When the EVM interpreter starts running a smart contract and finds its corresponding compiled library file, the library will be loaded, and bytecode interpretation won't be necessary.

We have also performed feasibility research on two extra libraries \(MoeingRollup and MoeingLink\), which can further scale up Smart Bitcoin Cash in the long run.

### Q: Does smartBCH interoperate with Ethereum?

Currently smartBCH does not directly interoperate with Ethereum, but in time a gateway may bridge assets between them. In the future, bridges based on smart contracts are also possible, with a scheme similar to [rainbow bridge](https://near.org/blog/eth-near-rainbow-bridge/). 

### Q: Does smartBCH have to modify Solidity to deal with a UXTO model rather than regular ETH wallet balances?

SmartBCH, like Ethereum, uses an account model instead of a UTXO model.

### Q: Can I run any language that targets the EVM \(like Vyper\) on smartBCH or only specially modified languages?

It can use any language which compiles to EVM bytecode.

### Q: Can the validator who proposes the current block decide the order of transactions?

No. Unlike Ethereum, smartBCH reorders transactions in a pseudorandom way to mitigate the problem of front-running, which makes it much harder for a validator to enforce its preferred transaction order. Besides, smartBCH also reorders transactions to maximize parallelism.

### Q: What's smartBCH's consensus model, and how does it synchronize with Bitcoin Cash consensus?

SmartBCH uses a hybrid consensus model. It adopts Tendermint as its consensus engine. The quorum of validators is elected by both hash power and BCH owners, and it takes on duties in epochs.

An epoch contains 2,016 blocks \(about two weeks\). During an epoch, BCH owners prove their ownership of time-locked UTXOs and use the value of those UTXOs to vote for validators; whereas mining pools use coinbase transactions to vote. This is a hybrid consensus model: proof of hash power and stakes. The voting process takes place on Bitcoin Cash's mainnet and is totally permissionless because validators only needs endorsements from miners and/or holders.

An epoch's end time is the largest timestamp of its blocks, and its duration time is the difference between the end times of adjacent epochs. The quorum elected during an epoch will stay in a stand-by state for about 5% of the epoch's duration time. Then it takes its turn to be on duty until the next quorum leaves its stand-by state. This is necessary because any Bitcoin Cash reorganization may alter the blocks in an epoch.

Each validator must pledge some BCH as collateral, which would be slashed should it misbehave during its duty.

At the first phase after Smart Bitcoin Cash's launch, only hash power is used for electing validators. Locking BCH at mainnet for staking will be implemented later and will take effect in a future hard fork.

### Q: How does one become a validator?

At smartBCH's launch, the voting mechanism of "one block, one vote" will be adopted. That is, in the 2,016 blocks during an epoch, each mining pool will get one vote for every Bitcoin Cash block mined to vote on the smartBCH validators. You don't need to submit any application for becoming a validator. It is only necessary to have adequate computing power and receive votes from Bitcoin Cash miners and later BCH holders.

### Q: Will there be an ICO for smartBCH Coin?

There is no ICO and no smartBCH Coin. Smart Bitcoin Cash will not introduce new tokens. Its native token is BCH, and its gas fees are paid in BCH. There will be a gateway to transfer BCH to the smartBCH Chain as a gas token.

### Q: How will the gateway be realized between Bitcoin Cash mainnet and smartBCH?

The gateway between Bitcoin Cash mainnet and smartBCH will start as a PoA gateway and we will continue to improve its functionality and precision. The optimized solution may not be like any existing solutions used by RSK, Liquid, ETH2.0, Cosmos, or Polkadot. Instead, it must fit into Bitcoin Cash's infrastructure. After adding introspection opcodes, covenants will be much easier to implement on Bitcoin Cash, and we will very likely use them.

### Q: What are the advantages for developers building their DeFi protocols on smartBCH?

The most crucial advantage for building DeFi protocols on smartBCH is the inexpensive transaction fees. The demand for more ETH and Ethereum's ability to execute smart contracts is why its gas fees remain high. However, smartBCH will utilize extremely high throughput to make sure the transaction fees are inexpensive even with a large userbase.

### Q: What does the throughput of smartBCH look like right now?

Limited tests currently show that the underlying storage engine can support more than 600 times the throughput of Ethereum. However, there are still many factors to consider when running the whole chain, and there will be some challenges we might face. We hope that within 20 months, the throughput per second will be 100 times larger than ETH1.0. When smartBCH initially launches, we estimate a throughput 10-20 times larger than ETH1.0.
