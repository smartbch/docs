# Single Node Test

This document shows how to start a private testnet of smartBCH with only one node.

Step 1: create the `smart_bch` directory.

```bash
$ cd ~ # any directory can do. Here we use home directory for example
$ mkdir smart_bch
$ cd smart_bch
```



Step 2: clone the moeingevm repo, and build dynamically linked library.

```bash
$ cd ~/smart_bch
$ git clone https://github.com/smartbch/moeingevm.git
$ cd moeingevm/evmwrap
$ make
```

After successfully executing the above commands, you'll get a ~/smart_bch/moeingevm/evmwrap/host_bridge/libevmwrap.so file.



Step 3: clone the source code of smartBCH and build the executable of `smartbchd`.

```bash
$ cd ~/smart_bch
$ git clone https://github.com/smartbch/smartbch.git
$ cd smartbch
$ go build github.com/smartbch/smartbch/cmd/smartbchd
```

After successfully executing the above commands, you'll get a ~/smart_bch/smartbch/smartbchd file.



Step 4: initialize the node:

```bash
$ cd ~/smart_bch/smartbch
$ export EVMWRAP=../moeingevm/evmwrap/host_bridge/libevmwrap.so
$ ./smartbchd init mynode --chain-id 0x1
```

After successfully executing the above commands, you can find the initialized data in the `~/.smartbchd` directory. By using the `--home` option for `./smartbchd` command, you can specify another directory.



Step 5: start the node:

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

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": [
    "0x09f236e4067f5fca5872d0c09f92ce653377ae41",
    "0x0c60b56403637dc9059fff3603a58db3d5d76d38",
    "0x3e144eb45c5ff912b2b29b2823fa674c972e9ec0",
    "0x44f9ba3cfa79f1504f1c2d1eb0389fbb32e5a00c",
    "0xab5d62788e207646fa60eb3eebdc4358c7f5686c",
    "0xb53e0a1dcf2ad9fa6ec8da77121b1765e68e768f",
    "0xb9d95550558d2a163f77f5a523dfe605746cb95b",
    "0xc5787370b6188b2b6f947117bb2f68adf732b207",
    "0xeab1b601da26611d134299845035214a046508b8",
    "0xee5d82886766296640d8ca194e997341a0dedede"
  ]
}
```

You can find the documents for RPC [here](./json-rpc.md).



