# Send back-to-back transactions

On Ethereum, sometimes Alice may want to do such a job:

1. Prepare three transactions for arbitrage at an earning smart contract:
	1. The first transaction: sell a lot of assets to lower the price
	2. The second transaction: deposit another asset at the lower price
	3. The third transaction: buy back the assets sold at the first transaction
2. Sign these three transactions with increasing nonces and a high enough gas price
3. Send them to the p2p network without any time interval between them

Then Alice assumes these transactions will be placed back-to-back (without any other transactions among them) in the mempool and eventually they will be also packed back-to-back into a block and get executed in sequence, without any other transactions cutting into.

Can such a developer successfully do the same job on smartBCH? Unfortunately, no. On smartBCH, the only partial order of the transactions sent from the same account with increasing nonces is enforced. You cannot ensure they never get cut in by other transactions. And you cannot assume they will be packed into the same block, or into successive blocks.

Because of [transaction reordering](tx-reorder.md), the transactions from a new block are shuffled before execution, and in an enforced bundle, only one transaction for an address gets executed while the others are put to the tail of the standby queue.

Although the sequence of transactions from different accounts is not ensured, transaction reordering keeps the relative positions between the transactions from the same account. Furthermore, smartBCH's full-node client allows Alice's successive transactions to enter mempool smoothly, with some limitations:

- If in block N's interval, Alice has one or more transactions entering mempool and/or getting packed into a block:
  - Then, in block N+1's interval, the total gas limit of all the transactions which are sent into mempool by Alice must be no larger than 5,000,000.
- Or else (In block N's interval, Alice has no transaction):
  - Then, in block N+1's interval, the first transaction sent by Alice can specify any gas limit.
  -  The total gas limit of all the following transactions from Alice must be no larger than 5,000,000.

In most cases, if you are just sending several transactions manually through a wallet such as MetaMask, every transaction will be accepted into mempool, even when some of them have not been packed into a block yet.

But if you are sending a lot of transactions using a script, when the mentioned 5,000,000 gas limit may block some of them. In such cases, we suggest using a dedicated smart contract to batch all the needed contract calls.
