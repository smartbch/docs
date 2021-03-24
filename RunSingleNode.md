# 单节点测试



第1步，创建目录smart_bch：

```bash
$ cd ~ # cd到任一目录即可
$ mkdir smart_bch
$ cd smart_bch
```



第2步，克隆moeingEVM，构建evmwrap动态链接库：

```bash
$ cd ~/smart_bch
$ git clone https://github.com/smartbch/moeingevm.git
$ cd moeingevm/evmwrap
$ make
```

上面的命令执行成功后，出现~/smart_bch/moeingevm/evmwrap/host_bridge/libevmwrap.so文件。



第3步，克隆smartBCH源代码，编译smartbchd可执行程序：

```bash
$ cd ~/smart_bch
$ git clone https://github.com/smartbch/smartbch.git
$ cd smartbch
$ go build github.com/smartbch/smartbch/cmd/smartbchd
```

上面的命令执行成功后，出现~/smart_bch/smartbch/smartbchd可执行程序。



第4步，初始化节点：

```bash
$ cd ~/smart_bch/smartbch
$ export EVMWRAP=../moeingevm/evmwrap/host_bridge/libevmwrap.so
$ ./smartbchd init mynode --chain-id 0x1
```

上面的命令执行成功后，会在~/.smartbchd目录（可以通过`--home`选项指定）下生成链的初始化数据。



第5步，启动节点：

```bash
$ ./smartbchd start
```

上面的命令运行成功后，节点启动，并在localhost:8584（可以通过`--http.addr`选项指定）提供JSON-RPC服务。节点默认解锁了10个账户，执行下面的命令可以看到这些账户的地址：

```bash
# 在另一个命令行窗口中执行
$ curl -X POST --data '{"jsonrpc":"2.0", "method":"eth_accounts", "params":[],"id":1}' \
    -H "Content-Type: application/json" http://localhost:8545 | jq
```

可以看到输出：

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

关于RPC的文档可以看[这里](./json-rpc.md)。

