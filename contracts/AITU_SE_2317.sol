// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AITU_SE_217 is ERC20 {
    struct Transaction {
        address sender;
        address receiver;
        uint256 amount;
        uint256 timestamp;
    }

    Transaction[] public transactions;

    constructor() ERC20("SE-2317", "SE_17") {
        _mint(msg.sender, 2000 * 10 ** decimals()); // Mint 2000 tokens with 18 decimals
    }

    // Override the transfer function to log transactions
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        bool success = super.transfer(recipient, amount);
        if (success) {
            transactions.push(Transaction({
                sender: msg.sender,
                receiver: recipient,
                amount: amount,
                timestamp: block.timestamp
            }));
        }
        return success;
    }

    // Retrieve transaction information by index
    function getTransaction(uint256 index) public view returns (
        address sender,
        address receiver,
        uint256 amount,
        uint256 timestamp
    ) {
        require(index < transactions.length, "Transaction does not exist");
        Transaction memory transaction = transactions[index];
        return (
            transaction.sender,
            transaction.receiver,
            transaction.amount,
            transaction.timestamp
        );
    }

    // Return the block timestamp of the latest transaction in a human-readable format
    function getLatestTransactionTimestamp() public view returns (uint256) {
        require(transactions.length > 0, "No transactions found");
        return transactions[transactions.length - 1].timestamp;
    }

    // Retrieve the address of the transaction sender for the latest transaction
    function getLatestTransactionSender() public view returns (address) {
        require(transactions.length > 0, "No transactions found");
        return transactions[transactions.length - 1].sender;
    }

    // Retrieve the address of the transaction receiver for the latest transaction
    function getLatestTransactionReceiver() public view returns (address) {
        require(transactions.length > 0, "No transactions found");
        return transactions[transactions.length - 1].receiver;
    }

    // Helper function to convert timestamp to a human-readable string
    function timestampToString(uint256 timestamp) internal pure returns (string memory) {
        return string(abi.encodePacked(
            "Timestamp: ",
            uint2str(timestamp)
        ));
    }

    // Helper function to convert uint256 to string
    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = uint8(48 + _i % 10);
            bstr[k] = bytes1(temp);
            _i /= 10;
        }
        return string(bstr);
    }
}