import { createWalletClient, http, parseEther } from "viem";
import { privateKeyToAccount } from "viem/accounts";
import { foundry } from "viem/chains";

// Anvil default private key (account #0)
const PRIVATE_KEY = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";

async function main() {
    const account = privateKeyToAccount(PRIVATE_KEY);

    const client = createWalletClient({
        account,
        chain: foundry,
        transport: http("http://localhost:8545"),
    });

    const contractAddress = "0x19A1c09fE3399C4Daaa2C98b936a8E460fC5Eaa4";
    const amount = parseEther("0.00000000000001");

    console.log(`Sending ${amount.toString()} wei to contract ${contractAddress}...`);
    console.log(`From account: ${account.address}`);

    try {
        const hash = await client.sendTransaction({
            to: contractAddress,
            value: amount,
        });

        console.log(`Transaction hash: ${hash}`);
        console.log(`Waiting for confirmation...`);

        // Wait a bit for the transaction to be mined
        await new Promise(resolve => setTimeout(resolve, 2000));

        console.log("Transaction sent successfully!");
        console.log(`Check the contract at: ${contractAddress}`);
    } catch (error) {
        console.error("Error sending transaction:", error);
        process.exit(1);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

