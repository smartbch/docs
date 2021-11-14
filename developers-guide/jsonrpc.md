# JSON-RPC



## JSON-RPC smartBCH

Here is a list of all the supported RPC endpoints of smartBCH, sorted by the prefixes. The endpoints with "sbch" prefix are smartBCH-specific, which are used by the [BasicBrowser](https://github.com/smartbch/BasicBrowser). The endpoints with "web3", "net" and "eth" prefixes have the same function as infura, except for some features which are described below.



### Web3

| JSON-RPC methods | Doc \(eth.wiki\) | Doc \(infura.io/docs\) | Implemented? |
| :--- | :--- | :--- | :--- |
| web3\_clientVersion | [https://eth.wiki/json-rpc/API\#web3\_clientVersion](https://eth.wiki/json-rpc/API#web3_clientVersion) | [https://infura.io/docs/ethereum/json-rpc/web3-clientVersion](https://infura.io/docs/ethereum/json-rpc/web3-clientVersion) | ✅ |
| web3\_sha3 | [https://eth.wiki/json-rpc/API\#web3\_sha3](https://eth.wiki/json-rpc/API#web3_sha3) |  | ✅ |



### Net

| JSON-RPC methods | Doc \(eth.wiki\) | Doc \(infura.io/docs\) | Implemented? |
| :--- | :--- | :--- | :--- |
| net\_version | [https://eth.wiki/json-rpc/API\#net\_version](https://eth.wiki/json-rpc/API#net_version) | [https://infura.io/docs/ethereum/json-rpc/net-version](https://infura.io/docs/ethereum/json-rpc/net-version) | ✅ |
| net\_peerCount | [https://eth.wiki/json-rpc/API\#net\_peercount](https://eth.wiki/json-rpc/API#net_peercount) | [https://infura.io/docs/ethereum/json-rpc/net-peerCount](https://infura.io/docs/ethereum/json-rpc/net-peerCount) | ❌ |
| net\_listening | [https://eth.wiki/json-rpc/API\#net\_listening](https://eth.wiki/json-rpc/API#net_listening) | [https://infura.io/docs/ethereum/json-rpc/net-listening](https://infura.io/docs/ethereum/json-rpc/net-listening) | ❌ |



### ETH

⚠️the ['pending' block number parameter](https://eth.wiki/json-rpc/API#the-default-block-parameter) is not supported, because the mempool of smartbchd is invisable now.

The throughput of smartBCH is very high, and no transactions will be waiting in the mempool for a long time, so there is no need to check whether a transaction is accepted by mempool.

| JSON-RPC methods | Doc \(eth.wiki\) | Doc \(infura.io/docs\) | Implemented? |
| :--- | :--- | :--- | :--- |
| eth\_protocolVersion | [https://eth.wiki/json-rpc/API\#eth\_protocolversion](https://eth.wiki/json-rpc/API#eth_protocolversion) | [https://infura.io/docs/ethereum/json-rpc/eth-protocolVersion](https://infura.io/docs/ethereum/json-rpc/eth-protocolVersion) | ✅ |
| eth\_syncing | [https://eth.wiki/json-rpc/API\#eth\_syncing](https://eth.wiki/json-rpc/API#eth_syncing) | [https://infura.io/docs/ethereum/json-rpc/eth-syncing](https://infura.io/docs/ethereum/json-rpc/eth-syncing) | ✅ |
| eth\_coinbase | [https://eth.wiki/json-rpc/API\#eth\_coinbase](https://eth.wiki/json-rpc/API#eth_coinbase) |  | ✅ \(returns 0\) |
| eth\_mining | [https://eth.wiki/json-rpc/API\#eth\_mining](https://eth.wiki/json-rpc/API#eth_mining) | [https://infura.io/docs/ethereum/json-rpc/eth-mining](https://infura.io/docs/ethereum/json-rpc/eth-mining) | ❌ |
| eth\_hashrate | [https://eth.wiki/json-rpc/API\#eth\_hashrate](https://eth.wiki/json-rpc/API#eth_hashrate) | [https://infura.io/docs/ethereum/json-rpc/eth-hashrate](https://infura.io/docs/ethereum/json-rpc/eth-hashrate) | ❌ |
| eth\_gasPrice | [https://eth.wiki/json-rpc/API\#eth\_gasprice](https://eth.wiki/json-rpc/API#eth_gasprice) | [https://infura.io/docs/ethereum/json-rpc/eth-gasPrice](https://infura.io/docs/ethereum/json-rpc/eth-gasPrice) | ✅ \(returns 0\) |
| eth\_accounts | [https://eth.wiki/json-rpc/API\#eth\_accounts](https://eth.wiki/json-rpc/API#eth_accounts) | [https://infura.io/docs/ethereum/json-rpc/eth-accounts](https://infura.io/docs/ethereum/json-rpc/eth-accounts) | ✅ |
| eth\_blockNumber | [https://eth.wiki/json-rpc/API\#eth\_blocknumber](https://eth.wiki/json-rpc/API#eth_blocknumber) | [https://infura.io/docs/ethereum/json-rpc/eth-blockNumber](https://infura.io/docs/ethereum/json-rpc/eth-blockNumber) | ✅ |
| eth\_getBalance | [https://eth.wiki/json-rpc/API\#eth\_getbalance](https://eth.wiki/json-rpc/API#eth_getbalance) | [https://infura.io/docs/ethereum/json-rpc/eth-getBalance](https://infura.io/docs/ethereum/json-rpc/eth-getBalance) | ✅ ❌pending |
| eth\_getStorageAt | [https://eth.wiki/json-rpc/API\#eth\_getstorageat](https://eth.wiki/json-rpc/API#eth_getstorageat) | [https://infura.io/docs/ethereum/json-rpc/eth-getStorageAt](https://infura.io/docs/ethereum/json-rpc/eth-getStorageAt) | ✅ ❌pending |
| eth\_getTransactionCount | [https://eth.wiki/json-rpc/API\#eth\_gettransactioncount](https://eth.wiki/json-rpc/API#eth_gettransactioncount) | [https://infura.io/docs/ethereum/json-rpc/eth-getTransactionCount](https://infura.io/docs/ethereum/json-rpc/eth-getTransactionCount) | ✅ ❌pending |
| eth\_getBlockTransactionCountByHash | [https://eth.wiki/json-rpc/API\#eth\_getblocktransactioncountbyhash](https://eth.wiki/json-rpc/API#eth_getblocktransactioncountbyhash) | [https://infura.io/docs/ethereum/json-rpc/eth-getBlockTransactionCountByHash](https://infura.io/docs/ethereum/json-rpc/eth-getBlockTransactionCountByHash) | ✅ |
| eth\_getBlockTransactionCountByNumber | [https://eth.wiki/json-rpc/API\#eth\_getblocktransactioncountbynumber](https://eth.wiki/json-rpc/API#eth_getblocktransactioncountbynumber) | [https://infura.io/docs/ethereum/json-rpc/eth-getBlockTransactionCountByNumber](https://infura.io/docs/ethereum/json-rpc/eth-getBlockTransactionCountByNumber) | ✅ ❌pending |
| eth\_getUncleCountByBlockHash | [https://eth.wiki/json-rpc/API\#eth\_getunclecountbyblockhash](https://eth.wiki/json-rpc/API#eth_getunclecountbyblockhash) | [https://infura.io/docs/ethereum/json-rpc/eth-getUncleCountByBlockHash](https://infura.io/docs/ethereum/json-rpc/eth-getUncleCountByBlockHash) | ❌ |
| eth\_getUncleCountByBlockNumber | [https://eth.wiki/json-rpc/API\#eth\_getunclecountbyblocknumber](https://eth.wiki/json-rpc/API#eth_getunclecountbyblocknumber) | [https://infura.io/docs/ethereum/json-rpc/eth-getUncleCountByBlockNumber](https://infura.io/docs/ethereum/json-rpc/eth-getUncleCountByBlockNumber) | ❌ |
| eth\_getCode | [https://eth.wiki/json-rpc/API\#eth\_getcode](https://eth.wiki/json-rpc/API#eth_getcode) | [https://infura.io/docs/ethereum/json-rpc/eth-getCode](https://infura.io/docs/ethereum/json-rpc/eth-getCode) | ✅ ❌pending |
| eth\_sign | [https://eth.wiki/json-rpc/API\#eth\_sign](https://eth.wiki/json-rpc/API#eth_sign) |  | ❌ |
| eth\_signTransaction | [https://eth.wiki/json-rpc/API\#eth\_signtransaction](https://eth.wiki/json-rpc/API#eth_signtransaction) |  | ❌ |
| eth\_sendTransaction | [https://eth.wiki/json-rpc/API\#eth\_sendtransaction](https://eth.wiki/json-rpc/API#eth_sendtransaction) |  | ✅ |
| eth\_sendRawTransaction | [https://eth.wiki/json-rpc/API\#eth\_sendrawtransaction](https://eth.wiki/json-rpc/API#eth_sendrawtransaction) | [https://infura.io/docs/ethereum/json-rpc/eth-sendRawTransaction](https://infura.io/docs/ethereum/json-rpc/eth-sendRawTransaction) | ✅ |
| eth\_call | [https://eth.wiki/json-rpc/API\#eth\_call](https://eth.wiki/json-rpc/API#eth_call) | [https://infura.io/docs/ethereum/json-rpc/eth-call](https://infura.io/docs/ethereum/json-rpc/eth-call) | ✅ ❌pending |
| eth\_estimateGas | [https://eth.wiki/json-rpc/API\#eth\_estimategas](https://eth.wiki/json-rpc/API#eth_estimategas) | [https://infura.io/docs/ethereum/json-rpc/eth-estimateGas](https://infura.io/docs/ethereum/json-rpc/eth-estimateGas) | ✅ |
| eth\_getBlockByHash | [https://eth.wiki/json-rpc/API\#eth\_getblockbyhash](https://eth.wiki/json-rpc/API#eth_getblockbyhash) | [https://infura.io/docs/ethereum/json-rpc/eth-getBlockByHash](https://infura.io/docs/ethereum/json-rpc/eth-getBlockByHash) | ✅ |
| eth\_getBlockByNumber | [https://eth.wiki/json-rpc/API\#eth\_getblockbynumber](https://eth.wiki/json-rpc/API#eth_getblockbynumber) | [https://infura.io/docs/ethereum/json-rpc/eth-getBlockByNumber](https://infura.io/docs/ethereum/json-rpc/eth-getBlockByNumber) | ✅ ❌pending |
| eth\_getTransactionByHash | [https://eth.wiki/json-rpc/API\#eth\_gettransactionbyhash](https://eth.wiki/json-rpc/API#eth_gettransactionbyhash) | [https://infura.io/docs/ethereum/json-rpc/eth-getTransactionByHash](https://infura.io/docs/ethereum/json-rpc/eth-getTransactionByHash) | ✅ |
| eth\_getTransactionByBlockHashAndIndex | [https://eth.wiki/json-rpc/API\#eth\_gettransactionbyblockhashandindex](https://eth.wiki/json-rpc/API#eth_gettransactionbyblockhashandindex) | [https://infura.io/docs/ethereum/json-rpc/eth-getTransactionByBlockHashAndIndex](https://infura.io/docs/ethereum/json-rpc/eth-getTransactionByBlockHashAndIndex) | ✅ |
| eth\_getTransactionByBlockNumberAndIndex | [https://eth.wiki/json-rpc/API\#eth\_gettransactionbyblocknumberandindex](https://eth.wiki/json-rpc/API#eth_gettransactionbyblocknumberandindex) | [https://infura.io/docs/ethereum/json-rpc/eth-getTransactionByBlockNumberAndIndex](https://infura.io/docs/ethereum/json-rpc/eth-getTransactionByBlockNumberAndIndex) | ✅ ❌pending |
| eth\_getTransactionReceipt | [https://eth.wiki/json-rpc/API\#eth\_gettransactionreceipt](https://eth.wiki/json-rpc/API#eth_gettransactionreceipt) | [https://infura.io/docs/ethereum/json-rpc/eth-getTransactionReceipt](https://infura.io/docs/ethereum/json-rpc/eth-getTransactionReceipt) | ✅ |
| eth\_getUncleByBlockHashAndIndex | [https://eth.wiki/json-rpc/API\#eth\_getunclebyblockhashandindex](https://eth.wiki/json-rpc/API#eth_getunclebyblockhashandindex) | [https://infura.io/docs/ethereum/json-rpc/eth-getUncleByBlockHashAndIndex](https://infura.io/docs/ethereum/json-rpc/eth-getUncleByBlockHashAndIndex) | ❌ |
| eth\_getUncleByBlockNumberAndIndex | [https://eth.wiki/json-rpc/API\#eth\_getunclebyblocknumberandindex](https://eth.wiki/json-rpc/API#eth_getunclebyblocknumberandindex) | [https://infura.io/docs/ethereum/json-rpc/eth-getUncleByBlockNumberAndIndex](https://infura.io/docs/ethereum/json-rpc/eth-getUncleByBlockNumberAndIndex) | ❌ |
| eth\_getCompiles | [https://eth.wiki/json-rpc/API\#eth\_getcompilers](https://eth.wiki/json-rpc/API#eth_getcompilers) |  | ❌ |
| eth\_compileLLL | [https://eth.wiki/json-rpc/API\#eth\_compilelll](https://eth.wiki/json-rpc/API#eth_compilelll) |  | ❌ |
| eth\_compileSolidity | [https://eth.wiki/json-rpc/API\#eth\_compilesolidity](https://eth.wiki/json-rpc/API#eth_compilesolidity) |  | ❌ |
| eth\_compileSerpent | [https://eth.wiki/json-rpc/API\#eth\_compileserpent](https://eth.wiki/json-rpc/API#eth_compileserpent) |  | ❌ |
| eth\_newFilter | [https://eth.wiki/json-rpc/API\#eth\_newfilter](https://eth.wiki/json-rpc/API#eth_newfilter) | [https://infura.io/docs/ethereum/json-rpc/eth-newFilter](https://infura.io/docs/ethereum/json-rpc/eth-newFilter) | ✅ ❌pending |
| eth\_newBlockFilter | [https://eth.wiki/json-rpc/API\#eth\_newblockfilter](https://eth.wiki/json-rpc/API#eth_newblockfilter) | [https://infura.io/docs/ethereum/json-rpc/eth-newBlockFilter](https://infura.io/docs/ethereum/json-rpc/eth-newBlockFilter) | ✅ |
| eth\_newPendingTransactionFilter | [https://eth.wiki/json-rpc/API\#eth\_newpendingtransactionfilter](https://eth.wiki/json-rpc/API#eth_newpendingtransactionfilter) |  | ✅ |
| eth\_uninstallFilter | [https://eth.wiki/json-rpc/API\#eth\_uninstallfilter](https://eth.wiki/json-rpc/API#eth_uninstallfilter) | [https://infura.io/docs/ethereum/json-rpc/eth-uninstallFilter](https://infura.io/docs/ethereum/json-rpc/eth-uninstallFilter) | ✅ |
| eth\_getFilterChanges | [https://eth.wiki/json-rpc/API\#eth\_getfilterchanges](https://eth.wiki/json-rpc/API#eth_getfilterchanges) | [https://infura.io/docs/ethereum/json-rpc/eth-getFilterChanges](https://infura.io/docs/ethereum/json-rpc/eth-getFilterChanges) | ✅ |
| eth\_getFilterLogs | [https://eth.wiki/json-rpc/API\#eth\_getfilterlogs](https://eth.wiki/json-rpc/API#eth_getfilterlogs) |  | ✅ |
| eth\_getLogs | [https://eth.wiki/json-rpc/API\#eth\_getlogs](https://eth.wiki/json-rpc/API#eth_getlogs) | [https://infura.io/docs/ethereum/json-rpc/eth-getLogs](https://infura.io/docs/ethereum/json-rpc/eth-getLogs) | ✅ ❌pending |
| eth\_getWork | [https://eth.wiki/json-rpc/API\#eth\_getwork](https://eth.wiki/json-rpc/API#eth_getwork) | [https://infura.io/docs/ethereum/json-rpc/eth-getWork](https://infura.io/docs/ethereum/json-rpc/eth-getWork) | ❌ |
| eth\_submitWork | [https://eth.wiki/json-rpc/API\#eth\_submitwork](https://eth.wiki/json-rpc/API#eth_submitwork) | [https://infura.io/docs/ethereum/json-rpc/eth-submitWork](https://infura.io/docs/ethereum/json-rpc/eth-submitWork) | ❌ |
| eth\_submitHashrate | [https://eth.wiki/json-rpc/API\#eth\_submithashrate](https://eth.wiki/json-rpc/API#eth_submithashrate) | [https://infura.io/docs/ethereum/json-rpc/eth-hashrate](https://infura.io/docs/ethereum/json-rpc/eth-hashrate) | ❌ |
| eth\_chainId |  | [https://infura.io/docs/ethereum/json-rpc/eth-chainId](https://infura.io/docs/ethereum/json-rpc/eth-chainId) | ✅ |



### Txpool (non-standard)

| JSON-RPC methods | Doc                                                         | Implemented?           |
| :--------------- | :---------------------------------------------------------- | :--------------------- |
| txpool_content   | https://geth.ethereum.org/docs/rpc/ns-txpool#txpool_content | ✅ (returns empty data) |
| txpool_status    | https://geth.ethereum.org/docs/rpc/ns-txpool#txpool_status  | ✅ (returns empty data) |
| txpool_inspect   | https://geth.ethereum.org/docs/rpc/ns-txpool#txpool_inspect | ✅ (returns empty data) |



## TM

| JSON-RPC methods | Doc \(eth.wiki\) | Doc \(infura.io/docs\) | Implemented? |
| ---------------- | ---------------- | ---------------------- | ------------ |
| tm\_nodeInfo     | N/A              | N/A                    | ✅            |
|                  |                  |                        |              |

### tm_nodeInfo

Returns the information about Tendermint node.

Parameters: No

Retrns: 

`Object`



## SBCH

| JSON-RPC methods | Doc \(eth.wiki\) | Doc \(infura.io/docs\) | Since  |
| :--- | :--- | :--- | :--- |
| [sbch\_queryTxBySrc](jsonrpc.md#sbch_queryTxBySrc) | N/A | N/A | v0.1.0 |
| [sbch\_queryTxByDst](jsonrpc.md#sbch_queryTxByDst) | N/A | N/A | v0.1.0 |
| [sbch\_queryTxByAddr](jsonrpc.md#sbch_queryTxByAddr) | N/A | N/A | v0.1.0 |
| [sbch\_queryLogs](jsonrpc.md#sbch_queryLogs) | N/A | N/A | v0.1.0 |
| [sbch\_getTxListByHeight](jsonrpc.md#sbch_getTxListByHeight) | N/A | N/A | v0.1.0 |
| [sbch\_getTxListByHeightWithRange](jsonrpc.md#sbch_getTxListByHeightWithRange) | N/A | N/A | v0.1.0 |
| [sbch\_getAddressCount](jsonrpc.md#sbch_getAddressCount) | N/A | N/A | v0.1.0 |
| [sbch\_getSep20AddressCount](jsonrpc.md#sbch_getSep20AddressCount) | N/A | N/A | v0.2.0 |
| [sbch_getTransactionReceipt](jsonrpc.md#sbch_getTransactionReceipt) | N/A | N/A | v0.4.0 |
|  |  |  |  |



### sbch\_queryTxBySrc

Returns the information about transactions requested by sender address and block range.

Parameters:

1. `DATA`, 20 Bytes - from address
2. `QUANTITY` - integer, start number
3. `QUANTITY` - integer, end number
4. `QUANTITY` - integer, the maximal number of txs to return, `0` stands for default limit

Note: the start number can be greater than the end number, if so, the results will be sorted by block height in descending order.

Retrns:

`Array` - array of transaction objects, see [eth\_getTransactionByHash](https://eth.wiki/json-rpc/API#eth_getTransactionByHash)



### sbch\_queryTxByDst

Returns the information about transactions requested by recipient address and block range.

Parameters:

1. `DATA`, 20 Bytes - to address
2. `QUANTITY|TAG` - integer of start number, or string  `"latest"` for the last mined block
3. `QUANTITY|TAG` - integer of end number, or string  `"latest"` for the last mined block
4. `QUANTITY` - integer, the maximal number of txs to return, `0` stands for default limit

Note: the start number can be greater than the end number, if so, the results will be sorted by block height in descending order.

Retrns:

`Array` - array of transaction objects, see [eth\_getTransactionByHash](https://eth.wiki/json-rpc/API#eth_getTransactionByHash)



### sbch\_queryTxByAddr

Returns the information about transactions requested by address \(sender or recipient\) and block range.

Parameters:

1. `DATA`, 20 Bytes - from or to address
2. `QUANTITY|TAG` - integer of start number, or string  `"latest"` for the last mined block
3. `QUANTITY|TAG` - integer of end number, or string  `"latest"` for the last mined block
4. `QUANTITY` - integer, the maximal number of txs to return, `0` stands for default limit

Note: the start number can be greater than the end number, if so, the results will be sorted by block height in descending order.

Retrns:

`Array` - array of transaction objects, see [eth\_getTransactionByHash](https://eth.wiki/json-rpc/API#eth_getTransactionByHash)



### sbch\_queryLogs

Query logs by address, topics and block range. It is different from `eth_getLogs` in: 

1. the contract address is required, not optional; 
2. the topics are position-independent, which means as long as a log has the specified topics in any position, it will be included in the returned result.

Parameters:

1. `DATA`, 20 Bytes - contract address
2. `Array of DATA`, topics
3. `QUANTITY|TAG` - integer of start number, or string  `"latest"` for the last mined block
4. `QUANTITY|TAG` - integer of end number, or string  `"latest"` for the last mined block
5. `QUANTITY` - integer, the maximal number of txs to return, `0` stands for default limit.

Note: the start number can be greater than the end number, if so, the results will be sorted by block height in descending order.

Returns:

`Array` - array of log objects, see [eth\_getLogs](https://eth.wiki/json-rpc/API#eth_getLogs)



### sbch\_getTxListByHeight

Get tx list by height.

Parameters:

1. `QUANTITY|TAG` - integer of start number, or string  `"latest"` for the last mined block

Returns:

`Array` - array of transaction objects, see [eth_getTransactionReceipt](https://eth.wiki/json-rpc/API#eth_getTransactionReceipt)



### sbch\_getTxListByHeightWithRange

Get tx list by height and tx index range.

Parameters:

1. `QUANTITY|TAG` - integer of start number, or string  `"latest"` for the last mined block
2. `QUANTITY` - integer of start tx index
3. `QUANTITY` - integer of end tx index, or "0x0" which stands for "the largest tx index"

Returns:

`Array` - array of transaction objects, see [eth_getTransactionReceipt](https://eth.wiki/json-rpc/API#eth_getTransactionReceipt)



### sbch_getAddressCount

Returns the times addr acts as a to-address or from-address of a transaction.

Parameters:

1. `String`, kind of the query, could be `"from"`, `"to"`, or `"both"`
2. `DATA`, 20 Bytes - EOA or contract address

Returns:

`QUANTITY` - integer of count



### sbch_getSep20AddressCount

Returns the times addr acts as a to-address or from-address of a SEP20 Transfer event at some contract.

Parameters:

1. `String`, kind of the query, could be `"from"`, `"to"`, or `"both"`
2. `DATA`, 20 Bytes - SEP20 contract address
3. `DATA`, 20 Bytes - EOA or contract address

Returns:

`QUANTITY` - integer of count



### sbch_getTransactionReceipt

Enhanced version of [eth_getTransactionReceipt](https://eth.wiki/json-rpc/API#eth_getTransactionReceipt), the returned array of objects contain additional information about internal transactions.

Parameters: same as [eth_getTransactionReceipt](https://eth.wiki/json-rpc/API#eth_getTransactionReceipt)

Returns: array of objects sepcified by [eth_getTransactionReceipt](https://eth.wiki/json-rpc/API#eth_getTransactionReceipt) plus one more field of type Array: `internalTransactions`. 

Each object in internalTransactions array contains the following fields:

* `callPath`: `string` - a string representation of call type, depth and index of internal transaction (e.g. staticcall_0_1_1).
* `from`: `DATA`, 20 Bytes - address of the sender.
* `to`: `DATA`, 20 Bytes - address of the receiver.
* `gas`: `QUANTITY` - gas provided by the sender.
* `value`: `QUANTITY` - value transferred in Wei.
* `input`: `DATA` - the data send along with the internal transaction.
* `status`: `QUANTITY` - either `1` (success) or `0` (failure).
* `gasUsed`: `QUANTITY` - the amount of gas used by this internal transaction.
* `output`: `DATA` - the data returned by the internal transaction.
* `contractAddress`:  `DATA`, 20 Bytes - The contract address created, if the transaction was a contract creation, otherwise `null`.

