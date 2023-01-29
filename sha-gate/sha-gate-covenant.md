### Sha-Gate's covenant

The covenant used in Sha-Gate are implemented in CashScript to utilize self-introspection. It manages the cc-UTXOs which keep the coins transferred to the smartBCH sidechain.

The logic of this covenant is quite simple:

1. There are 10 operators and 3 monitors, whose hashes are encoded as the covenant's constructor parameters, i.e., part of the scriptPubkey.

2. If seven of the ten operators sign the transaction, this cc-UTXO can be spent in any way they want, as long as the transaction has only one input and one output. (`redeemOrConvert`)

3. If at least seven operators are unavailable for more than eight months, this cc-UTXO can be sent to a new operator set. (`convertByMonitors`)

It is very unlikely that we need to use `convertByMonitors`. So currently the smartbchd nodes do not recognoize such transactions. If such a accident really happens (at least seven operators are unavailable for more than eight months), the smartbchd nodes need to be hard-forked to recognize `convertByMonitors`.

The miner fee of `redeemOrConvert` is deducted from the input cc-UTXO and has an upper bound hardcoded in the covenant. And the miner fee of `convertByMonitors` is paid by some other input other than cc-UTXO.

In practice, the operators only sign two kinds of transactions using `redeemOrConvert`:

1. Send the cc-UTXO to a P2PKH address. For such cases, the covenant does not check anything.

2. Convert the cc-UTXO's constructor parameters, while keeping the covenant's logic unchanged. For such cases, the covenant checks the format of the resulted P2SH output.

