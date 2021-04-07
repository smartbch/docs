pragma solidity 0.6.12;

contract StorageAgent {
    mapping(address => mapping(bytes => bytes)) private data;
    function set(bytes calldata key, bytes calldata value) external {
        data[msg.sender][key] = value;
    }
    function get(bytes calldata key) external view returns (bytes memory) {
        return data[msg.sender][key];
    }
}
