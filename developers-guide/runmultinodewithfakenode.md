# Multi-Node TestNet With Fake BCH Mainnet Node

#### Dependencies

首先按照[多节点测试网](./runmultinode.md)步骤执行，注意启动步骤替换成下面的命令，其余保持一致。

```
./smartbchd start --mainnet-url=http://127.0.0.1:1234/
```



#### Fake Node 操作步骤

fake node模拟BCH主网行为，由smartBCH开发人员负责操作，步骤如下：

##### 启动

```
Git clone https://github.com/smartbch/testkit.git
cd bchnode
go run main.go &
```

##### 添加公钥和voting power信息

格式为：`pubkey`-`votingPower`-`action`，action分为add | edit | retire三种

```
cd scripts
./pubkey.sh eeed4fae3da010e393efed2aacd271971fd2383fc68109a475d6c9ef65435d52-9-add
```

添加公钥后fake node开始出块，出块间隔默认为3s。

##### 调整区块间隔

比如将区块间隔调整为10s

```
./interval.sh 10
```

##### 区块重组

```
./reorg.sh
```

主网会从8个区块前开始分叉，并形成新的最近8个区块的信息。



#### 测试步骤

1. 按照genesis.json文件中的voting power和pubkey配置fake node

2. 保持现有的validator之间的voting power比例三个epoch
3. 调整voting power比例，通过switch epoch切换主validator
4. fake node重组，smartBCH保持正常出块
5. 添加新的validator并通过fake node voting激活
6. 重启smartBCH节点可以正常同步区块



#### smartBCH epoch参数

```
NumBlocksInEpoch       int64 = 30
NumBlocksToClearMemory int64 = 1000s
WaitingBlockDelayTime  int64 = 2s
SwitchEpochDelayTime   int64 = 10s
MinVotingPercentPerEpoch        = 10 //10 percent in NumBlocksInEpoch, like 2016 / 10 = 201
MinVotingPubKeysPercentPerEpoch = 34 //34 percent in active validators,
```

