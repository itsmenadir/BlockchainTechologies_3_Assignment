const hre = require("hardhat");
const { ethers } = require("hardhat");
const moment = require('moment-timezone'); 
async function main() {
    const [deployer, recipient] = await hre.ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    const UniversityToken = await hre.ethers.getContractFactory("MyToken");
    const token = await UniversityToken.deploy();

    const contractAddress = await token.getAddress();

    console.log("Token deployed to:", contractAddress);

    const totalSupply = await token.totalSupply();
    console.log("Total Supply:", totalSupply.toString());

    const recipientAddress = deployer.address; 
    

    console.log("Deployer Address:", deployer.address);
    console.log("Contract Address:", contractAddress);
    console.log("Recipient Address:", recipientAddress);

    const amount = ethers.parseUnits("100", 18);

    const tx = await token.transfer(recipientAddress, amount);
    await tx.wait();

    console.log("Transfer transaction hash:", tx.hash);

    const latestTimestamp = await token.getLatestTransactionTimestamp();
console.log("Latest Timestamp (Unix): ", latestTimestamp);

const timestampNumber = Number(latestTimestamp);

if (timestampNumber > 0) {
    const date = new Date(timestampNumber * 1000);
    const momentDate = moment.tz(date, 'Asia/Almaty');
    const formattedDateTimeMoment = momentDate.format('MMMM Do YYYY, h:mm:ss a');
    console.log("Latest Timestamp (Formatted Date and Time Moment.js): ", formattedDateTimeMoment);
} else {
    console.log("Invalid timestamp received from contract.");
}


    const latestSender = await token.getLatestTransactionSender();
    console.log("Latest Sender: ", latestSender);

    const latestReceiver = await token.getLatestTransactionReceiver();
    console.log("Latest Receiver: ", latestReceiver);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});