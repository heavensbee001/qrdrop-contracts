const main = async () => {
    await createCreatorNftContract();
    await createPoapNftContract();
};

const createCreatorNftContract = async () => {
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
};
const createPoapNftContract = async () => {
    // const [accountA, accountB] = await hre.ethers.getSigners();

    const nftContractFactory = await hre.ethers.getContractFactory("PoapNFT");
    const nftContract = await nftContractFactory.deploy(
        "Poap NFT Contract",
        "PNC",
        "This is the poap nft.",
        "poapimage.jpg"
    );
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    // Call the function.
    let txn = await nftContract.makeAPoapNFT();
    // Wait for it to be mined.
    await txn.wait();

    txn = await nftContract["safeTransferFrom()"]();
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
