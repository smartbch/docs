# Benchmarking MoeingEVM and MoeingADS

After benchmarking the MoeingADS using [ESC Chain](./benchmarking-moeingads.md), which can only send tokens, you may be curious about how it performs on smart contracts. So now we introduce how to run benchmarks to test the performance of calling smart contracts with MoeingEVM and MoeingADS.

We simulate such a scenario that 100% of CPU resource is used for verifying the transactions in blocks. As Vitalik Buterin [pointed out](https://vitalik.ca/general/2021/05/23/scaling.html), it is better for a node to put only 10% of CPU resource in verifying blocks. So if we want to reach the "one billion gas every 15 seconds" target, we'd better make sure the performance of solely verifying blocks can reach about 10 billion gas every 15 seconds.

We use the following simple contract for benchmarking, because its behavior is quite easy to understand. You can find it at https://github.com/smartbch/smartbch/blob/main/testdata/basic/contracts/Stress.sol

```solidity
pragma solidity >=0.7.0;

contract Stress {
    mapping(uint32 => uint) private data;

    function run0(address to, uint32 offset) payable external {
        to.call{value: msg.value, gas: 9000}(new bytes(0));
        for(uint32 i = offset; i < offset + 10; i++) {
            data[i] = msg.value/3;
        }
    }

    function run(address to, uint256 param) payable external {
        to.call{value: msg.value, gas: 9000}(new bytes(0));
        uint32 a = uint32(param>>(32*0));
        uint32 b = uint32(param>>(32*1));
        uint32 c = uint32(param>>(32*2));
        uint32 x = uint32(param>>(32*3));
        uint32 y = uint32(param>>(32*4));
        uint32 z = uint32(param>>(32*5));
        data[c] = (data[a] + data[b] + msg.value)/2;
        data[z] = (data[x] + data[y] + msg.value)/2;
    }

    function run2(address to, address addr1, address addr2, uint256 param) payable external {
        to.call{value: msg.value/2, gas: 9000}(new bytes(0));
        uint32 a = uint32(param>>(32*0));
        uint32 b = uint32(param>>(32*1));
        uint32 c = uint32(param>>(32*2));
        uint32 x = uint32(param>>(32*3));
        uint32 y = uint32(param>>(32*4));
        uint32 z = uint32(param>>(32*5));
        data[c] = (data[a] + data[b] + msg.value)/2;
        data[z] = (data[x] + data[y] + msg.value)/2;
        Stress(addr1).run{value: msg.value/3}(addr2, param);
        Stress(addr2).run{value: msg.value/9}(addr1, param);
    }

    function get(uint32 d) external view returns (uint) {
        return data[d];
    }
}
```

The gas consumption of calling the functions is not fixed. When new storage slots are created, the gas consumption is high and when only existing slots get updated, the gas consumption is low.

The benchmark's source code can be found at https://github.com/smartbch/smartbch/blob/main/cmd/stresstest/stress.go . 

We selected four instances on AWS for the benchmark:

1. r6gd.2xlarge: Amazon Graviton2 Processor, 8 vCPUs, 64GB DRAM, 475GB SSD
2. m6gd.2xlarge: Amazon Graviton2 Processor, 16 vCPUs, 64GB DRAM, 950GB SSD
3. c6gd.2xlarge: Amazon Graviton2 Processor, 32 vCPUs, 64GB DRAM, 1900GB SSD
4. m5ad.4xlarge: AMD EPYC Processor, 16 vCPUs, 64GB DRAM, 600GB SSD

Now let's run this benchmark. The whole process takes more than 20 hours, so please be patient.

Step 0: please follow [this document](../developers-guide/runsinglenode.md) and finish the step 1, 2, 3 and 4.

Step 1: generate some random private keys into the file "keys60M.txt":

```bash
cd ~/smart_bch/smartbch/app/stresstest
go run -tags cppbtree . genkeys60
```

Step 2: generate several blocks filled with random transactions:

```bash
ulimit -n 60000
RANDFILE=~/go1.16.3.linux-amd64.tar.gz  go run -tags cppbtree . gen |tee gen.log
```

Step 3: replay the transactions in the generated blocks:

```bash
go build -tags cppbtree .
/usr/bin/time -v ./stresstest replay |tee replay.log
```

The generated transactions can be categorized into three groups:

1. Deploy the smart contracts
2. Initialize the storage slots and the target addresses, using the `run0` function
3. Transfer random amount of BCHs to the randomly-selected target addresses and overwrite some storage slots randomly, using the `run2` function

The benchmarks are written in such a way that transactions in group 2 always create new storage slots while transactions in group 3 always overwrite existing storage slots. Most real transactions' behavior is at some position in between: they both create new slots and overwrite existing slots.

These three groups of transactions are carried out in sequence. We care about the performance of group 3 and the last part of group 2.  Because when these transactions get executed, MoeingADS has already taken a lot of SSD space (200GB+) which is too large for OS to cache it in DRAM. 

The gathered results are:

| CPU          | Performance of Group 3 (billion gas per second) | Performance of Group 2 (billion gas per second) |
| ------------ | ----------------------------------------------- | ----------------------------------------------- |
| r6gd.2xlarge | 0.21                                            | 0.57                                            |
| m6gd.4xlarge | 0.34                                            | 0.86                                            |
| c6gd.8xlarge | 0.43                                            | 1.01                                            |
| m5ad.4xlarge | 0.29                                            | 0.77                                            |

When CPU count increases from 8 to 16, the speed-up is obvious; but when from 16 to 32, the speed-up is not so obvious. This is because there are some jobs which cannot be parallelized.

We can see that 16  Graviton2 vCPUs are faster than 16 EPYC vCPUs. This is because a vCPU of Graviton2 is a physical core, while a vCPU of EPYC is just one thread of the two threads running on a physical core.

According the results, m6gd.4xlarge has the best price/cost: it burns 5.1~12.9 billion gas in 15 seconds, and its price is lower than m5ad.4xlarge. 

