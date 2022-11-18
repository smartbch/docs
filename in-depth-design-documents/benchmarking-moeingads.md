# Benchmarking MoeingADS

MoeingADS is the most important corner stone of Smart Bitcoin Cash. MoeingADS puts an upper bound for Smart Bitcoin Cash's throughput. You may want to know, when ignoring all the other factors \(consensus engine, smart contract execution, etc\) and only having MoeingADS in the critical path, how high can the throughput reach? Because no matter how hard we optimize the other parts of Smart Bitcoin Cash, its throughput cannot get higher than this upper limit.

Let's suppose there is a chain named "Extreme Stable Coin Chain" \(ESC Chain\). Its characters include:

1. It uses EOS-style DPoS consensus algorithm. A super node generates 100 blocks and then the next super node takes turn.
2. It does not support smart contracts.
3. It has one native token to pay gas fee and several other types of stable coins.
4. The amounts of coins are represented as 256-bit integers.
5. One account can own at most 8 types of stable coins.
6. The only transaction type is sending one kind of stable coin or the native token to another account, while deducting sender's native token as gas fee.

When producing a block, a super node 1\) collects the incoming transactions sent through P2P network, 2\) execute the transactions and update the world state, 3\) packs the executed valid transactions into blocks. Clearly these three steps can be pipelined and the second step is the most time consuming. The other two stages in the pipeline, step 1 and step 3, can hide their latency behind step 2.

By the way, although ESC Chain is rather simple, it is not a toy. If someone fully implements it and persuade WalMart, Amazon, Steam, Reddit and Twitter to use it, it would be a big business.

## What the benchmarks do

We are not implementing ESC chain here. We just write benchmarks to mimic what is done in the most time consuming step 2. These benchmarks are enough to show how fast ESC chain can run.

The benchmarks simulate such a system: there are totally 100 stable coins, and $n$ accounts, each of which has 1~8 types of coins. The coins' amounts are initialized with random numbers. In each transaction, one account sends some amount of stable coin to another account. The amounts are chosen randomly but with constraints, such that the amounts do not overflow or underflow after sending, which means all the transactions are valid. In each transaction, 10 native tokens are deducted from the sender's account as gas fee, and the sender's sequence number is increased by one to prevent replay attacks. The transactions' digital signatures are not checked in the benchmark, because this task can be easily offloaded to other CPUs or other machines.

The benchmarks are:

1. **genacc**: it generates $n$ random accounts into the system. The generating process will continue for $n/20000$ blocks and during each block 20000 random accounts are generated.
2. **checkacc**: it reads the $n$ generated accounts out, in a randomized order. It can show the QPS \(queries per second\) MoeingADS can support.
3. **runtx**: it runs $m$ blocks, and each block has 128K random valid transactions. It can show the TPS \(transactions per second\) MoeingADS can support.

## How to run the benchmarks

The test machine must have 32GB DRAM and about 800GB free SSD space. Such a machine can also run an go-ethereum client smoothly. The OS must be Linux or MacOS \(Windows is not supported\) and please install [golang](https://golang.org/doc/install) and [rocksdb](https://github.com/facebook/rocksdb/blob/master/INSTALL.md) beforehand. You can follow this [guide](../developers-guide/build-smartbchd.md) to install them. The machine used in this article is m6gd.4xlarge instance, with 16 vCPUs, 64GB DRAM and 900GB SSD.

Step 0: check out the benchmarks' code and build executable.

```bash
$ mkdir ~/benchmark; cd ~/benchmark
$ git clone https://github.com/smartbch/moeingads
$ cd moeingads/store/escchainbench
$ go build -tags cppbtree
```

After executing above commands, you'll have an executable file named `escchainbench` in the current directory.

Step 1: set some parameters.

```bash
$ export RANDFILE=path-to-a-large-file
$ export ACCNUM=$((841*1000*1000))
$ export BLKCOUNT=2000
```

RANDFILE is a large file used as random seeds. You can use a compressed archive file or a video file. ACCNUM is the total number of generated accounts in the simulated system. It's set to 841 million, which is roughly the population of European Union. BLKCOUNT is the number of blocks will be executed in the TPS test.

Step 2: generate the accounts randomly.

```bash
$ time -v ./escchainbench genacc $ACCNUM |tee gen.log
```

We use the `time` command to record how much DRAM is used by the benchmark.

On m6gd.4xlarge, `genacc` takes 12291 seconds to create the 841 million accounts and the maximum resident set in DRAM is 15.5GB. Averagely 68424 accounts can be created in one second.

Step 3: test the query speed.

```bash
$ time -v ./escchainbench checkacc $ACCNUM |tee check.log
```

On m6gd.4xlarge, `checkacc` takes 1705 seconds to read all the 841 million accounts, averagely 493K queries per second.

Step 4: test the transaction execution throughput \(TPS\).

```bash
$ time -v ./escchainbench gentx $ACCNUM $BLKCOUNT |tee gentx.log
$ time -v ./escchainbench runtx $BLKCOUNT |tee runtx.log
```

First, `gentx` generates blocks of random transactions and then `runtx` executes these transactions. After this step, the data base's size is 664GB.

On m6gd.4xlarge, `runtx` takes 1043 seconds to load data from SSD and takes 5103 seconds to execute the 2000\*128\*1024=262144000 transactions and the maximum resident set in DRAM is 16.8GB. The TPS is 262144000/5103=51370. If each transaction costs 21000 gas \(the intrinsic gas of an Ethereum transaction\), then in 15 seconds 16.2 billion \(21000\*51370\*15\) gas can be consumed.

The `time` command shows "Percent of CPU this job got" is 558%. Since the instance has 16 vCPUs, it allows the system to further exploit hardware's parallelism, for example, the step 1 and 3 running in parallel with step 2.

A block on Ethereum can consume at most 15 million gas in 15 seconds. So ESC chain is about 1080 times faster than ethereum in payment.

## Conclusion

We present a conceptual chain named ESC \(Extreme Stable Coin\) chain which focuses on stable coin payment. Benchmarks show that when built on MoeingADS, ESC chain can consume 16.2 billion gas in 15 seconds, which is 1080 times faster than Ethereum.

ESC chain is an application-specific chain without smart contract support. Smart Bitcoin Cash is more powerful and thus has overhead. We do not expect it can run as fast as ESC chain. But 16.2 billion gas gives us enough confidence that Smart Bitcoin Cash can achieve the "one billion gas every 15 seconds" target.

