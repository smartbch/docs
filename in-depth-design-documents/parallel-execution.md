# Transaction Parallel Execution in smartBCH

In this article, we describe how multiple transactions are executed in parallel, and how the execution engine and the consensus engine work concurrently.

### Execution Engine and Consensus Engine

Tendermint is the consensus engine of smartBCH, and it takes the charge of proposing new blocks and voting for them. And smartBCH's execution engine is a state machine: it takes committed blocks from tendermint as input, updates the world state accordingly and outputs logs and transaction&block records.

The block interval can be divided into two phase: committing phase and post-commit phase. The committing phase begins when tendermint collects enough voting power for the next block, and ends when the execution engine returns the AppHash (Merkle root of world state) back to tendermint.

During the committing phase, tendermint does the following job:

1. Collect more votes and try to reach 100% vote power for the next block (100% is not preferred but not required)

During the post-commit phase, tendermint does the following job:

1. Use the returned AppHash and accumulated transactions in mempool to propose a new block
2. Broadcast and vote for the new block
3. When the voting power reaches 2/3, feed the new block to the execution engine

During the committing phase, the execution engine does the following job:

1. Preprocess the transactions in the new block
2. Save the valid transactions into standby queue (which is part of the world state)
3. Calculate AppHash

During the post-commit phase, the execution engine does the following job:

1. Fetch transactions out from the standby queue
2. Execute the transactions in parallel
3. Update the world state according to the successfully committed transactions

In practice the committing phase is more time-consuming, especially when there are a lot of transactions and a lot of validators. But making the two engines concurrently do their jobs, more transactions can be executed and more votes can be collected.

### Transaction handling in the committing phase

The committing phase can be divided into four sub-phases.

In the first sub-phase, the transactions are parallelly checked for:

1. Whether the signature is valid
2. Whether the from-account exists.
3. Whether the gas limit is under the upper limit
4. Whether the gas price is higher than the minimum price

In the second sub-phase, the transactions are pseudo-randomly reordered. The detailed algorithm is described [here](./tx-reorder.md).

In the third sub-phase, the reordered transactions are parallelly processed:

1. If the transaction's nonce does not match the from-account's nonce, mark it as invalid
2. Deduct the gas fee from the from-accounts, which is calculated as `GasPrice*GasLimit`. The nonce of from-accounts are NOT modified here.

In the last sub-phase, all the valid transactions are saved into the standby queue, and AppHash is calculated from the latest world state.

### Transaction handling in the post-commit phase

In this phase transactions are handled in several "rounds". At each round, following tasks are done：

1. Load at most $N$ transactions from the standby queue
2. Execute these transactions concurrently and independently. For each transaction,
   1. Execute it in an isolated context which buffers all its modifications to the world state. The nonce of from-account is updated here.
   2. After execution, refund the unused gas fee back to the from-address, and the refund amount is calculated as `GasPrice*(GasLimit-GasUsed)`
3. Analyze these transactions' dependency one by one and decide whether each transaction can be committed:
   1. If it can be committed, write its modification to the world state
   2. If not, insert it back to the end of the standby queue

For each block, at most $M$ rounds will be run. If there are too many transactions in the standby queue, they cannot be finished in  one block. In some cases, a transaction will be executed several blocks after it is added to the standby queue.

How to analyze the dependency? Since the world state is just a set of key-value pairs, we just keep a "touched key set" of the pairs which were updated by previous committed transactions. The next transaction can commit if and only if it never read or write a pair whose key is in the set. For the different kinds of key-value pairs in the world state, please refer to [data structures in world state](data-structures-in-world-state.md).  