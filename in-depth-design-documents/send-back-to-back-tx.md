# Send back-to-back transactions

On Ethereum, sometimes a developer may want to do such a job:

1. Prepare three transactions for arbitrage at an earning smart contract:
	1. The first transaction: sell a lot of assets to lower the price
	2. The second transaction: deposit another asset at the lower price
	3. The third transaction: buy back the assets sold at the first transaction
2. Sign these three transactions with increasing nonces and a high enough gas price
3. Send them to the p2p network without any time interval between them

Then this developer assumes these there transactions will be placed back-to-back (without any other transactions among them) in the mempool and eventually they will be also packed back-to-back into a block and get executed in sequence, without any other transactions cutting into.

Can such a developer successfully do the same job on smartBCH. Unfortunately, no. On smartBCH, the only parital order of the transactions sent from the same account with increasing nonces is enforced. You cannot ensure they never get cut in by other transactions. And you cannot assume they will be packed into the same block, or into successive blocks.

First, because of [transaction reordering](tx-reorder.md), the transactions from a new block is shuffled before execution, and in an enforced-bundle, only one transaction for an address gets executed while the others are put to the tail of standby queue.

Second, no account can send transactions in the successive blocks. If Alice send a tranasaction X in block #N, she can not get a reliable number through `eth_gettransactioncount` (which returns her nonce number) because the transaction X is executed concurrently with the block #N+1 (and later blocks) getting proposed and voted. So smartBCH's mempool is designed to reject any transactions from Alice in the interval of block #N+1 after she send a transaction in block #N.

Last but not least, the P2P network's latency is variable. If the third transaction arrives at a node before the second, it will be rejected because of incorrect nonce.

If you do want to broadcast several back-to-back transactions in sequence, here is the recommended flow:

1. Send a transaction to a node and make sure it is accepted by the node's mempool
2. Send other transactions as in step #1, with increasing nonces, util a transaction is rejected by the nodes' mempool
3. Repeately calling `eth_gettransactioncount` util the returned nonce values equals your locally maintained nonce, which means the sent transaction all have been executed.
4. Go back to step #1 util there are no more transaction to send

Keep in mind it is most likeley that many transactions from other accounts are executed in between your transactions.

