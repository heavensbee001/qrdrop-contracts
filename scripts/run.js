const main = async () => {
  await createCreatorNftContract();
  await createBadgeNftContract();
};

const createCreatorNftContract = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("CreatorNFT");
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
const createBadgeNftContract = async () => {
  // const [accountA, accountB] = await hre.ethers.getSigners();

  const nftContractFactory = await hre.ethers.getContractFactory("BadgeNFT");
  const nftContract = await nftContractFactory.deploy(
    "Badge NFT Contract",
    "PNC",
    "This is the badge nft.",
    "badgeimage.jpg"
  );
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // Make a badge nft
  let txn = await nftContract.makeABadgeNFT();
  // Wait for it to be mined.
  await txn.wait();

  txn = await nftContract.getOwnerTokenId(txn.from);
  console.log(txn);

  // Try to make a badge nft with same address
  txn = await nftContract.makeABadgeNFT();
  // Wait for it to be mined.
  await txn.wait();

  // try to transfer a token
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
