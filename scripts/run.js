const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory(
        "CreatorNFT"
    );
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    // Call the function.
    let txn = await nftContract.makeACreatorNFT(
        "First",
        "image.jpg",
        "This is the first creator nft of the contract."
    );
    // Wait for it to be mined.
    await txn.wait();

    txn = await nftContract.makeACreatorNFT(
        "Second",
        "image.jpg",
        "This is the second creator nft of the contract."
    );
    // Wait for it to be mined.
    await txn.wait();
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();
