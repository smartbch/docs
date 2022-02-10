# Staking Scheme

Smart Bitcoin Cash adopts [tendermint](https://github.com/tendermint/tendermint) as its consensus engine. The quorum of validators is elected only by Bitcoin Cash mainnet's hash power, and they take on duties in epochs. After the XHedge upgrade, both hash power and locked BCH can be used in elections.

### Epoch-based Validator Election

An epoch contains 2,016 blocks \(takes about two weeks\). During an epoch, mining pools use coinbase transactions to vote. This voting process is performed on Bitcoin Cash's mainnet and is totally permissionless because a new validator only needs endorsements from miners.

The voting protocol is simple: the first output of the coinbase transaction which meets the following requirement is regarded as a vote:

1. It begins with the "OP_RETURN" opcode
2. The pushed value after OP_RETURN is a 37-byte string, in which the starting 5 bytes are 0x73, 0x42, 0x43, 0x48, and 0x0, and the ending 32 bytes are an ed25519 public key, which is used to identify a node in tendermint

There may be multiple outputs meeting the above two requirements, but only the first one is regarded as a vote, and the others are ignored.

An epoch's end time is the largest timestamp of its blocks, and its duration time is the difference between the end times of adjacent epochs. The quorum elected during an epoch will stay in a standby state for 5% of the epoch's duration time. Then it takes its turn to be on duty until the next quorum leaves its standby state, which is necessary because any Bitcoin Cash reorganization may alter the blocks in an epoch.

After the XHedge upgrade, BCH holders on smartBCH can elect validators through the [XHedge smart contract](./xhedge-contract.md) in a PoS scheme. The voting power from miners (PoW) and the voting power from BCH holders (PoS) are both 50%.

### Register as a Validator

Before being elected as a validator on duty, you must first register as a candidate validator, by sending transactions on smartBCH.

A special smart contract at the address 0x2710 handles transactions related to staking. It has several functions which can only be called from EOAs (externally owned accounts) and one function which can only be called by other smart contracts. It is implemented using native code and can do jobs that normal EVM contracts cannot do.

It's interface is as below:

```solidity
interface StakingContract {
    function createValidator(address rewardTo, bytes32 introduction, bytes32 pubkey) external;
    function editValidator(address rewardTo, bytes32 introduction) external;
    function retire() external;
    function increaseMinGasPrice() external;
    function decreaseMinGasPrice() external;
    function sumVotingPower(address[] calldata addrList) external override returns (uint summedPower, uint totalPower) // this function can only be called by other contracts
}
```

An EOA can call `createValidator` to register itself as a candidate validator and set the following parameters:

1. `rewardTo`, the account that receives the validator's reward
2. `introduction`, a short UTF8 string (no longer than 32 bytes) describing the validator, whose tailing bytes are zeros.
3. `pubkey`, an ed25519 pubkey for which the coinbase transactions' outputs can vote.

After becoming a candidate validator, an EOA cannot call `createValidator` again. Instead, it can use `editValidator` to change `rewardTo` and  `introduction`, but the `pubkey` cannot be changed. 

A validator must pledge some BCH as collateral, which would be slashed if it misbehaves during its duty. Once its pledged collateral is less than a lower bound because of slashing, its voting power is reduced to zero until enough collateral is replenished. A validator can pledge collateral by sending BCH when calling `createValidator` and `editValidator`.

If a validator no longer wants to act as a validator, it can call `retire` to mark its status as "retiring". The votes to a retiring validator is not counted when electing the next quorum.

### Query an Address Set's Voting Power

A smart contract can call the `sumVotingPower` function to sum all the voting power owned by the address set specified in `addrList`. It also returns the total voting power owned by all the active validators. These two parameters are returned as `summedPower` and `totalPower`, respectively. 

A smart contract can record incoming votes from validators and use `sumVotingPower` to decide whether the votes are enough. In such a way, the validator set acts as Supreme Court to decide some cases finally.

### Adjust Gas Fee

Each validator can set its minimum acceptable gas price, which is respected in relaying transactions and receiving transactions into mempool. This parameter is not a consensus parameter.

The chain-wide minimum gas price is a consensus parameter, which is the lower bound of the minimum gas prices set by different validators. This consensus parameter is modified by the validators. 

Before the XHedge upgrade, to increase (decrease) it by a predefined percentage, a qualified EOA call the `increaseMinGasPrice` (`decreaseMinGasPrice`) function, respectively. A qualified EOA is a validator or a validator's `rewardTo` account. This method may cause chaos of meaningless rising and falling.

After the XHedge upgrade, there is [a more sophisticated method](./mingas-decision.md) for the validators to vote for a final decision of the minimum gas price.

### Distribute Rewards

For each executed block, the gathered gas fee is distributed to the validators who proposed or voted for it.

The proposer can get two kinds of rewards:

1. The reward for being a proposer, i.e., not missing its duty, which is 15% of all the gas fee.
2. The reward for collecting signatures for the last block, which is at most 15% of all the gas fee. This reward is in direct proportion to the voting power the proposer collects. When all the voting power is collected, it can enjoy 15%

After the proposer gets its rewards, the remained gas fee is distributed to the voters. The proposer is also a voter by nature, so it can also enjoy some reward as a voter. A voter's reward is in direct proportion to its voting power.

The distributed rewards are not immediately given to validators' `rewardTo` accounts. Instead, they are pending till the next epoch's end. That is, the rewards gained in epoch N will be given to a validator's `rewardTo` account at the end of epoch N+1.

A validator's life cycle ends when its voting power is zero and all the pending rewards are given to its `rewardTo` account. 

### Slashing

When a validator's misbehavior is discovered, its pending rewards will be all confiscated and a fixed amount of collateral will be slashed. 

Currently, only double-signing is considered as a misbehavior.