---
layout: default
---
## Carbon Zero System Status

* 1BTC: 2458.1227kg CO2e

[1]: https://explorer.solana.com/address/BTCG4EGjivgfgnfKfkqgZkDXuj5KdTeWuJsEGFFzkjai?cluster=devnet
[2]: https://blockchain.com/btc/address/bc1q2zsysq8uh2xkuedn9kg725q259ge08gzn5lhjp
[3]: https://explorer.solana.com/address/CarBoNrDsrBtp4YgjuxjXQnrpaLDB4HoL2dDLBFUnZjq?cluster=devnet
[4]: https://solscan.io/address/BuRRyZyaEg51tMJVXexSXzi9pMLzY3CSGtBpxKMzdGnU?cluster=devnet
[5]: https://explorer.solana.com/address/FDhJEXbh4Hd79oREXUoAT1NkrcCF4W9SifaHv8HZ5r7H?cluster=devnet
[6]: https://ipfs.safewatch.xyz/ipns/QmSLfpbX7uRUHVFkihT9ugnPE1Q8vAxKqWo8sZDbUdUdVH/assets/0.pdf
[7]: https://ipfs.safewatch.xyz/ipns/QmSLfpbX7uRUHVFkihT9ugnPE1Q8vAxKqWo8sZDbUdUdVH/
[8]: https://ipfs.safewatch.xyz/ipns/QmXPxSdATbobC2zBTnnZmhvgLKcdwRvJAW8dEXWCi1d2EX/SOLwatchlet.log
---
### Accounts:

* balance log: [SOLwatchlet.log][8]
* CarbonZero Bitcoin Wallet: [BTCG4EGjivgfgnfKfkqgZkDXuj5KdTeWuJsEGFFzkjai][1] (reserve)
* User Wallet: [FDhJEXbh4Hd79oREXUoAT1NkrcCF4W9SifaHv8HZ5r7H][5]
* User Metadata: [QmSLfpbX7uRUHVFkihT9ugnPE1Q8vAxKqWo8sZDbUdUdVH][7]
* User Certificate: [QmSLfpbX7uRUHVFkihT9ugnPE1Q8vAxKqWo8sZDbUdUdVH/assets/0.pdf][6]

---
### Balances:

* Uncertified Bitcoin balance: 0.0162357400 BTC 39.909441 kg; [bc1q2zsysq8uh2xkuedn9kg725q259ge08gzn5lhjp][2] (pool)
* Bitcoin Carbon Zero balance: 0.0012097700 BTC 2.973763 kg; [BTCG4EGjivgfgnfKfkqgZkDXuj5KdTeWuJsEGFFzkjai][1] (reserve)
* Available Carbon Credit: 31.026227 kg (0.0126219196 BTC); [CarBoNrDsrBtp4YgjuxjXQnrpaLDB4HoL2dDLBFUnZjq][3]
* Emission Removed: 39.909441 kg (0.0162357400 BTC); [BuRRyZyaEg51tMJVXexSXzi9pMLzY3CSGtBpxKMzdGnU][4] (used)
* Carbon Footprint: 0.000000 kg (0.0000000000 BTC) (left)

---
### Carbon Removal Status and Actions:

* CarbonZero bitcoins: 16.2357400 mBTC (39.909kg)
* CarbonPositive bitcoins: 0.0000000 mBTC (0.000kg)
* CarbonZero Reserve: 1.2097700 mBTC (2.974kg)
* Carbon Credit:  12.6219196 mBTC (31.026227kg CO2e)
* steps for clean-up:
   - minting: 0.0000000 Carbon Zero milliBitcoin (mBTC-Z)
   1. spl-token transfer CarBoNrDsrBtp4YgjuxjXQnrpaLDB4HoL2dDLBFUnZjq 0.000000000 BuRRyZyaEg51tMJVXexSXzi9pMLzY3CSGtBpxKMzdGnU --allow-unfunded-recipient --fund-recipient
   2. spl-token mint BTCG4EGjivgfgnfKfkqgZkDXuj5KdTeWuJsEGFFzkjai 0.0000000000
   - reset: spl-burn.sh BTCG4EGjivgfgnfKfkqgZkDXuj5KdTeWuJsEGFFzkjai 0.0012097700 (after credit transfer)
* remaining footprint: 0.0000000 mBTC (1 trees needed)
  
---
```sh
spl-token transfer BTCG4EGjivgfgnfKfkqgZkDXuj5KdTeWuJsEGFFzkjai 0.0012097700 FDhJEXbh4Hd79oREXUoAT1NkrcCF4W9SifaHv8HZ5r7H --allow-unfunded-recipient --fund-recipient
```

---
