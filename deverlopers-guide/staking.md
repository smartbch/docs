# Staking Scheme

Smart Bitcoin Cash adopts [tendermint](https://github.com/tendermint/tendermint) as its consensus engine. The quorum of validators are elected only by Bitcoin Cash mainnet's, and they take on duties in epochs. In the future, both hash power and locked BCH can be used in election.

### Epoch-based Validator Election

An epoch contains 2,016 blocks \(takes about two weeks\). During an epoch, mining pools use coinbase transactions to vote. This voting process is performed on Bitcoin Cash's mainnet and totally permissionless because a new validator only needs endorsements from miners.

The voting protocol is simple: the first output of the coinbase transaction which meets the following requirement is regarded as a vote:

1. It begins with the "OP_RETURN" opcode
2. The pushed value after OP_RETURN is a 37-byte string, in which the starting 5 bytes are 0x73, 0x42, 0x43, 0x48 and 0x0, and the ending 32 bytes are an ed25519 public key.

There maybe multiple outputs meeting the above two requirements, but only the first one is regarded as a vote to the validator whose ed25519 public key is encoded in the output.

An epoch's end time is the largest timestamp of its blocks, and its duration time is the difference between the end times of adjacent epochs. The quorum elected during an epoch will stay in a stand-by state for 5% of the epoch's duration time. Then it takes its turn to be on duty, until the next quorum leaves its stand-by state, which is necessary because any Bitcoin Cash reorganization may alter the blocks in an epoch.

### Register as a Validator

Before elected as a validator on duty, you must first register as a candidate validator, by sending transactions.

A special smart contract at the address 0x2710 handles transactions related to staking. It only accepts calls from EOAs (externally owned accounts) and cannot be called by other smart contracts. It is implemented using native code and can do jobs which normal EVM contracts cannot do.

It's interface is as below:

```solidity
interface Staking {
	  function createValidator(address rewardTo, bytes32 introduction, bytes32 pubkey) external;
	  function editValidator(address rewardTo, bytes32 introduction) external;
    function retire() external;
		function increaseMinGasPrice() external;
		function decreaseMinGasPrice() external;
}
```

An EOA can call `createValidator` to register itself as a candidate validator and set the following parameters:

1. `rewardTo`, the account who receives the validator's reward
2. `introduction`, a short UTF8 string (no longer than 32 bytes) describing the validator
3. `pubkey`, an ed25519 pubkey to which the coinbase transactions' outputs can vote.

After becoming a candidate validator, an EOA cannot call `createValidator` again. Instead, it can use `editValidator` to change `rewardTo` and  `introduction`, but the `pubkey` cannot be changed. 

A validator must pledge some BCH as collateral, which would be slashed should it misbehaves during its duty. Once its pledged collateral is less than a lower bound because of slashing, its voting power is reduced to zero until enough collateral is replenished. A validator can pledge collateral by sending BCH when calling `createValidator` and `editValidator`.

If a validator no longer wants to act as validator, it can call `retire` to mark its status as "retiring". The votes to a retiring validator is not counted when electing the next quorum.

### Adjust Gas Fee

Each validator can set its minimum acceptable gas price, which is used in relaying transactions and receiving transactions into mempool. This parameter is not a consensus parameter. There is another consensus parameter: chain-wide minimum gas price, which is the lower bound of the minimum gas prices set by different validators.

This chain-wide minimum gas price is modified by the validators. To increase (decrease) it by a predefined percentage, a qualified EOA call the `increaseMinGasPrice` (`decreaseMinGasPrice`) function, respectively. A qualified EOA is a validator, or a validator's `rewardTo` account.

### Distribute Rewards

For each executed block, the gathered gas fee is distributed to the validators who proposed or voted for it.

The proposer can get two kinds of rewards:

1. Reward for being a proposer, i.e., not missing its duty, which is 15% of all the gas fee.
2. Reward for collecting signatures for the last block, which is at most 15% of all the gas fee. This reward is in direct proportion to the voting power the proposer collected. When all the voting power is collected, it can enjoy 15%

After the proposer gets its rewards, the remained gas fee is distributed to the voters. The proposer is also a voter by nature, so it can also enjoy a proposer's reward. A proposer's reward is  in direct proportion to its voting power.

The distributed rewards are not immediately given to validators' `rewardTo` account. Instead, they are pending till the next epoch's end. That is, the rewards gained in epoch N will be given to a validator's `rewardTo` account at the end of epoch N+1.

A validator's life cycle ends when its voting power is zero and all the pending rewards are given to its `rewardTo` account. 

### Slashing

When a validator's mis-behavior is discovered, its pending rewards will be all confiscated and a fixed amount of collateral will be slashed. 

Currently, only double-signing is considered as a mis-behavior.