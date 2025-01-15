// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AITU_SE_2317 is ERC20 {
    // Структура для хранения информации о транзакциях
    struct Transaction {
        address sender;
        address receiver;
        uint256 amount;
        uint256 timestamp;
    }

    // Массив для записи транзакций
    Transaction[] public transactions;

    // Событие для логирования транзакций
    event TransactionLogged(address indexed sender, address indexed receiver, uint256 amount, uint256 timestamp);

    // Конструктор для создания токена с начальными настройками
    constructor (string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
    require(bytes(name).length > 0, "Name is required");
    require(bytes(symbol).length > 0, "Symbol is required");
    require(initialSupply > 0, "Initial supply must be greater than zero");

    _mint(msg.sender, initialSupply);
 }

    // Переопределение функции transfer для записи транзакций
    function transfer(address recipient, uint256 amount) public override returns (bool) {
    // Call the parent ERC20 transfer function
    bool success = super.transfer(recipient, amount);
    
    // If the transfer is successful, log the transaction
    if (success) {
        transactions.push(Transaction({
            sender: msg.sender,
            receiver: recipient,
            amount: amount,
            timestamp: block.timestamp
        }));
        emit TransactionLogged(msg.sender, recipient, amount, block.timestamp);
    }
    
    return success;
 }

    // Функция для получения времени последней транзакции
    function getLatestTransactionTimestamp() public view returns (uint256) {
        require(transactions.length > 0, "No transactions recorded");
        return transactions[transactions.length - 1].timestamp;
    }

    // Функция для получения адреса отправителя последней транзакции
    function getLatestTransactionSender() public view returns (address) {
        require(transactions.length > 0, "No transactions recorded");
        return transactions[transactions.length - 1].sender;
    }

    // Функция для получения адреса получателя последней транзакции
    function getLatestTransactionReceiver() public view returns (address) {
        require(transactions.length > 0, "No transactions recorded");
        return transactions[transactions.length - 1].receiver;
    }

    // Функция для получения всей информации о последней транзакции
    function getLatestTransactionDetails()
        public
        view
        returns (address sender, address receiver, uint256 amount, uint256 timestamp)
    {
        require(transactions.length > 0, "No transactions recorded");
        Transaction storage latestTransaction = transactions[transactions.length - 1];
        return (latestTransaction.sender, latestTransaction.receiver, latestTransaction.amount, latestTransaction.timestamp);
    }
}
