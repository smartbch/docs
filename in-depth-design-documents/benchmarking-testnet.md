# Benchmarking a Testnet

Although MoeingADS and MoeingEVM are important libraries, what we most care about is always the performance of the whole blockchain, instead of its individual components.

To benchmark MoeingADS and MoeingEVM, we have developed some toolkits to generate random transactions and run them. They can also be used to benchmark the entire chain. You can find their source code at https://github.com/smartbch/smartbch/blob/main/cmd/stresstest . 

First, we follow the sames steps as [the benchmarks](benchmarking-moeingevm-moeingads.md) for MoeingADS and MoeingEVM, till the end of Step 2 (generate several blocks filled with random transactions). There will be a generated directory named `blkdata`, which contains the random transactions; and a `keys60M.txt` file, which constains some test keys.

Then, we need to start [a multi-node testnet](../developers-guide/runmultinode.md) or [a single-node testnet](../developers-guide/runsinglenode.md) first. Please note that we must give enough initial balances to the first 50,000 accounts in the `keys60M.txt` file, such that they can send transactions.

Now we can use a node's websocket to broadcast these random transactions:

```bash
./stresstest replayWS ws://the-ip-address-of-a-smartbch-node:8546 
```

Finally we can query about the status of executed transactions:

```bash
./stresstest queryTxsWS ws://the-ip-address-of-s-smartbch-node:8546 <stop-height>
```

Or we can draw some charts showing the chain's performance:

```bash
./stresstest queryBlocksWS ws://the-ip-address-of-s-smartbch-node:8546 <stop-height> <start-height> true
```

After running above commands, there will a `charts.html` file in current directory showing the following numbers in every 100 blocks: 1, Transaction Count; 2, Block Size; 3, Used Gas; 4, Block Interval.


