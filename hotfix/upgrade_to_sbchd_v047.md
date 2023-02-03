# Upgrade smartbchd to 0.4.7

A vulnerability has been found and patched for smartbchd. More than 2/3 of the validators have been patched, so the chain and the assets are safe now.

If you are running nodes with smartbchd-v0.4.6p1, please upgrade them to v0.4.7 to keep the same consensus with most of the validators.

## docker-v047

```
# get the image
docker pull smartbch/smartbchd:v0.4.7

# check the version
docker run --rm smartbch/smartbchd:v0.4.7 version

# stop the old container
docker stop sbchd
docker container rm sbchd

# start a new one
sudo docker run \
  -v ~/.smartbchd:/root/.smartbchd \
  -p 0.0.0.0:8545:8545 \
  -p 0.0.0.0:8546:8546 \
  -p 0.0.0.0:26656:26656 \
  --ulimit nofile=65535:65535 \
  --log-opt max-size=200m \
  --name sbchd \
  -d smartbch/smartbchd:v0.4.7 start \
  --log_level='json-rpc:debug,watcher:debug,*:info' \
  --http.api='eth,web3,net,txpool,sbch,debug'
  
# check the logs
docker logs -f -n100 sbchd
```







## exe-2023.02.02

```
# aws上面6台机arm器升级步骤：

# 登录机器，找到smartbchd的PID和启动目录，并且确认smartbchd的home目录
ps aux | grep smartbchd
pwdx <SBCHD_PID>

# 下载smartbchd最新补丁版
cd <启动目录>
wget http://13.212.74.236:8080/sbchd_v046p2a_arm64
chmod +x sbchd_v046p2a_arm64
sha256sum sbchd_v046p2a_arm64 
# 应该输出：5c239b3d7eec5e8309aff13626cc1b91f52351f324ed090ed4f2db59fbe277a2

# 停止smartbchd进程
kill <SBCHD_PID>

# 重新启动
nohup ./sbchd_v046p2a_arm64 start \
  --home=path/to/.smartbchd \
  --log_level='*:info' \
  --http.api='eth,web3,net,txpool,sbch,debug' &

# amd版本下载这个：
wget http://13.212.74.236:8080/sbchd_v046p2a_amd64
chmod +x sbchd_v046p2a_amd64
sha256sum sbchd_v046p2a_amd64 
# 应该输出：27bc345798fcf00c6697371bb4c2b131c176a8620aa0b5f0592658cb2ea400b0
```



## non-docker-2023.02.01

```
# 按照下面这个文档准备smartbchd编译环境（执行完step1即可）：
# https://github.com/smartbch/docs/blob/main/developers-guide/build-smartbchd.md

# 准备smartbchd补丁版代码
cd ~
mkdir sbchd_v046p2
cd sbchd_v046p2

cd ~/sbchd_v046p2
git clone https://github.com/wangkui0508/moeingevm.git
cd moeingevm/evmwrap
make
export CGO_CFLAGS="-I$ROCKSDB_PATH/include"
export CGO_LDFLAGS="-L$ROCKSDB_PATH -L$HOME/sbchd_v046p2/moeingevm/evmwrap/host_bridge/ -l:librocksdb.a -lstdc++ -lm -lsnappy "

cd ~/sbchd_v046p2
git clone https://github.com/wangkui0508/uint256.git
git clone https://github.com/wangkui0508/smartbch.git
cd smartbch
go build -tags cppbtree github.com/smartbch/smartbch/cmd/smartbchd



```



## non-docker-2022.01.30

```
# 找到编译smartbchd的目录
cd smart_bch

# 确认moeingevm是最新版v0.4.3
cd moeingevm
git pull
git status
# 如果有必要，重新编译moeingevm
cd evmwrap
make clean
make

# 确认smartbch是最新版v0.4.6-p2
cd smartbch
git pull
git status

# 下载bugfix版moeingevm 
cd smart_bch
mkdir wk
cd wk
git clone https://github.com/wangkui0508/moeingevm.git

# hack smartbchd
cd smartbch
# 修改go.mod，添加：
replace github.com/smartbch/moeingevm => ../wk/moeingevm
# 修改app/version.go：
GitTag    = "v0.4.6-p2"
# 重新编译smartbchd
go build -tags cppbtree github.com/smartbch/smartbch/cmd/smartbchd
# 查看版本
./smartbchd version

# 停止smartbchd服务
sudo docker stop sbchd

# 重启smartbchd服务（命令仅供参考）
sudo nohup ./smartbchd start \
  --home=/mnt/nvme/.smartbchd \
  --mainnet-genesis-height=698502 \
  --log_level='*:info' \
  --http.api='eth,web3,net,txpool,sbch,debug' \
  --archive-mode=false > smart0130.log &
```



## ~~docker环境紧急升级步骤~~（有问题）

```
# 加载镜像（如果有必要，在docker命令前加上sudo）
wget http://13.212.74.236:8080/sbchd_v046p2.tar
docker load --input sbchd_v046p2.tar
docker run --rm smartbch/smartbchd:v0.4.6-p2 version

# 重新启动sbchd
sudo docker stop sbchd
sudo docker container rm sbchd
sudo docker run \
  -v ~/.smartbchd:/root/.smartbchd \
  -p 0.0.0.0:8545:8545 \
  -p 0.0.0.0:8546:8546 \
  -p 0.0.0.0:26656:26656 \
  --ulimit nofile=65535:65535 \
  --log-opt max-size=200m \
  --name sbchd \
  -d smartbch/smartbchd:v0.4.6-p2 start \
  --mainnet-genesis-height=698502 \
  --log_level='json-rpc:debug,watcher:debug,*:info' \
  --http.api='eth,web3,net,txpool,sbch,debug'
  
# 查看容器
docker ps
docker logs -f -n200 sbchd
```

