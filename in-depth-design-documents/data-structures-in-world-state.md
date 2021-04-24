# Data structures in world state

In this article, we describe the different kinds of key-value pairs which are stored in smartBCH's world state.

In the following descriptions, we use "+" to denote concatenation.



### Basic Information of an Account

Key: byte(23) + 20-byte-address

Value:

1. 32-byte Balance (Big Endian)
2. 8-byte Nonce (Big Endian)
3. 8-byte Sequence (Big Endian). For EOA, the sequence is always uint64(-1). For contract account, the sequence is assigned a unique value when created.



### Creation Counter

Key: byte(21) + first-byte-of-address

Values: 8-byte Counter (Big Endian)

All the smart contracts who have the same value in the first byte of address share one counter. Each time a new contract is created, this counter get increased by one. And the address of the new contract is calculated by: new-value-of-counter * 256 + first-byte-of-address.



### Storage in Smart Contract Accounts

Key: byte(27) + 8-byte-account-sequence + 32-byte-key

Value: Non-zero-length byte string (not required to be 32 bytes)

Please note after a smart contract's self-destruction, there will never be another contract which can have the same account sequence as it. So the self-destructed contract's storage slots can never be accessed.



### Bytecode

Key: byte(25) + 20-byte-address

Value: arbitrary-length byte string

EOA has no bytecode. We only store byte codes for smart contracts.



### Standby Queue's Start&End Positions

Key: byte(102)

Value:

1. 8-byte start position (Big Endian)
2. 8-byte end position (Big Endian)

You can find a standby transaction at a position in the range [start, end)



### Standby Queue's Content

Key: byte(100) + 8-byte-position

Value: serialized bytes for a transaction



###Current Block's basic information

Key: byte(29)

Value: serialized bytes of current Block's basic information
