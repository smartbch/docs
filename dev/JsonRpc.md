## JSON-RPC smartBCH  

Here is a list of all the supported RPC endpoints of smartBCH, sorted by the prefixes. The endpoints with "sbch" prefix are smartBCH-specific, which are used by the [BasicBrowser](https://github.com/smartbch/BasicBrowser). The endpoints with "web3", "net" and "eth" prefixes have the same function as infura, except for some features which are described below.

### Web3

| JSON-RPC methods   | Doc (eth.wiki)                                   | Doc (infura.io/docs)                                        | Implemented? |
| ------------------ | ------------------------------------------------ | ----------------------------------------------------------- | ------------ |
| web3_clientVersion | https://eth.wiki/json-rpc/API#web3_clientVersion | https://infura.io/docs/ethereum/json-rpc/web3-clientVersion | ✅            |
| web3_sha3          | https://eth.wiki/json-rpc/API#web3_sha3          |                                                             | ✅            |

### Net

| JSON-RPC methods | Doc (eth.wiki)                              | Doc (infura.io/docs)                                   | Implemented? |
| ---------------- | ------------------------------------------- | ------------------------------------------------------ | ------------ |
| net_version      | https://eth.wiki/json-rpc/API#net_version   | https://infura.io/docs/ethereum/json-rpc/net-version   | ✅            |
| net_peerCount    | https://eth.wiki/json-rpc/API#net_peercount | https://infura.io/docs/ethereum/json-rpc/net-peerCount | ❌            |
| net_listening    | https://eth.wiki/json-rpc/API#net_listening | https://infura.io/docs/ethereum/json-rpc/net-listening | ❌            |

### ETH

⚠️the ['pending' block number parameter](https://eth.wiki/json-rpc/API#the-default-block-parameter) is not supported, because the mempool of smartbchd is invisable now.

The throughput of smartBCH is very high, and no transactions will be waiting in the mempool for a long time, so there is no need to check whether a transaction is accepted by mempool.

| JSON-RPC methods                        | Doc (eth.wiki)                                               | Doc (infura.io/docs)                                         | Implemented?    |
| --------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | --------------- |
| eth_protocolVersion                     | https://eth.wiki/json-rpc/API#eth_protocolversion            | https://infura.io/docs/ethereum/json-rpc/eth-protocolVersion | ✅               |
| eth_syncing                             | https://eth.wiki/json-rpc/API#eth_syncing                    | https://infura.io/docs/ethereum/json-rpc/eth-syncing         | ✅               |
| eth_coinbase                            | https://eth.wiki/json-rpc/API#eth_coinbase                   |                                                              | ✅ (returns 0)   |
| eth_mining                              | https://eth.wiki/json-rpc/API#eth_mining                     | https://infura.io/docs/ethereum/json-rpc/eth-mining          | ❌               |
| eth_hashrate                            | https://eth.wiki/json-rpc/API#eth_hashrate                   | https://infura.io/docs/ethereum/json-rpc/eth-hashrate        | ❌               |
| eth_gasPrice                            | https://eth.wiki/json-rpc/API#eth_gasprice                   | https://infura.io/docs/ethereum/json-rpc/eth-gasPrice        | ✅ (returns 0)   |
| eth_accounts                            | https://eth.wiki/json-rpc/API#eth_accounts                   | https://infura.io/docs/ethereum/json-rpc/eth-accounts        | ✅               |
| eth_blockNumber                         | https://eth.wiki/json-rpc/API#eth_blocknumber                | https://infura.io/docs/ethereum/json-rpc/eth-blockNumber     | ✅               |
| eth_getBalance                          | https://eth.wiki/json-rpc/API#eth_getbalance                 | https://infura.io/docs/ethereum/json-rpc/eth-getBalance      | ✅<br />❌pending |
| eth_getStorageAt                        | https://eth.wiki/json-rpc/API#eth_getstorageat               | https://infura.io/docs/ethereum/json-rpc/eth-getStorageAt    | ✅<br />❌pending |
| eth_getTransactionCount                 | https://eth.wiki/json-rpc/API#eth_gettransactioncount        | https://infura.io/docs/ethereum/json-rpc/eth-getTransactionCount | ✅<br />❌pending |
| eth_getBlockTransactionCountByHash      | https://eth.wiki/json-rpc/API#eth_getblocktransactioncountbyhash | https://infura.io/docs/ethereum/json-rpc/eth-getBlockTransactionCountByHash | ✅               |
| eth_getBlockTransactionCountByNumber    | https://eth.wiki/json-rpc/API#eth_getblocktransactioncountbynumber | https://infura.io/docs/ethereum/json-rpc/eth-getBlockTransactionCountByNumber | ✅<br />❌pending |
| eth_getUncleCountByBlockHash            | https://eth.wiki/json-rpc/API#eth_getunclecountbyblockhash   | https://infura.io/docs/ethereum/json-rpc/eth-getUncleCountByBlockHash | ❌               |
| eth_getUncleCountByBlockNumber          | https://eth.wiki/json-rpc/API#eth_getunclecountbyblocknumber | https://infura.io/docs/ethereum/json-rpc/eth-getUncleCountByBlockNumber | ❌               |
| eth_getCode                             | https://eth.wiki/json-rpc/API#eth_getcode                    | https://infura.io/docs/ethereum/json-rpc/eth-getCode         | ✅<br />❌pending |
| eth_sign                                | https://eth.wiki/json-rpc/API#eth_sign                       |                                                              | ❌               |
| eth_signTransaction                     | https://eth.wiki/json-rpc/API#eth_signtransaction            |                                                              | ❌               |
| eth_sendTransaction                     | https://eth.wiki/json-rpc/API#eth_sendtransaction            |                                                              | ✅               |
| eth_sendRawTransaction                  | https://eth.wiki/json-rpc/API#eth_sendrawtransaction         | https://infura.io/docs/ethereum/json-rpc/eth-sendRawTransaction | ✅               |
| eth_call                                | https://eth.wiki/json-rpc/API#eth_call                       | https://infura.io/docs/ethereum/json-rpc/eth-call            | ✅<br />❌pending |
| eth_estimateGas                         | https://eth.wiki/json-rpc/API#eth_estimategas                | https://infura.io/docs/ethereum/json-rpc/eth-estimateGas     | ✅               |
| eth_getBlockByHash                      | https://eth.wiki/json-rpc/API#eth_getblockbyhash             | https://infura.io/docs/ethereum/json-rpc/eth-getBlockByHash  | ✅               |
| eth_getBlockByNumber                    | https://eth.wiki/json-rpc/API#eth_getblockbynumber           | https://infura.io/docs/ethereum/json-rpc/eth-getBlockByNumber | ✅<br />❌pending |
| eth_getTransactionByHash                | https://eth.wiki/json-rpc/API#eth_gettransactionbyhash       | https://infura.io/docs/ethereum/json-rpc/eth-getTransactionByHash | ✅               |
| eth_getTransactionByBlockHashAndIndex   | https://eth.wiki/json-rpc/API#eth_gettransactionbyblockhashandindex | https://infura.io/docs/ethereum/json-rpc/eth-getTransactionByBlockHashAndIndex | ✅               |
| eth_getTransactionByBlockNumberAndIndex | https://eth.wiki/json-rpc/API#eth_gettransactionbyblocknumberandindex | https://infura.io/docs/ethereum/json-rpc/eth-getTransactionByBlockNumberAndIndex | ✅<br />❌pending |
| eth_getTransactionReceipt               | https://eth.wiki/json-rpc/API#eth_gettransactionreceipt      | https://infura.io/docs/ethereum/json-rpc/eth-getTransactionReceipt | ✅               |
| eth_getUncleByBlockHashAndIndex         | https://eth.wiki/json-rpc/API#eth_getunclebyblockhashandindex | https://infura.io/docs/ethereum/json-rpc/eth-getUncleByBlockHashAndIndex | ❌               |
| eth_getUncleByBlockNumberAndIndex       | https://eth.wiki/json-rpc/API#eth_getunclebyblocknumberandindex | https://infura.io/docs/ethereum/json-rpc/eth-getUncleByBlockNumberAndIndex | ❌               |
| eth_getCompiles                         | https://eth.wiki/json-rpc/API#eth_getcompilers               |                                                              | ❌               |
| eth_compileLLL                          | https://eth.wiki/json-rpc/API#eth_compilelll                 |                                                              | ❌               |
| eth_compileSolidity                     | https://eth.wiki/json-rpc/API#eth_compilesolidity            |                                                              | ❌               |
| eth_compileSerpent                      | https://eth.wiki/json-rpc/API#eth_compileserpent             |                                                              | ❌               |
| eth_newFilter                           | https://eth.wiki/json-rpc/API#eth_newfilter                  | https://infura.io/docs/ethereum/json-rpc/eth-newFilter       | ✅<br />❌pending |
| eth_newBlockFilter                      | https://eth.wiki/json-rpc/API#eth_newblockfilter             | https://infura.io/docs/ethereum/json-rpc/eth-newBlockFilter  | ✅               |
| eth_newPendingTransactionFilter         | https://eth.wiki/json-rpc/API#eth_newpendingtransactionfilter |                                                              | ✅               |
| eth_uninstallFilter                     | https://eth.wiki/json-rpc/API#eth_uninstallfilter            | https://infura.io/docs/ethereum/json-rpc/eth-uninstallFilter | ✅               |
| eth_getFilterChanges                    | https://eth.wiki/json-rpc/API#eth_getfilterchanges           | https://infura.io/docs/ethereum/json-rpc/eth-getFilterChanges | ✅               |
| eth_getFilterLogs                       | https://eth.wiki/json-rpc/API#eth_getfilterlogs              |                                                              | ✅               |
| eth_getLogs                             | https://eth.wiki/json-rpc/API#eth_getlogs                    | https://infura.io/docs/ethereum/json-rpc/eth-getLogs         | ✅<br />❌pending |
| eth_getWork                             | https://eth.wiki/json-rpc/API#eth_getwork                    | https://infura.io/docs/ethereum/json-rpc/eth-getWork         | ❌               |
| eth_submitWork                          | https://eth.wiki/json-rpc/API#eth_submitwork                 | https://infura.io/docs/ethereum/json-rpc/eth-submitWork      | ❌               |
| eth_submitHashrate                      | https://eth.wiki/json-rpc/API#eth_submithashrate             | https://infura.io/docs/ethereum/json-rpc/eth-hashrate        | ❌               |
| eth_chainId                             |                                                              | https://infura.io/docs/ethereum/json-rpc/eth-chainId         | ✅               |





## SBCH

| JSON-RPC methods                                 | Doc (eth.wiki) | Doc (infura.io/docs) | Implemented? |
| ------------------------------------------------ | -------------- | -------------------- | ------------ |
| [sbch_queryTxBySrc](#sbch_queryTxBySrc)          | N/A            | N/A                  | ✅            |
| [sbch_queryTxByDst](#sbch_queryTxByDst)          | N/A            | N/A                  | ✅            |
| [sbch_queryTxByAddr](#sbch_queryTxByAddr)        | N/A            | N/A                  | ✅            |
| [sbch_queryLogs](#sbch_queryLogs)                | N/A            | N/A                  | ✅            |
| [sbch_getTxListByHeight](sbch_getTxListByHeight) | N/A            | N/A                  | ✅            |



### sbch_queryTxBySrc

Returns the information about transactions requested by sender address and block range.

Parameters:

1. `DATA`, 20 Bytes - from address
2. `QUANTITY` - integer, start number
3. `QUANTITY` - integer, end number

Retrns:

`Array` - array of transaction objects, see [eth_getTransactionByHash](https://eth.wiki/json-rpc/API#eth_getTransactionByHash)



### sbch_queryTxByDst

Returns the information about transactions requested by recipient address and block range.

Parameters:

1. `DATA`, 20 Bytes - to address
2. `QUANTITY|TAG` - integer of start number, or string  `"latest"` for the last mined block
3. `QUANTITY|TAG` - integer of end number, or string  `"latest"` for the last mined block

Retrns:

`Array` - array of transaction objects, see [eth_getTransactionByHash](https://eth.wiki/json-rpc/API#eth_getTransactionByHash)



### sbch_queryTxByAddr

Returns the information about transactions requested by address (sender or recipient) and block range.

Parameters:

1. `DATA`, 20 Bytes - from or to address
2. `QUANTITY|TAG` - integer of start number, or string  `"latest"` for the last mined block
3. `QUANTITY|TAG` - integer of end number, or string  `"latest"` for the last mined block

Retrns:

`Array` - array of transaction objects, see [eth_getTransactionByHash](https://eth.wiki/json-rpc/API#eth_getTransactionByHash)



### sbch_queryLogs

Query logs by address, topics and block range. It is different from `eth_getLogs` in: 1) the contract address is required, not optional; 2) the topics are position-independent, which means as long as a log has the specified topics in any position, it will be included in the returned result.

Parameters:

1. `DATA`, 20 Bytes - contract address
2. `Array of DATA`, topics
3.  `QUANTITY|TAG` - integer of start number, or string  `"latest"` for the last mined block
4. `QUANTITY|TAG` - integer of end number, or string  `"latest"` for the last mined block

Returns:

`Array` - array of log objects, see [eth_getLogs](https://eth.wiki/json-rpc/API#eth_getLogs)



### sbch_getTxListByHeight

Get tx list by height.

Parameters:

1. `QUANTITY|TAG` - integer of start number, or string  `"latest"` for the last mined block

Returns:

`Array` - array of transaction objects, see [eth_getTransactionByHash](https://eth.wiki/json-rpc/API#eth_getTransactionByHash)

