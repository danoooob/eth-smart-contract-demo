# ETH Smart Contract demo

* Install truffle to compile and deploy smart contract
```bash
npm install -g truffle
```

* Install [Ganache](http://trufflesuite.com/docs/ganache/quickstart) (Optional)

* Change config to your node in file `trunffle-config.js`
```js
development: {
    host: "127.0.0.1",     // Localhost (default: none)
    port: 7545,            // Standard Ethereum port (default: none)
    network_id: "*",       // Any network (default: none)
},
```

* Deploy
```bash
truffle deploy
```

* Change smart contract address in `web/index.html`
```js
const CONTRACT_ADDR = '0x030Bb1731fDA42181745b9F9DAd7cEF1Af64D87A';
```

* Run web for testing:
```bash
node web.js
```

## Links
* [RockPaperScissors](https://github.com/jha929/rock-paper-scissors)