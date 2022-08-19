const main = async () => {
  const factoryContract = await deployCreatorNftContract();
  await createCreatorNft(factoryContract);
  const nftIds = await getCreatorNFTs(factoryContract);
  console.log("NFT ID:", nftIds[0]);
  await createBadgeNft(factoryContract, nftIds[0]);
};

const deployCreatorNftContract = async () => {
  const factory = await hre.ethers.getContractFactory("Factory");
  const factoryContract = await factory.deploy();
  await factoryContract.deployed();
  console.log("Contract deployed to:", factoryContract.address);

  return factoryContract;
};

const createCreatorNft = async (factoryContract) => {
  let txn = await factoryContract.createCreatorNFT(
    "First",
    "FRST",
    "image.jpg",
    "This is the first creator nft of the contract."
  );
  await txn.wait();
};

const getCreatorNFTs = async (factoryContract) => {
  const signers = await hre.ethers.getSigners();
  const nfts = await factoryContract.getAddressCreatorNFTs(signers[0].address);

  return nfts;
};

const createBadgeNft = async (factoryContract, id) => {
  let txn = await factoryContract.makeABadgeNFT(id);
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
