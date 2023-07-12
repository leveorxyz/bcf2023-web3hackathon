# Coursewave Template
## Instructions 

### Prerequisite
```
node js 15+
yarn
```

### How to use this templated
In the root folder we manage the contract development. The frontend, is managed on `next-rainbowkit` folder.

#### Install dependencies
Install node js from [this link](https://nodejs.org/en/download/current)
Install yarn:
```
npm i -g yarn
```
Go to root directory and run the following command for installing the contract dev dependencies:
```
yarn
```
Go to `next-rainbowkit` directory and run the following command for installing the contract dev dependencies:
```
cd 
yarn
```
In the root directory create a copy of `.env.example`, call it `.env` file.
Set the `SEPOLIA_RPC_URL` and `SEPOLIA_PRIVATE_KEY` environment variable.

(Note that for frontend dev we do not have to use environment variable partially because of `Wagmi`s capabilities)

#### Setup Wallet 
One of the most popular wallet for integrating to web app is `Metamask` browser extension.
You can install it on Chromium based browser from [here](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn) 

This repo mainly operator on Ethereum network and demo is one of the testnet of Ethereum called `Sepolia` network. You can find instruction [here](https://www.alchemy.com/overviews/how-to-add-sepolia-to-metamask) to add `Sepolia` network to Metamask.
You need some balance to do send function invokation in `Sepolia` network. Here is two faucet links to get free ether in your Metamask Sepolia address:
- https://sepoliafaucet.com/
- https://sepolia-faucet.pk910.de/

### Set Environment environment variables
`SEPOLIA_PRIVATE_KEY` -> Extract private key from Metamask Sepolia account. [Here](https://helpwithpenny.com/export-and-import-metamask-private-key/) is the instruction to do so.
`SEPOLIA_RPC_URL` -> Sign up to Alchemy which [here](https://auth.alchemy.com/signup), after email verification login, create a new project, select `Sepolia` network and get the RPC URL along with the API key the format should be like: https://eth-sepolia.g.alchemy.com/v2/<API_KEY>

### Run code
- Compile contract code:
```
npm run compile
```
- Deploy contract code to `Sepolia` network:
```
npm run deploy:sepolia
```
- Test contract code:
```
npm run test
```
- Run frontend:
```
cd next-rainbowkit
npm run dev
```
