# Build smartbchd

This document shows how to build `smartbchd` \(the executable of smartBCH's full node client\). We suggest to use ubuntu 20.04.



#### Step 0: install the basic tools.

We suggest to use GCC-9 because it's the default compiler of ubuntu 20.04. But you call as well use GCC-10 and GCC-11. Just replace the following g++ and gcc with your desired compilers (such as g++-10/gcc-10/g++-11/gcc-11).

```bash
sudo sed -i -e '$a* soft nofile 65536\n* hard nofile 65536' /etc/security/limits.conf ;# enlarge count of open files
sudo apt update
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
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
CXX=g++ cmake -DBUILD_STATIC_LIBS=On ../
make CC=gcc CXX=g++
sudo make install
```

then install rocksdb

```bash
cd $HOME/build
wget https://github.com/facebook/rocksdb/archive/refs/tags/v5.18.4.tar.gz
tar zxvf v5.18.4.tar.gz
cd rocksdb-5.18.4
curl https://raw.githubusercontent.com/smartbch/artifacts/main/patches/rocksdb.gcc11.patch | git apply -v
CXXFLAGS=-Wno-range-loop-construct make CC=gcc CXX=g++ static_lib
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
git clone -b v0.4.3 --depth 1 https://github.com/smartbch/moeingevm
cd moeingevm/evmwrap
make
export CGO_CFLAGS="-I$ROCKSDB_PATH/include"
export CGO_LDFLAGS="-L$ROCKSDB_PATH -L$HOME/smart_bch/moeingevm/evmwrap/host_bridge/ -l:librocksdb.a -lstdc++ -lm -lsnappy "
```

After successfully executing the above commands, you'll get a ~/smart\_bch/moeingevm/evmwrap/host\_bridge/libevmwrap.a file.



#### Step 4: clone the source code of smartBCH and build the executable of `smartbchd`.

```bash
cd ~/smart_bch
git clone -b v0.4.5 --depth 1 https://github.com/smartbch/smartbch
cd smartbch
go build -tags cppbtree github.com/smartbch/smartbch/cmd/smartbchd
```

After successfully executing the above commands, you'll get a ~/smart\_bch/smartbch/smartbchd file.

