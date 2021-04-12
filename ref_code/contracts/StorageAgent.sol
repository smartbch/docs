pragma solidity 0.6.12;

contract StorageAgent {
    bytes[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff] private data;
    function set(bytes calldata key, bytes calldata value) external {
        data[uint256(sha256(key))] = value;
    }
    function get(bytes calldata key) external view returns (bytes memory) {
        return data[uint256(sha256(key))];
    }
}
