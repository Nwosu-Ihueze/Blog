
async function main() {
  /*
  A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
  so cryptoDevsContract here is a factory for instances of our CryptoDevs contract.
  */
 const [deployer] = await hre.ethers.getSigners();
 const accountBalance = await deployer.getBalance();

console.log("Deploying contracts with account: ", deployer.address);
console.log("Account balance: ", accountBalance.toString());

const blogContract = await hre.ethers.getContractFactory("Blog");

  // deploy the contract
  const deployedBlogContract = await blogContract.deploy();
  await deployedBlogContract.deployed();

  // print the address of the deployed contract
  console.log(
    "Blog Address:",
    deployedBlogContract.address
  );
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});