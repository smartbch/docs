# Gas Estimation and Limit

On smartBCH, please always estimate your transaction's gas consumption and set its "gas limit" close to this estimated value. 

Unlike go-ethereum, smartBCH just packs all the transactions into block and propose it. The transactions are not executed before the block is proposed. Thus we can do the tx-reordering and parallel execution: the exact tx ordering is not decided until every node gets the transactions. So when a validator proposes a block, it does not know the exact gas consumption of the transactions. But we do need to set a block level gas consumption upper bound, such that a block does not takes too long to execute. We decided to sum up all the transactions gas limits to get the block's gas limit, as an estimation.

But another problem comes: if some bad guy set an extremely-high gas limit to his transactions, one block cannot contain a lot of transactions! So we add this penalty: if your gas limit is not a good estimation of the actual gas consumption, you'll be punished.

