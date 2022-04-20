# Single Node Private Testnet

This document shows how to start a private testnet of smartBCH with only one node. 

We suggest to use ubuntu 20.04.



#### Step 0: install the basic tools.

```bash
sudo sed -i -e '$a* soft nofile 65536\n* hard nofile 65536' /etc/security/limits.conf ;# enlarge count of open files
sudo apt update
sudo apt install make cmake g++ gcc git 
```

Then download and unpack golang (If you are using ARM Linux, please replace "amd64" with "arm64"):

```bash
wget https://go.dev/dl/go1.18.linux-amd64.tar.gz
tar zxvf go1.18.linux-amd64.tar.gz
```

And set some environment variables for golang:

```bash
export GOROOT=~/go
export PATH=$PATH:$GOROOT/bin
mkdir ~/godata
export GOPATH=~/godata
```

After installing golang, we need to patch it for larger cgo stack.

```bash
wget https://github.com/smartbch/patch-cgo-for-golang/archive/refs/tags/v0.1.2.tar.gz
tar zxvf v0.1.2.tar.gz 
rm v0.1.2.tar.gz
cd patch-cgo-for-golang-0.1.2
cp *.c $GOROOT/src/runtime/cgo/
```



#### Step 1: install dependencies

firsrt, install rocksdb dependencies.

```bash
sudo apt install gcc-8 g++-8
sudo apt install libgflags-dev 
```

For some unknown reason, on some machines with ubuntu 20.04, the default libsnappy does not work well. So we suggest to build libsnappy from source:

```bash
mkdir $HOME/build
cd $HOME/build
wget https://github.com/google/snappy/archive/refs/tags/1.1.8.tar.gz
tar zxvf 1.1.8.tar.gz
cd snappy-1.1.8
mkdir build
cd build
cmake -DBUILD_STATIC_LIBS=On ../
make
sudo make install
```

then install rocksdb

```bash
cd $HOME/build
wget https://github.com/facebook/rocksdb/archive/refs/tags/v5.18.4.tar.gz
tar zxvf v5.18.4.tar.gz
cd rocksdb-5.18.4
make CC=gcc-8 CXX=g++-8 static_lib
```

more infos can refer to [rocksdb install doc](https://github.com/facebook/rocksdb/blob/master/INSTALL.md)

Last, export library path. You should export `ROCKSDB_PATH` with rocksdb root directory downloaded from above

```bash
export ROCKSDB_PATH="$HOME/build/rocksdb-5.18.4" ;#this direct to rocksdb root dir
```



#### Step 2: create the `smart_bch` directory.

```bash
cd ~ ;# any directory can do. Here we use home directory for example
mkdir smart_bch
cd smart_bch
```



#### Step 3: clone the moeingevm repo, and build static linked library.

```bash
cd ~/smart_bch
git clone -b v0.4.2 --depth 1 https://github.com/smartbch/moeingevm
cd moeingevm/evmwrap
make
export CGO_CFLAGS="-I$ROCKSDB_PATH/include"
export CGO_LDFLAGS="-L$ROCKSDB_PATH -L$HOME/smart_bch/moeingevm/evmwrap/host_bridge/ -l:librocksdb.a -lstdc++ -lm -lz -lbz2 -lsnappy -llz4 -lzstd"
```

After successfully executing the above commands, you'll get a ~/smart\_bch/moeingevm/evmwrap/host\_bridge/libevmwrap.a file.



#### Step 4: clone the source code of smartBCH and build the executable of `smartbchd`.

```bash
cd ~/smart_bch
git clone -b v0.4.4 --depth 1 https://github.com/smartbch/smartbch
cd smartbch
go build -tags cppbtree github.com/smartbch/smartbch/cmd/smartbchd
```

After successfully executing the above commands, you'll get a ~/smart\_bch/smartbch/smartbchd file.



#### Step 5: generate some private keys only used for test.

```bash
cd ~/smart_bch/smartbch
./smartbchd gen-test-keys -n 10
7fc6cf51adb430d9220c9f3ed4e992e75b5d1e8e52fe2bc99183cadc141725bc
08c65e04cd27b03d8bb8d19ffadadd82c2dd0935e3f23f313857a2c9629bba43
594d82ba88e52b2e037da8513493074eee5e6a6820d836afee5764fb78830285
433721d2f0e5c90d0a67a91153eaac3aa9db974ba9b4b9a7be219f02c12c015d
ff1f7f7276b877274043a42d17258b79dd4fd32ca17c48a5dc75049c1f931841
bab883ae3c7578be66ba5f1c1798dd52ab84ff9403a62c0b478491264df4a50e
2698171de1409b229fa14b71fa982507b276c7234c34cee8c42ac0713a614a4f
cb7883806fa970ef34b10286b80122b3188b09a24d154d2b81fb30e61c8b99ad
e58d53577a8c30b550db1b461c5aee5c8368946be945819cdfdd77dd990e55cd
fbb4694007aff7a979f46e76f9ec522015ed74702594864bde419a6c4a24f377
```

The output private keys will be used as input for the next step.

A validator needs two private keys: one ed25519 key for consensus engine (tendermint) and one secp256k1 key for operate it using smart contracts. Now we pick the secp256k1 key out from above generated keys. We just choose the first one and show its corresponding address:

```bash
ethereum_private_key_to_address 7fc6cf51adb430d9220c9f3ed4e992e75b5d1e8e52fe2bc99183cadc141725bc
0xd5Fd2C57069d93B6cE3126275a288D21b8aA2E87
```

If you have not installed the `ethereum_private_key_to_address` tool, install it as below:

```bash
sudo apt install npm
npm install -g ethereum-private-key-to-address
```



#### Step 6: initialize the node data using test keys generated above:

```bash
./smartbchd init mynode --chain-id 0x2711 \
  --init-balance=1000000000000000000000000000000 \
  --test-keys="7fc6cf51adb430d9220c9f3ed4e992e75b5d1e8e52fe2bc99183cadc141725bc,\
08c65e04cd27b03d8bb8d19ffadadd82c2dd0935e3f23f313857a2c9629bba43,\
594d82ba88e52b2e037da8513493074eee5e6a6820d836afee5764fb78830285,\
433721d2f0e5c90d0a67a91153eaac3aa9db974ba9b4b9a7be219f02c12c015d,\
ff1f7f7276b877274043a42d17258b79dd4fd32ca17c48a5dc75049c1f931841,\
bab883ae3c7578be66ba5f1c1798dd52ab84ff9403a62c0b478491264df4a50e,\
2698171de1409b229fa14b71fa982507b276c7234c34cee8c42ac0713a614a4f,\
cb7883806fa970ef34b10286b80122b3188b09a24d154d2b81fb30e61c8b99ad,\
e58d53577a8c30b550db1b461c5aee5c8368946be945819cdfdd77dd990e55cd,\
fbb4694007aff7a979f46e76f9ec522015ed74702594864bde419a6c4a24f377"
```

After successfully executing the above commands, you can find the initialized data in the `~/.smartbchd` directory. By using the `--home` option for `./smartbchd` command, you can specify another directory. In the  `~/.smartbchd` directory, the genesis file specifies that all the EOAs corresponding to the above private keys will have a balance of 1000000000000000000000000000000.



#### Step 7: generate genesis validator consensus key info

Now we generate the ed25519 private key for consensus engine:

```bash
./smartbchd generate-consensus-key-info | tee generate-consensus-key-info.txt
d6569de9567bac00d9946dc72ca71ffe0ff735729eb966e8437d6b6b24fe0ff1
```

The output hex string is consensus pubkey which will be used in `generate-genesis-validator` command, and a file containing the consensus public and private key is generated under the current directory, named `priv_validator_key.json`.

Since now we are just running a single node for test, the key file is not so important. In production, a validator's operator must take good care of this key file `priv_validator_key.json` and back it up safely.



#### Step 8: generate genesis validator info using pubkey generated above

```bash
./smartbchd generate-genesis-validator \
	--validator-address=0xd5Fd2C57069d93B6cE3126275a288D21b8aA2E877 \
	--consensus-pubkey=d6569de9567bac00d9946dc72ca71ffe0ff735729eb966e8437d6b6b24fe0ff1 \
	--voting-power=1 \
	--staking-coin=1000000000000000000000 \
	--introduction="freeman"
7b2241646472657373223a5b3231332c3235332c34342c38372c362c3135372c3134372c3138322c3230362c34392c33382c33392c39302c34302c3134312c33332c3138342c3137302c34362c3133355d2c225075626b6579223a5b3231352c362c3232372c3135392c3232302c37312c39342c36372c3235312c3230352c3139332c3233312c3231352c3232342c3130342c3132342c3232352c37352c36332c3235312c3133352c3139392c3233302c3135372c352c3138372c32362c3234352c32312c3136362c37352c36355d2c22526577617264546f223a5b3231332c3235332c34342c38372c362c3135372c3134372c3138322c3230362c34392c33382c33392c39302c34302c3134312c33332c3138342c3137302c34362c3133355d2c22566f74696e67506f776572223a312c22496e74726f64756374696f6e223a22667265656d616e222c225374616b6564436f696e73223a5b302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c352c3130372c3139392c39342c34352c39392c31362c302c305d2c2249735265746972696e67223a66616c73657d
```

The `validator-address` uses the one we get at step 5, and the `consensus-pubkey` is the one we get at step 7.

The output hex string contains the information of a validator.



#### Step 9: add genesis validator info to genesis.json using hex string generated above

```bash
./smartbchd add-genesis-validator \
7b2241646472657373223a5b3231332c3235332c34342c38372c362c3135372c3134372c3138322c3230362c34392c33382c33392c39302c34302c3134312c33332c3138342c3137302c34362c3133355d2c225075626b6579223a5b3231352c362c3232372c3135392c3232302c37312c39342c36372c3235312c3230352c3139332c3233312c3231352c3232342c3130342c3132342c3232352c37352c36332c3235312c3133352c3139392c3233302c3135372c352c3138372c32362c3234352c32312c3136362c37352c36355d2c22526577617264546f223a5b3231332c3235332c34342c38372c362c3135372c3134372c3138322c3230362c34392c33382c33392c39302c34302c3134312c33332c3138342c3137302c34362c3133355d2c22566f74696e67506f776572223a312c22496e74726f64756374696f6e223a22667265656d616e222c225374616b6564436f696e73223a5b302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c352c3130372c3139392c39342c34352c39392c31362c302c305d2c2249735265746972696e67223a66616c73657d
```

Using the hex string outputted at the last step as the argument, we call `add-genesis-validator`. It adds one validator's information into the genesis file. You can use this command repeatedly to add more validators. Since we only need one validator for single node test, here we just use this command once.



#### Step 10: copy priv_validator_key.json generated in Step 7

```bash
cp ./priv_validator_key.json ~/.smartbchd/config/
```

Thus, when this node starts up, it can use the private consensus key.



#### Step 11: start the node:

```bash
ulimit -n 65536
./smartbchd start --unlock="7fc6cf51adb430d9220c9f3ed4e992e75b5d1e8e52fe2bc99183cadc141725bc,\
08c65e04cd27b03d8bb8d19ffadadd82c2dd0935e3f23f313857a2c9629bba43,\
594d82ba88e52b2e037da8513493074eee5e6a6820d836afee5764fb78830285,\
433721d2f0e5c90d0a67a91153eaac3aa9db974ba9b4b9a7be219f02c12c015d,\
ff1f7f7276b877274043a42d17258b79dd4fd32ca17c48a5dc75049c1f931841,\
bab883ae3c7578be66ba5f1c1798dd52ab84ff9403a62c0b478491264df4a50e,\
2698171de1409b229fa14b71fa982507b276c7234c34cee8c42ac0713a614a4f,\
cb7883806fa970ef34b10286b80122b3188b09a24d154d2b81fb30e61c8b99ad,\
e58d53577a8c30b550db1b461c5aee5c8368946be945819cdfdd77dd990e55cd,\
fbb4694007aff7a979f46e76f9ec522015ed74702594864bde419a6c4a24f377"
```

You can also ignore the `unlock` argument to unlock no accounts.

This command starts the node which provides JSON-RPC service at localhost:8584. You can use the `--http.addr` option to select another port other than localhost:8584. We unlocked accounts created at genesis, which can be shown using the following command:


You can also use `--mainnet-url` option to specify a bitcoincashnode's RPC endpoint, and use `--home` option to specifiy another data directory other than ~/.smartbchd .

```bash
# Run this command in another terminal:
curl -X POST --data '{"jsonrpc":"2.0", "method":"eth_accounts", "params":[],"id":1}' \
    -H "Content-Type: application/json" http://localhost:8545 | jq
```

And you can see something like:

```javascript
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": [
    "0x876367b14fe2c725ed4bfc4ace406ea53db58d0f",
    "0x8c1fe0ad5e59d72ffd064ff80e0c605530af8806",
    "0xa321e9ca672fb04b3c57160f93a40b70fb3f1d6b",
    "0xa6f8d15b18b2b93cbf7fae192184ccd9e03bfaf4",
    "0xb77f11af5206fdfd87011744ea1c0b3bf77ca4ec",
    "0xc38a47a2481bc692c2203e7e7e5e73c474bea43c",
    "0xd5fd2c57069d93b6ce3126275a288d21b8aa2e87",
    "0xdc7c3b6c76eed26bf224a9f1a300b79ce8bc68b2",
    "0xf995503a428d2deaeb53075dc0476affeee95f05",
    "0xfb2c39aafd37c6d17e16b73cc8601f77ed5586b9"
  ]
}
```

You can find the documents for RPC [here](jsonrpc.md).
