# Single Node Private Testnet

This document shows how to start a private testnet of smartBCH with only one node. 

We suggest to use ubuntu 20.04.

Step 1: install dependencies

firsrt, install rocksdb dependencies.

```bash
sudo apt install gcc-8 g++-8
sudo apt-get install libgflags-dev
# sudo apt-get install libsnappy-dev
sudo apt-get install zlib1g-dev
sudo apt-get install libbz2-dev
sudo apt-get install liblz4-dev
sudo apt-get install libzstd-dev
```

For some unknown reason, on some machines with ubuntu 20.04, the default libsnappy does not work well. So we suggest to build libsnappy from source:

```bash
mkdir $HOME/build
cd $HOME/build
wget https://github.com/google/snappy/archive/refs/tags/1.1.8.tar.gz
tar zxvf 1.1.8.tar.gz
cd snappy-1.1.7
mkdir build
cd build
cmake -DBUILD_SHARED_LIBS=On ../
make
sudo make install
```

then install rocksdb

```bash
cd $HOME/build
wget https://github.com/facebook/rocksdb/archive/refs/tags/v5.18.4.tar.gz
tar zxvf v5.18.4.tar.gz
cd rocksdb-5.18.4
make CC=gcc-8 CXX=g++-8 shared_lib
```

more infos can refer to [rocksdb install doc](https://github.com/facebook/rocksdb/blob/master/INSTALL.md)

Last export library path, you should export `ROCKSDB_PATH` with rocksdb root directory downloaded from above

```bash
export ROCKSDB_PATH="$HOME/build/rocksdb-5.18.4" ;#this direct to rocksdb root dir
export CGO_CFLAGS="-I/$ROCKSDB_PATH/include"
export CGO_LDFLAGS="-L/$ROCKSDB_PATH -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy -llz4 -lzstd"
export LD_LIBRARY_PATH=$ROCKSDB_PATH
```

Step 2: create the `smart_bch` directory.

```bash
cd ~ ;# any directory can do. Here we use home directory for example
mkdir smart_bch
cd smart_bch
```

Step 3: clone the moeingevm repo, and build dynamically linked library.

```bash
cd ~/smart_bch
wget https://github.com/smartbch/moeingevm/archive/refs/tags/v0.1.0.tar.gz
tar zxvf v0.1.0.tar.gz
rm v0.1.0.tar.gz
mv moeingevm-0.1.0/ moeingevm
cd moeingevm/evmwrap
make
```

After successfully executing the above commands, you'll get a ~/smart\_bch/moeingevm/evmwrap/host\_bridge/libevmwrap.so file.

Step 4: clone the source code of smartBCH and build the executable of `smartbchd`.

```bash
cd ~/smart_bch
wget https://github.com/smartbch/smartbch/archive/refs/tags/v0.1.0.tar.gz
tar zxvf v0.1.0.tar.gz
mv smartbch-0.1.0/ smartbch
rm v0.1.0.tar.gz
cd smartbch
go build github.com/smartbch/smartbch/cmd/smartbchd
```

After successfully executing the above commands, you'll get a ~/smart\_bch/smartbch/smartbchd file.

Step 5: generate some private keys only used for test.

```bash
$ cd ~/smart_bch/smartbch
$ export EVMWRAP=~/smart_bch/moeingevm/evmwrap/host_bridge/libevmwrap.so
$ ./smartbchd gen-test-keys -n 10
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

Step 6: initialize the node data using test keys generated above:

```bash
$ ./smartbchd init mynode --chain-id 0x1 \
  --init-balance=10000000000000000000 \
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

After successfully executing the above commands, you can find the initialized data in the `~/.smartbchd` directory. By using the `--home` option for `./smartbchd` command, you can specify another directory.

Step 7: start the node:

```bash
$ ./smartbchd start
```

This command starts the node which provides JSON-RPC service at localhost:8584. You can use the `--http.addr` option to select another port other than localhost:8584. By default, there are ten accounts created at genesis, which can be shown using the following command:

```bash
# Run this command in another terminal:
$ curl -X POST --data '{"jsonrpc":"2.0", "method":"eth_accounts", "params":[],"id":1}' \
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

You can find the documents for RPC [here](https://github.com/smartbch/docs/tree/8282c530b70c78b50bf4438575fbf9ff50539882/dev/json-rpc.md).

