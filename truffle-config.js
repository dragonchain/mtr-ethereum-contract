/**
 * Use this file to configure your truffle project. It's seeded with some
 * common settings for different networks and features like migrations,
 * compilation and testing. Uncomment the ones you need or modify
 * them to suit your project as necessary.
 *
 * More information about configuration can be found at:
 *
 * truffleframework.com/docs/advanced/configuration
 *
 * To deploy via Infura you'll need a wallet provider (like truffle-hdwallet-provider)
 * to sign your transactions before they're sent to a remote public node. Infura accounts
 * are available for free at: infura.io/register.
 *
 * You'll also need a mnemonic - the twelve word phrase the wallet uses to generate
 * public/private key pairs. If you're publishing your code to GitHub make sure you load this
 * phrase from a file you've .gitignored so it doesn't accidentally become public.
 *
 */

// const HDWalletProvider = require('truffle-hdwallet-provider');
// const infuraKey = "fj4jll3k.....";
//
// const fs = require('fs');
// const mnemonic = fs.readFileSync(".secret").toString().trim();
const HDWalletProvider = require('truffle-hdwallet-provider');
require('dotenv').config();

module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. If you don't specify one truffle
   * will spin up a development blockchain for you on port 9545 when you
   * run `develop` or `test`. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

  networks: {
    ganacheGUI: {
      network_id: "*",
      host: 'localhost',
      port: 7545,
      gas: 4000000
    },
    ropsten: {
      provider: new HDWalletProvider(process.env.MNEMONIC, 
          `https://ropsten.infura.io/v3/${process.env.INFURA_ROPSTEN_API_KEY}`) ,
      network_id: 3,
      gas: 4000000 //make sure this gas allocation isn't over 4M, which is the max
    },
    mainnet: {
      provider: new HDWalletProvider(process.env.MNEMONIC, 
          `https://mainnet.infura.io/v3/${process.env.INFURA_ROPSTEN_API_KEY}`, 3
      ) ,
      network_id: 1,
      gas: 4000000 //make sure this gas allocation isn't over 4M, which is the max
    }

  }
}
