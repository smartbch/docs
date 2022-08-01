### SHA-Gate-V2 Specification

SHA-Gate-V2 is new bridge design through which users can transfer their BCH between the Bitcoin Cash main chain and the smartBCH side chain. It also helps synchronizing the "to-be-burnt" BCH held in the side chain's blackhole address to the burning address on the main chain.

#### Some off-chain entities

SHA-Gate needs the interoperation of the BCH main chain, the smartBCH side chain, and some off-line entities: the operators, the monitors and collectors. The off-line entities have different duties:

**The operators**. They can move cc-UTXOs (cross-chain UTXOs) on the main chain, sending them to the users who want to tranfer their BCH from smartBCH, or to the new operator set, or to the burning address. An operator's key is generated inside an enclave, bonded to the binary code of the enclave, and can only be used by this enclave: it can not be used by an enclave with a different binary or on a different CPU. We assume an operator is well-intentioned because it always does exactly what is specified in the source code. The bad things that can happen to an operator are: A) bugs (its own bugs or smartbchd's bugs); B) it is fooled by the smartbchd nodes it's connecting to; C) it is unavailable (power-off or disconnected from the internet). Because of the bad things B and C, we need multiple operators for robustness. To minimize the possibility that operators have bugs, their source code must be very simple: they just get signing tasks from smartbchd nodes and sign them blindly. We hope their source code can keep unchanged for a long time (even forever).

The operators don't need to connect to BCH full nodes. They just connect to the smartbchd nodes which run in enclaves. A smart contract will publish the hashes of trustworthy binaries for enclaves and the IP addresses where trustworthy enclaves run on. Any engineer can independly verify the binaries' hashes and check the enclaves' attestation report, if he/she has the knowledge. This smart contract is maintained by a group of trustworhty engineering experts, who endorse the binaries' hashes and check the enclaves' attestation using their knowledge. The operators will connect to these enclaves, attest to them to ensure correct binay hashes, and check their block hashes to ensure they are on the same chain. When the enclave set that an operator connects is going to change, the operator will publish the new set's attestation and checking result for a publicity period. During the publicity period, a monitor can stop the operators from using the new set.

**The monitors**. They monitor the SHA-gate's operation. A monitor's private key is not generated inside the enclave, nor bonded to its source code. Instead, it is generated from some secret shares which are kept by some trustworthy persons. The monitors' tasks include: 1) When they find possible bugs in smartbchd, they can stop the operators and stop the SHA-Gate logic in smartbchd; and when they find out the operators will connect to an invalid smartbchd enclave, they can stop them. 2) when the majority of the operators are unavailable, monitors can use their private keys to move the cc-UTXOs to a new operator set. 3) Monitors can send transactions to synchronize the smartbchd nodes in processing the new BCH blocks which contain cross-chain tranfer transactions.

**The collectors**. They collect signatures from the operators, assemble them into transactions, and broadcast the transactions on the BCH main chain. Volunteers run the collectors.

Collectors are permissionless and anyone can run. Operators and Monitors must be elected on the smartBCH side chain. Only a part of them are re-elected at a time. It is planned that there are ten operators and three of them are re-elected in each round, while there are three monitors and one of them are re-elected in each round. BCH holders must lock their coins to vote for them. Voting for a monitor needs to lock coins longer than voting for a operator. And each monitor or operator must vote for itself with enough coins, i.e., it must lock their own coins on the side chain, which means if SHA-Gate malfunctions, it will also suffer. The logic of SHA-Gate will be automatically enabled when the monitors and operators are all elected and get ready.

#### cc-UTXO

Cross-chain UTXOs (cc-UTXOs) are a special kind of covenants. The internal logic is: 1) when 7-of-10 operators agree, a UTXO can be transferred to a P2PKH address, or a new operator set; 2) if a cc-UTXO has not been moved for a long time, then the monitors can transfer it to a new operator set. The smartbchd nodes will analyze the transactions on BCH main chain to trace the cc-UTXOs' creation, redemption (transferred to a P2PKH address), and movements (to a new validator set).

The value of cc-UTXOs has a upper bound Smax and a lower bound Smin. If the amount transferred to smartBCH is larger than Smax, the receiver on smartBCH will not get this amount. Instead, this cc-UTXO will be marked as "LostAndFound". A LostAndFound cc-UTXO can only be redeemed by this receiver by calling the cross-chain contract with zero BCH. This machanism of LostAndFound is to warn the receiver: please never do this again.

Now let's consider the situation where the amount is smaller that Smin: if the amount is also smaller than "BCH-to-be-burnt minus 10", then the receiver can get this amount and this cc-UTXO will be sent to the burning address "1SmartBCHBurnAddressxxxxxxy31qJGb" by the operators; or the receiver gets nothing and this cc-UTXO will be marked as "LostAndFound" (just like the situation where the amout is larger than Smax).

When Alice transfer some BCH from main chain to smartBCH side chain, she puts the coins in a cc-UTXO, and uses an OP_RETURN output to attach a sidechain address. If no sidechain address is attached, then the first P2PKH input of all the inputs will provide the public key which can derive a sidechain address. If no P2PKH input can be found, then this tranfer fails and the coins are lost forever.

When transferring coins from the main chain to the sidechain, the sender will pay for the miner fee. When transferring coins from the sidechain to the main chain, the miner fee will be deducted from the cc-UTXO. When transferring cc-UTXOs from the old operator set to the new operator set, the miner fees are paid using the BCH-to-be-burnt. That means, some of the BCH burnt on smartBCH will not be synchronized to the mainchain address, 1SmartBCHBurnAddressxxxxxxy31qJGb. Instead, they are used to compensate cc-UTXOs' value loss caused by the miner fee when transferring cc-UTXOs.

When the operator set is changing, if Alice accidently transfer coins to the old opeartor set, then her cc-UTXO will be marked LostAndFound. In the UI of an App or a web page which helps chain-crossing, Alice will get warnings that the operators set is changing and she'd better delay the transfer.

Even if the operator set keeps unchanged for a long time, operators will also move and recreate the cc-UTXO every several months. This will prevent the monitors from moving the cc-UTXOs. Monitors can only move the cc-UTXOs when they are old enough, which means most of the operators have been unavailable for a long time.

When transferring coins from the side chain to the main chain, Alice must redeem one or more cc-UTXOs in whole. Operators never divide or merge cc-UTXOs. Alice specifies her address on the main chain and pays enough coins to a cross-chain contract to redeem a cc-UTXO. The cross-chain contract will generate the transaction which needs to be signed by the operators. This transaction will be published through a RPC endpoint, such that the monitors can see it and check it. After a publicity period, the operators can get this transaction through another RPC endpoint and sign it, such that collectors can fetch the signatures. If the monitors want to stop operator, they must stop the SHA-Gate logic through the cross-chain contract during the publicity period, thus the operators will not get this transaction to sign.

Similarly, before transferring the cc-UTXOs to a different operator set, a publicity period is also needed, during which the monitors check the transactions and can stop the SHA-Gate logic if there is a bug.

#### Cross-chain handling in smartbchd

The average block interval of Bitcoin Cash is ten minutes, but it varies a lot from block to block. A block may be orphaned and it only gets finalized after ten confirmations. Considering these issues, it isn't always easy to make all the smartbchd nodes come to consensus in synchronization about which BCH block is the latest finalized one. An evil attacker may secretly mine a fork and broadcast it at a subtle timing to make the smartbchd nodes see different forks.

So we rely on the monitors to specify the latest finalized BCH block's height, at a proper moment. All the smartbchd nodes will collect cross-chain transactions from the last processed height to this latest finalized block, and then these transactions are cached.

Twenty minutes after the monitor specify the latest finalized height, anyone can trigger the smartbchd nodes to process the cached cross-chain transactions. New cc-UTXOs are recorded in smartbchd nodes' internal storage.

The transactions tranferring cc-UTXOs from the old operator set to the new operator set are also considered as special cross-chain transactions and will be processed. The smartbchd nodes change the recorded cc-UTXOs' information accordingly.

When a cc-UTXO is redeemed by Alice, its record is not immediately deleted from smartbchd nodes' storage, instead, it is just marked as "to be deleted". Sometime after that, when this cc-UTXO is transferred to the main chain address specified by Alice, its record will be deteted on smartBCH.

When the operators are unavailable for a long time and the monitors move cc-UTXOs, smartbchd must be hard forked to handle such a restoration after a disaster.

Monitors will check the events and status of smartbchd nodes to ensure things are going without bugs and the reconciliation is fine. The monitors' source code may be frequently updated to enrich the check items.
