# General FAQs

> Smart Bitcoin Cash(smartBCH): a Bitcoin Cash Sidechain with EVM & Web3 Compatibility 


```
FAQs are in progress, we are continuing to add as new questions arise. If you have a question that is not answered here, please ask in our [Telegram](https://t.me/smartbch_community), [Discord](https://discord.gg/7f6EzYJd) or [Twitter](https://twitter.com/SmartBCH).

See the FAQ sections below for topic based questions and answers:

- smartBCH Basic
- Development Tools 
- Contact & Media Info 

```

## smartBCH Basic

#### What is smartBCH?
smartBCH is a sidechain for Bitcoin Cash aims to explore new ideas and unlock novel possibilities. A sidechain is a blockchain designed for fast and inexpensive transactions which with a special relationship with the main chain because of a two-way peg between Bitcoin Cash and smartBCH.

By developing optimized, high-throughput and hardware-friendly libraries compatible to the de facto standards of smart contracts, DeFi applications can be easily migrated into Bitcoin Cash's ecosystem and run fluently at low cost.


#### Key Features

Smart Bitcoin Cash's innovation lies in libraries to provide a compatibility layer supporting EVM and Web3 to users and developers. We are working actively on the following libraries:

- MoeingEVM: MoeingEVM is a parallelized execution engine that currently manages multiple EVM contexts and executes multiple transactions. It adopts several novel techniquess to allow transactions from several blocks to be mixed and reordered, such that independent transactions can run in parallel to maximize throughput.
- MoeingADS: MoeingADS uses a single-layer architecture, accessing the file system directly without having to use any other databases. It is a KV database that can provide existence and non-existence proof. It can replace Ethereum's MPT as an authenticated data structure. With MoeingADS, reading a KV pair requires one read to disk, overwriting a KV pair requires one read and one write, inserting requires two reads and two writes, and deleting requires two reads and one writes. What’s more, the writes are appending, which is very SSD-friendly. Experiments show that MoeingADS is even faster than LevelDB. The cost is the larger consumption of DRAM: each key-value pair demands about 16 bytes.
- MoeingDB: MoeingDB is an application-specific database that stores blockchain history. It was developed with blockchain characteristics in mind which enables it to suit a blockchain's workload best. Based on its features, an open-source high QPS Web3 API can be built, benefiting both Smart Bitcoin Cash and Ethereum.
- MoeingKV: MoeingKV is a KV storage much faster than LevelDB in reading and writing, at the cost of removing iteration support. In underlying data structure design and code implementation, MoeingKV produces trade-offs and optimizations to speed up normal read and write operations. It can be used to store the UTXO set of Bitcoin Cash.
- MoeingAOT: MoeingAOT is an ahead-of-time compiler for EVM. MoeingAOT can compile EVM bytecode into native code, which would consequently be saved as a dynamically linked library. When the EVM interpreter starts running a smart contract and finds its corresponding compiled library file, the library will be loaded, and bytecode interpretation wouldn't be necessary.

And we have performed feasibility research on two extra libraries (MoeingRollup and MoeingLink), which can further scale up Smart Bitcoin Cash in the long run.


#### Does smartBCH interoperate with Ethereum?
smartBCH does not directly interoperate with Ethereum, but some gateway may bridge assets between them.


#### Did smartBCH have to change Solidity to deal with a UXTO model rather than regular ETH wallet balances?
smartBCH Chain uses an account model instead of UTXO.


#### Can I run any language that targets the EVM (like Vyper) on smartBCH or only ones specially modified?
It can use any language which compiles to EVM bytecode.


#### What's smartBCH's consensus model, and how does it synchronize with BCH consensus?
smartBCH's consensus model is PoS. Moeing compute engine does not change BCH data. It is a side chain. smartBCH adopts tendermint as its consensus engine. The quorum of validators are elected by both hash power and BCH owners, and they take on duties in epochs.

An epoch contains 2,016 blocks (takes about two weeks). During an epoch, BCH owners prove their ownerships of time-locked UTXOs and use the values of these UTXO to vote for a validator; whereas mining pools use coinbase transactions to vote. This is a hybrid consensus model: proof of hash power and stakes. The voting process is performed on Bitcoin Cash's mainnet and totally permissionless because a new validator only needs endorsements from miners and/or holders.

An epoch's end time is the largest timestamp of its blocks, and its duration time is the difference between the end times of adjacent epochs. The quorum elected during an epoch will stay in a stand-by state for about 5% of the epoch's duration time. Then it takes its turn to be on duty, until the next quorum leaves its stand-by state, which is necessary because any Bitcoin Cash reorganization may alter the blocks in an epoch.

Each validator must pledge some BCH as collateral, which would be slashed should it misbehaves during its duty.

At the first phase after Smart Bitcoin Cash's launch, only hash power is used for electing validators. Locking BCH at mainnet for staking will be implemented later and take effect in a future hard fork.


#### BCH is only used to elect validators? What happens if BCH miners don't vote?
Then the last quorum of nodes will take duty in the next epoch. If BCH miners support moeing, they will vote. We will talk to them before launching.


#### Will there be an ICO for smartBCH Coin?
There is no ICO and no smartBCH Coin, smart Bitcoin Cash will not introduce new tokens. Its native token is BCH, and its gas fees are paid in BCH.There will be a gateway to transfer BCH onto smartBCH Chain as a gas token.


#### How's the gateway be realized between BCH mainnet and smartBCH?
The gateway between BCH mainnet and smartBCH will start a PoA gateway, and then we'll improve its liveness and correctness in a pragmatic way. Liveness means it can always work, instead of locking coins in it. Correctness means it never unlocks coins to incorrect recipients. The optimized solution may be not like any existing solutions used by RSK, Liquid, ETH2.0, cosmos or polkadot. Instead, it must fit into BCH's infrastructure. After adding introspection opcodes, covenants will be much easier to implement on BCH. And we will very likely use them.




## Development Tools





## Contact & Media Info


| Social Media              | URL | 
| --------------------- | ------------------- |
|Twitter         | https://twitter.com/SmartBCH            |
| Discord  | https://discord.gg/uNTRSz6msj              | 
| Medium   | https://medium.com/@smartBCH                | 
| Read.Cash   | https://read.cash/@smartbch              | 
| Telegram (Community Chat)    | https://t.me/smartbch_community               | 
| Telegram Announcement Channel   | https://t.me/smartbch_official              | 
|GitHub        | https://github.com/smartbch        |
|Reddit         | https://www.reddit.com/user/SmartBCH           |




