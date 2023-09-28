# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```
Those things are used in the smart contract those are the brief things are here.
1. **Sole Ownership:**
   - The contract inherits from the `Ownable` contract, which means that only the owner (deployer of the contract) has certain privileged functions, ensuring sole ownership.
   - The `onlyOwner` modifier is used in various functions, restricting access to the owner.

2. **Fractional Ownership:**
   - The contract keeps track of ownership shares for each address and each token ID in the `_ownershipShares` mapping.
   - Shares can be minted by the contract owner, transferred between addresses, and additional shares can be contributed by buyers.
   - The `_shareOwners` mapping is used to keep a list of owners of shares for each token ID.
   - The `contributeShares` function allows buyers to contribute additional shares to the NFT.

3. **Minting and Transfer:**
   - The `mint` function allows the contract owner to mint new NFTs with specified shares.
   - The `transferShare` function allows the contract owner to transfer ownership shares to another address.

4. **Revenue Distribution:**
   - The contract includes functionality for revenue distribution. The `addRevenueDistribution`, `removeRevenueDistribution`, and `distributeRevenue` functions allow the owner to manage and distribute revenue among shareholders.
   - It uses a struct (`RevenueDistribution`) to store percentage and recipient information for revenue distribution.

5. **SafeMath:**
   - The contract uses SafeMath for arithmetic operations, preventing overflows and underflows.

6. **Events:**
   - Events such as `SharesContributed` are emitted to provide information about certain transactions.

**Note:** Ensure that the OpenZeppelin library is correctly installed and the version specified in the `pragma` statement is compatible.
