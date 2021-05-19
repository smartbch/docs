# Blockchain Browser API

## 1. Given height, query block

```text
GET /v1/block/{block_height}
```

**Response**

```javascript
{
    "Number": "0x13",
    "Hash": "0x9c9c50705e431ad294e1fb6917ec8b0c00c28b282f776b20f1ad0e927f8ce448",
    "ParentHash": "0x89c82372fdb9aea8b3e5041c0fb1611985abed026f90e269046dfc282a37f2fa",
    "Miner": "0xd0b1a15d2759af1fe569e4d4074ae13c91087f31",
    "Size": "0x234",
    "GasLimit": "0x0",
    "GasUsed": "0x0",
    "Timestamp": "0x604f0ffd",
    "TransactionsCount": "0x1",
    "BlockReward": "", //Not implemented yet
    "StateRoot": "0x8dce8194d72c0acc8ad78073ec7e7d54e39c6906cff457e8fc106711d933cd21",
    "TransactionsRoot": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "Transactions": [
        "0x880c564aeaacdf1a877f9398a423f79a4831c0ec461e9b6d75f628bbc5b5ff3e"
    ]
}
```

## 2. Given a block's height, query the transactions in it

```text
GET /v1/txs/{block_height}
```

**Response**

```javascript
{
    "Block": "0x6",
    "Transactions": [
        {
            "Hash": "0x09938944c3a7ed0179b2953883c5006e4ca15af8fcd4508761cc35f4acc48114",
            "BlockNumber": "0x6",
            "From": "0x09f236e4067f5fca5872d0c09f92ce653377ae41",
            "To": "0xc7bbd3373c6d9f582102c332be91e8dcdd087e35",
            "Age": "", //暂时不支持
            "Value": "0x0"
        }
    ]
}
```

## 3. Given address, query information about account

```text
GET /api/v1/account/{address}
```

Query the transactions whose `from` or `to` is this address, without pagination.

```text
GET /api/v1/account/{address}?page=1
```

Query the transactions whose `from` or `to` is this address, and returns the first page \(25 transactions per page\).

```text
GET /api/v1/account/{address}?from=true&page=1
```

Query the transactions whose `from` is this address, and returns the first page \(25 transactions per page\).

```text
GET /api/v1/account/{address}?to=true&page=1
```

Query the transactions whose `to` is this address, and returns the first page \(25 transactions per page\).

The transactions in the returned list is sorted in the decreasing order of block height.

**Response**

```javascript
{
    "Balance": "0xde0b6b3a7640100",
    "Transactions": [
        {
            "Hash": "0x880c564aeaacdf1a877f9398a423f79a4831c0ec461e9b6d75f628bbc5b5ff3e",
            "BlockNumber": "0x13",
            "From": "0xab5d62788e207646fa60eb3eebdc4358c7f5686c",
            "To": "0x3e144eb45c5ff912b2b29b2823fa674c972e9ec0",
            "Age": "", //Not implemented yet
            "Value": "0x100"
        }
    ]
}
`
```

## 4. Given transaction's hash, query its information

```text
GET /api/v1/tx/{hash}
```

**Response**

```javascript
{
    "hash": "0x9fc76417374aa880d4449a1f7f31ec597f00b1f6f3dd2d66f4c9c6c445836d8b",
    "nonce": "0x2",
    "blockNumber": "0x3",
    "transactionIndex": "0x1",
    "from": "0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b",
    "to": "0x6295ee1b4f6dd65047762f924ecd367c17eabf8f",
    "value": "0x123450000000000000",
    "gas": "0x314159",
    "gasPrice": "0x2000000000000",
    "gasUsed": "0x3000",
    "input": "0x57cb2fc4"
    "logs": [
            {
                "address":"0x56badd9B06bBaA1dF336A5A9524A90592a5Db962",
                "topics":[
                    "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
                    "0x56badd9b06bbaa1df336a5a9524a90592a5db962",
                    "0x18bdcf05a8093051472a09dcd3bfcaa0cdd546c0",
                ],
                "data":"0x000000000000000000000000000000000000000c9f2c9cd04674edea40000000",
            }
    ]
}
```

## 5. Given a token's address, query its information

```text
GET /v1/erc20/{token_address}
```

Query all the transfer transactions of a token. At most 1000 entries can be returned.

```text
GET /v1/erc20/{token_address}?page=1
```

Query the transfer transactions of a token, with pagination.

```text
GET /v1/erc20/{token_address}?address=0x49Fd1607a0b93334F090eBaF42C72BaBb38a0f76&page=1
```

Query the transfer transactions of a token with this address as its sender or recipient, with pagination.

**Request**

```text
http://localhost:8080/v1/erc20/0xc7bbd3373c6d9f582102c332be91e8dcdd087e35?page=1
```

**Response**

```javascript
{
    "Symbol": "4f50540000000000000000000000000000000000000000000000000000000000",
    "Decimals": "0x0000000000000000000000000000000000000000000000000000000000000001",
    "MaxSupply": "0x0000000000000000000000000000000000000000000000000000000000002710",
    "ContractAddress": "0xc7bbd3373c6d9f582102c332be91e8dcdd087e35",
    "Transactions": [
        {
            "Hash": "0x09938944c3a7ed0179b2953883c5006e4ca15af8fcd4508761cc35f4acc48114",
            "BlockNumber": "0x6",
            "From": "0x09f236e4067f5fca5872d0c09f92ce653377ae41",
            "To": "0xc7bbd3373c6d9f582102c332be91e8dcdd087e35",
            "Age": "", //Not implemented yet
            "Value": "0x0" //Not implemented yet
        }
    ]
}
```

## 6. Given a symbol, query token addresses

```text
GET /v1/erc20s/{token_symbol}
```

Different tokens can share the same symbol.

**Response**

```javascript
["0xc7bbd3373c6d9f582102c332be91e8dcdd087e35"]
```

## 7. Query the latest price of BCH

```text
GET /v1/bch_price
```

**Response**

```text
"600.01" // USD
```

