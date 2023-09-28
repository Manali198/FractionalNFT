import { ethers } from 'hardhat';

async function main(): Promise<void> {
  const [deployer] = await ethers.getSigners();

  console.log('Contract deployment using the account:', deployer.address);

  const FractionalOwnershipNFT = await ethers.getContractFactory('FractionalOwnershipNFT');
  const fractionalOwnershipNFT = await FractionalOwnershipNFT.deploy("FractionalNFT","AM");

  await fractionalOwnershipNFT.waitForDeployment();

  console.log('fractionalOwnershipNFT contract address:', await fractionalOwnershipNFT.getAddress());

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });