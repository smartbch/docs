# Benchmarking MoeingEVM and MoeingADS

After benchmarking the MoeingADS using [ESC Chain](./benchmarking-moeingads.md), which can only send tokens, you may be curious about how it performs on smart contracts. So now we introduce how to run benchmarks to test the performance of calling smart contracts with MoeingEVM and MoeingADS.

We use the following simple contract for benchmarking, because its behavior is quite easy to understand. You can find it at https://github.com/smartbch/smartbch/blob/main/testdata/basic/contracts/TestAdd.sol

```solidity
contract TestAdd {
    mapping(uint32 => uint) private data;

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

    function get(uint32 d) external returns (uint) {
        return data[d];
    }
}
```

The gas consumption of calling the function `run` is not fixed. We just test a modest case where no new slot and account are created. In such as case, the gas consumption is 43722.

The benchmark's source code can be found at https://github.com/smartbch/smartbch/blob/main/app/stresstest/stress.go . 

We selected two instances on AWS for the bencharmk:

1. m6gd.2xlarge: Amazon Graviton2 Processor, 8 vCPUs, 32GB DRAM, 475GB SSD
2. m5ad.4xlarge: AMD EPYC Processor, 16 vCPUs, 64GB DRAM, 600GB SSD

Now let's run this benchmark. The whole process takes more than 20 hours, so please be patient.

Step 0: please follow [this document](../developers-guide/runsinglenode.md) and finish the step 1, 2, 3 and 4.

Step 1: generate some random private keys into the file "keys60M.txt":

```bash
cd ~/smart_bch/smartbch/app/stresstest
go run -tags cppbtree . genkeys60
```

Step 2: generate several blocks filled with random transactions:

```bash
ulimit -n 30000
RANDFILE=~/go1.16.3.linux-amd64.tar.gz  go run -tags cppbtree . gen |tee gen.log
```

Step 3: replay the transactions in the generated blocks:

```bash
RANDFILE=~/go1.16.3.linux-amd64.tar.gz  go run -tags cppbtree . replay |tee replay.log
```

The generated can be categorized into three groups:

1. Deploy the smart contracts
2. Initialize the storage slots and the target address
3. Transfer random amount of BCHs to the random selected target addresses and overwrite the storage slots randomly.

We just care about the performance of group 3. Because after the blocks in group 2, MoeingADS has already taken a lot of SSD space which is too large to be cached in DRAM. In 1000 blocks of group 3, there are 50K EOAs sending transactions, 50K contract addresses which each contains 1000 storage slots to be read and written, and 50M EOAs accepting coins. To contain these data, MoeingADS takes 100+ GB disk.

The result shows that on m5ad.4xlarge, MoeingEVM averagely takes 1.79 sec to execute the 10K transactions in a block of group 3. So in each second `43722*10000/1.79=244,256,983` (0.244 billion) gas can be burnt. For m6gd.2xlarge, the result is 0.127 billion.
