## SHA-Gate Specification

SHA-Gate (Smart-Holder-Authorized-Gate) is a new bridging scheme that help users transfer their BCH between the Bitcoin Cash main chain and the smartBCH side chain. It also helps synchronizing the "to-be-burnt" BCH held in the side chain's blackhole address to the burning address on the main chain.

### Overview

SHA-Gate works by creating, coverting and redeeming cc-UTXOs (chain-crossing UTXOs). A cc-UTXO is a cashscript covenant which can be spent by operators and monitors, which are elected periodically.

You can transfer BCH from the main chain to smartBCH side chain by creating a cc-UTXO, and transfer BCH from the smartBCH side chain to the main chain by redeeming a cc-UTXO. When the operators and monitors change after election, the existing cc-UTXOs must be converted to new ones that are controlled by the new operators and monitors.

After its creation, a cc-UTXO must be converted or redeemed as a whole. It cannot be split into smaller ones.

### Terminology

**The operators**. Each operator keeps a secp256k1 private key. By using their keys to sign transactions, they can spend cc-UTXOs together, converting or redeeming them.

**The monitors**. The monitors' tasks include: 1) When they find risks or possible bugs, they can stop the operators and stop the SHA-Gate logic in smartbchd; 2) Monitors can send transactions to synchronize the smartbchd nodes in processing the new BCH blocks which possibly contain chain-crossing tranfer transactions; 3) when the majority of the operators are unavailable, monitors can use their private keys to move the cc-UTXOs to a new operator set. A monitor controls a side chain account for task 1) and 2), and a main chain account for task 3).

**The collectors**. They collect signatures from the operators, assemble them into transactions, and broadcast the transactions on the BCH main chain. Collectors are permissionless and anyone can run. Usually volunteers run the collectors.

**The covenants**. A covenant is a script segment which controls who and how can spend a UTXO. The hash160 of the covenant is the UTXO's P2SH address, also know as the covenant's address. Usually this segment contains two parts: constructor arguments (some PUSH opcodes) and bytecodes compiled from the covenant's functions. The cc-UTXO's covenant constructor arguments are used to encode information about monitors and operators. So when monitors and operators change, the cc-UTXO's covenant address changes too. The current (last) covenant address reflects the latest (last) election's result, respectively.

**The chain-crossing contract**. A smart contract with address 0x2714, which is implemented using golang in smartbchd. It maintains the cc-UTXO set and help users redeem them. 

**The blackhole account**. A special account with address 0x0000000000000000000000626c61636b686f6c65 (ascii of "blackhole"). All the burnt gas fee on the side chain will be sent to this account. On the main chain, the same amount of BCH equaling to this blackhole's balance will be: 1) transfered to the burning address "1SmartBCHBurnAddressxxxxxxy31qJGb" or 2) paid to the miners for converting cc-UTXOs to a new covenant address. 

**The epoch**. One epoch is 2016 Bitcoin Cash blocks. Sha-gate uses it as a time unit.

### The details of cc-UTXO

Chain-crossing UTXOs use a special kind of covenants. The internal logic is: 1) when 7-of-10 operators agree, a UTXO can be transferred to a P2PKH address, or a new covenant address, or the burning address; 2) if a cc-UTXO has not been moved for a long time, then the monitors can transfer it to a new covenant address. The smartbchd nodes will analyze the transactions on BCH main chain to trace the cc-UTXOs' creation, redemption (transferred to a P2PKH address), and coversion (to a new covenant address).

##### Create a cc-UTXO

The value of cc-UTXOs has a upper bound Smax and a lower bound Smin. If the amount transferred to smartBCH is larger than Smax, the receiver on smartBCH will not get this amount. Instead, this cc-UTXO will be marked as "LostAndFound". A LostAndFound cc-UTXO can only be redeemed by this receiver by calling the chain-crossing contract with zero BCH. The LostAndFound machanism is to warn the receiver: please never do this again.

Now let's consider the situation where the amount is smaller that Smin:

1. If the amount is also smaller than `balance_of_blackhole_account - balance_of_mainchain_burning_address - 10`, then the receiver can get this amount on smartBCH and this cc-UTXO will be sent to the burning address "1SmartBCHBurnAddressxxxxxxy31qJGb" by the operators; we call such scenarios as "transfering small amounts through burning".

2. or else the receiver gets nothing and this cc-UTXO will be marked as "LostAndFound" (just like the situation where the amout is larger than Smax).

When Alice transfer some BCH from main chain to side chain, she puts the coins in a cc-UTXO, and uses an OP_RETURN output to attach a sidechain address. The hex address following OP_RETURN can be 40 bytes long (without the 0x prefix) or 42 bytes long (with the 0x prefix). If there are multiple OP_RETURN outputs in the transaction, only the first one containing a hex address will be used.

If no sidechain address is attached, smartbchd examines the inputs one by one. When it finds the one which spends a P2PKH output, it uses the pubkey in its scriptSig to derive a sidechain address. If no P2PKH input can be found, then this tranfer fails and the coins are lost forever.

Alice should use the current covenant address as the cc-UTXO's P2SH address. If she incorrectly uses the last covenant address, the cc-UTXO will be marked as "LostAndFound".

Monitors can mark some main chain blocks as end-of-rescan blocks. The election, i.e., counting of votes for operators/monitors, happens at some of these end-of-rescan blocks. Conceptually, the changing of the covenant address happens at an end-of-rescan block. After this block, Alice should use the new covenant address, because the quorem of operators/monitors changes.

When transferring coins from the main chain to the sidechain, the sender will pay for the miner fee. The BCH amount Alice gets on the side chain equals the value of the created cc-UTXO.

##### Redeem a cc-UTXO

When transferring coins from the side chain to the main chain, Alice must redeem one or more cc-UTXOs in whole. Operators never divide or merge cc-UTXOs. Alice specifies her P2PKH address on the side chain and pays enough coins to the chain-crossing contract to redeem a cc-UTXO. The chain-crossing contract will generate an unsigned transaction which needs to be signed by the operators. This transaction will be published through a RPC endpoint, such that the monitors can see it and check it. After a publicity period, the operators can get this transaction through another RPC endpoint and sign it, such that collectors can fetch the operators' signatures and assemble a transaction. If the monitors want to stop operators, they must stop the SHA-Gate logic through the chain-crossing contract during the publicity period, thus the operators will not get this transaction to sign.

When transferring coins from the sidechain to the main chain, the miner fee will be deducted from the cc-UTXO. The redeeming transaction has exactly one input and one output. The BCH amount Alice gets on the main chain is less than the amount she paid on the side chain, and the difference is the miner fee.

##### Covert a cc-UTXO

When the operators/monitors set is changed after an election, the old operators must covert the cc-UTXOs to a new covenant address which can be controlled by the new operators/monitors set. Even if the operator set keeps unchanged for a long time, operators will also move and recreate the cc-UTXO every 12 epochs. This will prevent the monitors from moving the cc-UTXOs. 

Please note monitors can only move the cc-UTXOs when they are old enough, which means most of the operators have been unavailable for 16 epochs. When we must rely on the monitors to move cc-UTXOs, smartbchd must be hard forked to handle such a restoration after a disaster.

When coverting cc-UTXOs, the miner fees are paid using the balance of the blackhole account. That means, some of the BCH burnt on smartBCH will not be synchronized to the main chain burning address. Instead, they are used to pay the miner fee of coverting cc-UTXOs. Anyone can sent BCH to the blackhole account as a donation for miner fees.

Before transferring the cc-UTXOs to a different operator set, a publicity period is also needed, during which the monitors check the transactions and can stop the SHA-Gate logic if there is a bug or risk. 

You cannot redeem a cc-UTXO controlled by the old covenant address. You must wait until it is coverted to the new covenant address.

After a end-of-rescan block which changes the quorem of operators/monitors, if Alice accidently transfer coins to the old covenant address, then her cc-UTXO will be marked as LostAndFound. In the UI of an App or a web page which helps chain-crossing, Alice will be warned that the couting of votes is going to happen and she'd better delay the transfer.

### The details of the chain-crossing contract

The chain-crossing contract has the following external functions:

```solidity
    function startRescan(uint256 endOfRescanBlockHeight) external;
    function handleUTXOs() external;
    function pause() external;
    function resume() external;
    function redeem(uint256 txid, uint256 index, address targetAddress) external payable;
```

**startRescan**. This function requests all the smartbchd nodes to rescan the latest main chain blocks.

This function can only be called by a monitor. Why? The block interval of Bitcoin Cash is ten minutes averagely, but it varies a lot from block to block. A block may be orphaned and it only gets finalized after ten confirmations. Considering these issues, it isn't always easy to make all the smartbchd nodes come to consensus in synchronization about which BCH block is the latest finalized one. An evil attacker may secretly mine a fork and broadcast it at a subtle timing to make the smartbchd nodes see different forks.

So we rely on the monitors to specify the latest finalized BCH block's height, at a proper moment. All the smartbchd nodes will collect cross-chain transactions from the last processed height to `mainFinalizedBlockHeight`, and then these transactions are cached.

If there is an election to be finished, the couting of votes is carried out at the beginning of startRescan. But the election result does not have effect to the scanned cross-chain transactions, because they happend before this end-of-rescan block. Instead it will have effect to the future cross-chain transactions.

**handleUTXOs**. Twenty minutes after the monitor specify the latest finalized height, anyone can call this function to trigger the smartbchd nodes to process the cached cross-chain transactions. New cc-UTXOs are recorded in smartbchd nodes' internal storage. The cc-UTXOs which were marked as "to be deleted" will be deleted when smartbchd finds them were spent on the main chain.

The transactions for coverting cc-UTXOs are also considered as special chain-crossing transactions and will be processed by handleUTXOs.

**pause**. A monitor can call this function to stop smartbch'd chain-crossing logic and to prevent the operators from signing transactions. Monitors will check the events and status of smartbchd nodes to ensure things are going fine without bugs or risks.

**resume**. A monitor can call this funtion to cancel its pause command. Each monitor places and cancels its pause command independently. If there is at least one monitor places a pause command, then sha-gate is paused.

**redeem**. This is a payable function. When call it with zero value, you can redeem a cc-UTXO which is marked as LostAndFound, if you are its receiver. When call it with a non-zero value that equals the amount of the specified normal cc-UTXO, you can redeem this cc-UTXO. The `txid` and `index` arguments specify the cc-UTXO you want to redeem. A cc-UTXO can be redeemed only if it has been recognized in handleUTXO for more than 24 hours.

The operators will send this cc-UTXO to a main chain address specified by `targetAddress`, after you successfully redeem it on the side chain.

When a cc-UTXO is redeemed by Alice, its record is not immediately deleted from smartbchd nodes' storage, instead, it is just marked as "to be deleted". Some time after that, when this cc-UTXO is transferred to `targetAddress`, its record will be deteted on smartBCH.

The chain-crossing contract has the following events:

```solidity
    event NewRedeemable(uint256 indexed txid, uint32 indexed vout, address indexed covenantAddr);
    event NewLostAndFound(uint256 indexed txid, uint32 indexed vout, address indexed covenantAddr);
    event Redeem(uint256 indexed txid, uint32 indexed vout, address indexed covenantAddr, uint8 sourceType);
    event ChangeAddr(address indexed oldCovenantAddr, address indexed newCovenantAddr);
    event Convert(uint256 indexed prevTxid, uint32 indexed prevVout, address indexed oldCovenantAddr, uint256 txid, uint32 vout, address newCovenantAddr);
    event Deleted(uint256 indexed txid, uint32 indexed vout, address indexed covenantAddr, uint8 sourceType);
```

**NewRedeemable**. During the execution of handleUTXOs, this event denotes that a newly-created normal cc-UTXO is discovered.

**NewLostAndFound**.  During the execution of handleUTXOs, this event is emitted when:

1. The value of cc-UTXO is too large.

2. The value of cc-UTXO is too small and it does not meet the requirement of "transfering small amounts through burning".

3. The P2SH address is the last covenant address, instead of the current covenant address.

**Redeem**. This event can be emitted by the handleUTXO function or the redeem function. During the execution of handleUTXOs, this event is emitted when it is "transfering small amounts through burning" (sourceType=9). During the exectuion of redeem, this event denotes a normal cc-UTXO is redeemed (sourceType=0) or a LostAndFound cc-UTXO is redeemed (sourceType=1).

**ChangeAddr**. During the execution of startRescan, if votes are counted for an election, this event will be emitted to reflect the changing of cc-UTXO's P2SH address.

**Convert**. This event can be emitted by the handleUTXO function, to denote a cc-UTXO is coverted to the new covenant address.

**Deleted**. During the execution of startRescan, this event is emited when a cc-UTXO is transfered to the `targetAddress`, or to the burning address. If this cc-UTXO was once a LostAndFound cc-UTXO, sourceType is 1; if it was once a normal cc-UTXO, or was "transfering small amounts through burning", sourceType is 2.

These events help the monitors to know what happen inside smartbchd.

### Security Considerations

**The operators**. An operator's key is generated inside an enclave, bonded to the binary code of the enclave, and can only be used by this enclave: it can not be used by an enclave with a different binary or on a different CPU. We assume an operator is well-intentioned because it always does exactly what is specified in the source code. The bad things that can happen to an operator are: A) bugs (its own bugs or smartbchd's bugs); B) it is fooled by the smartbchd nodes it's connecting to; C) it is unavailable (power-off or disconnected from the internet). Because of the bad things B and C, we need multiple operators for robustness. To minimize the possibility that operators have bugs, their source code must be very simple: they just get signing tasks from smartbchd nodes and sign them blindly. We hope their source code can keep unchanged for a long time (even forever).

The operators don't need to connect to BCH full nodes. They just connect to the smartbchd nodes. A smart contract will publish the domains and TLS certification of the trustworthy nodes. We suggest that the trustworthy nodes run in enclaves (most likely SEV-SNP enclaves). Any engineer can independly verify that they are really run in enclaves and the executable binary has correct version. Monitors will also verify this.

This smart contract for publishing nodes is maintained by a group of trustworhty engineering experts, who endorse the nodes using their knowledge. 

**The monitors**. A monitor controls a side chain account to call the chain-crossing contract, and a main chain account to move the cc-UTXOs.  The side chain account's private key must be stored in a running server. We suggest to use enclaves to protect such private keys. But these keys are not bonded to the binary code of the enclave. The main chain account's private key must be stored in off-line cold wallets that are kept by some trustworthy persons.

The monitor's source code is very easy to be updated, much easier than the operator or the smartbchd full-node. So we can apply flexible strategies using the monitors. For example, we can require that the total amount of redeemed cc-UTXOs in the past 24 hours must be less than a given threshold. If the amount exceeds, the monitors will pause sha-gate for a while.

### Election of operators and monitors

Operators are elected with staked coins on the smartBCH side chain, while monitors are elected with hashing power on the main chain. Only a part of them are re-elected at a time. It is planned that there are ten operators and three of them are re-elected in each round, while there are three monitors and one of them are re-elected in each round.

BCH holders must stake their coins to vote for operators. And each monitor or operator must stake for itself with enough BCH, i.e., it must lock their own coins on the side chain, which means if SHA-Gate malfunctions, it will also suffer. The staked coins cannot be withdrawn (unstaked) until the operator or monitor is off duty.

Anyone can apply to be an operator or a monitor after self-staking enough BCH. A monitor also need nominations of half of the operators to be a candidator, while an operator becomes a candidator immediately after self-staking, without any nomination.

### Election of smartBCH nodes for operators

Operators must connect to several trustable smartbchd nodes for querying the RPC endpoints. These smartbchd nodes are elected by node proposers. When more than 2/3 of the node proposers agree, a new node can be added, or, an existing node can be obsoleted. Any monitor can obsolete a node immediately without voting.

The node proposers are decided by the operators. When the operator set is changed, the changed operator set is exactly the set of node proposers. And the proposers can vote to add new proposers or remove exsting ones.

An operator must connect to all the elected nodes. Becides these nodes, the operator's administrator can configure it to connect to one or more private smartbchd nodes which may not provide public RPC service. The operator only sign transactions when all the connected nodes return the same UTXO set.

### Appendix: RPC endpoints for chain-crossing

**sbch_getCcCovenantInfo**: returns information related to generating chain-crossing convenants P2SH address. The result is a json string:

1. operators: the current quorem of operators
2. monitors: the current quorem of monitors
3. oldOperators: the old quorem of operators before the lasting changing of operators or monitors
4. oldMonitors: the old quorem of monitors before the lasting changing of operators or monitors
5. lastCovenantAddress: the last P2SH address calculated based on last quorems (old\_operators and old\_monitors)
6. currCovenantAddress: the current P2SH address calculated current quorems
7. lastRescannedHeight: the last end-of-rescan block's height
8. rescannedHeight: the current end-of-rescan height proposed by the monitor
9. rescannTime: the current end-of-rescan time proposed by the monitor
10. signature: the signature of the above fields

In the json string, an operator is an object with following attributes:

1. address: the operator's EVM address on smartBCH
2. pubkey: the operator's public key used in the covenants
3. rpcUrl: the operator's public rpc
4. intro: an introduction

And a monitor is an object with following attributes:

1. address: the monitor's EVM address on smartBCH
2. pubkey: the monitor's public key used in the covenants
3. rpcUrl: the operator's public rpc
4. intro: an introduction

**sbch_getRedeemingUtxosForMonitors**: returns cc-UTXOs which needs redeeming. The results are checked by the monitors.

**sbch_getRedeemingUtxosForOperators**: returns cc-UTXOs which needs redeeming. The results are checked by the operators.

**sbch_getToBeConvertedUTXOsForMonitors**: returns cc-UTXOs which needs to be coverted to new operator/monitor quorem. The results are checked by the monitors.

**sbch_getToBeConvertedUTXOsForOperators**: returns cc-UTXOs which needs to be coverted to new operator/monitor quorem. The results are checked by the monitors.

**sbch_getRedeemableUTXOs**: return the cc-UTXOs which can be redeemed by smartBCH accounts.

The cc-UTXOs returned by above RPC endpoints are json objects with following attributes:

1. infos: a list of cc-UTXOs. Each entry contains the following fields:
	1. ownerOfLost: if the cc-UTXO is marked as "LostAndFound", this is its owner
	2. covenantAddr: the P2SH address calculated for this covenant
	3. isRedeemed: some account has already redeemed this cc-UTXO
	4. redeemTarget: the main chain address where this cc-UTXO will go to
	5. expectedSignTime: when will the operators sign the txSigHash with its private key
	6. txid: the cc-UTXO's txid on main chain
	7. index: the cc-UTXO's index of vout on main chain
	8. amount: the amount (in satoshi) of this cc-UTXO
	9. txSigHash: To convert or redeem this cc-UTXO, the operator must sign this hash with its private key
2. signature: the signature of the infos

The returned results of these RPC endpoints all constain a signature to endorse the other fields. The private key for generating signatures is hold only in smartbchd's memory, instead of configuration files. With the signatures, operators can make sure that the returned results are not manipulated. They provide another level of safeguard besides TLS.

### Appendix: Chain-crossing Transactions on the Main Chain

The transactions on Bitcoin Cash main chain are scanned by smartbchd one by one to pick up the ones that are related to chain-crossing. Three types of chain-crossing transactions are defined, and smartbchd will take different actions to them.

A transaction is categoried as **Redeemable** type if: 1) it has at least one P2SH output; 2) this P2SH output's address is the current covenant address or the last covenant address; 3) a receiver can be found in a OP\_RETURN output or a P2PKH input.

If there are multiple P2SH outputs with the current covenant address or the last covenant address, only the first one will be considered, and the coins in the other outputs will be ignored by smartbchd.

A transaction is categoried as **Convert** type if: 1) it has exactly one P2SH input and one P2SH output; 2) the output's P2SH address is the current covenant address; 3) the input is a cc-UTXO waiting for converting.

A transaction is categoried as **RedeemOrLostAndFound** type if: 1) it has exactly one P2SH input and one P2PKH output; 2) the P2SH input is a cc-UTXO waiting to be sent to the target of redeeming or the owner of lost.

This rescan process is triggered by monitors calling the `startRescan` function. This function will count the votes and decide the current covenant address, the last covenant address, and the cc-UTXO set waiting for converting. After this function, this rescan process will be run in the background to collect these three types of chain-crossing transactions and cache them in memory. The execution of `handleUTXO` will be blocked if this background rescan process has not finished.

### Appendix: The election of operators and monitors

The election of operators and monitors is done by both smart contracts and golang code of smartbchd. The latter counts the votes and the former finishes the other tasks.

To be a operator, you must finish the following steps:

1. Apply for the job as an operator. It requires you to stake some SBCH larger than a minimum amount.
2. Holders on the side chain stake SBCH to vote for you.
3. A the time of counting votes, you collect enough votes.

There are 10 operators in total. At most three of them are re-elected every four epochs. When couting votes, the top three new-elected operators (which are not in current quorem) and the current quorem are sorted together to find the top 10 operators with most votes.

To be a monitor, you must finish the following steps:

1. Apply for the job as a monitor. It requires you to stake some SBCH larger than a minimum amount.
2. At least five of the operators nominate you.
3. The POW miners vote for your with coinbase transactions.
4. A the time of counting votes, you collect enough PoW votes.

There are 3 operators in total. At most one of them are re-elected every 12 epochs. When couting votes, the top one new-elected monitor (which is not in current quorem) and the current quorem are sorted together to find the top 3 monitors with most PoW votes.

### Appendix: The service provided by operators

Operators run inside enclaves. They fetch to-be-signed UTXOs from the smartbchd nodes and sign them. Then they wait the collectors to query these signatures and assemble transactions.

For the operators, the highest risk is connecting to fake smartbchd nodes which returns incorrect information. To alleviate this risk, smartbchd nodes use a CC private key to sign the RPC results related to chain-crossing. From an operator's view, a smartbchd node is denoted by its RPC's URL and its CCPbkHash (the hash of the public key of the CC private key). The CC private keys are stored in off-line cold storages and are sent into smartbchd nodes through https when they starts. They are kept only in the smartbchd nodes' memory and if the node's process is re-started, they must be sent again.

So, if an attacker want to cheat an operator with a fake smartbchd node, he must first hack into the smartbchd node's memory and steal the private key and then use IP spoofing, IP hijack or DNS pollution to mislead the operator connects to a smartbchd node that uses this stolen key. Even such an attacker succeeds, the monitors can stop this operator. Monitors will watch the data that operators get from the smartbchd nodes, such as the UTXOs to be signed and the nodes to be connected. If these data are wrong, the operator will be stopped.

The smartbchd nodes may be controlled by corrupted and dishonest parts. So the operators do not trust any single one of them. Only when all these nodes returns the same result, the operators would trust it. If at least one of these nodes is honest, the operator cannot be fooled.

A smart contract on smartBCH elects the quorem of smartbchd nodes that will be connected by operators. If this quorem is changed, the operators will wait for a publicity period before switching. During this period the monitors can stop the operator.

The operator's enclave hold a private key for signing chain-crossing transactions. To protect this key, an operator has no public listening ports. Instead, it connects to a proxy server and let the proxy server talk to the public. This proxy server acts as a firewall.

An operator collects data through the smartbchd nodes' following RPC endpoints:

**sbch_getRedeemingUtxosForMonitors**: Just to record these data for checking.

**sbch_getRedeemingUtxosForOperators**: Use these data to sign hashes.

**sbch_getToBeConvertedUTXOsForMonitors**: Just to record these data for checking.

**sbch_getToBeConvertedUTXOsForOperators**: Use these data to sign hashes.

**eth_call**: To collect the new elected smartbchd nodes

An operator provides service to the proxy through these RPC endpoints:

**/cert**: Returns the hex-encoded x509 certification.

**/cert-report**: Returns the attestation report endorsing the x509 certification.

**/pubkey**: Returns the hex-encoded public key of the private key used in signing transactions

**/pubkey-report**: Returns the attestation report endorsing the public key.

**/pubkey-jwt**: Returns an Azure-generated JWT to endorse the attestation report.

**/sig?hash=<hex-string>**: Given a to-be-signed hash, return the signature signed by the operator's private key.

**/nodes**: Return the current list of smartbchd nodes.

**/newNodes**: Return the next list of smartbchd nodes, which will be connected to after the publicity period.

Each entry in the nodes list has the following fields:
1. id: a unique number
2. pbkHash: the CCPbkHash
3. rpcUrl: the URL of this node's RPC
4. intro: a short introduction of this node

**/suspend?ts=<timestamp-number>&sig=<hex-string>**: A monitor can call this RPC endpoint to stop the operator. Current time must has no larger than 1 minute different with `ts`. The `sig` is generated with the monitors private key which is used to sign the smartBCH transactions.

**/status**: Returns "suspended" if this operator is stopped by a monitor. Returns "ok" if not.
 





