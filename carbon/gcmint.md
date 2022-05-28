---
btcwallet: bc1q2zsysq8uh2xkuedn9kg725q259ge08gzn5lhjp
burried: BuRRyZyaEg51tMJVXexSXzi9pMLzY3CSGtBpxKMzdGnU
cctoken: CarBoNrDsrBtp4YgjuxjXQnrpaLDB4HoL2dDLBFUnZjq
ccwallet: CCCEZt9WULFhPvAWFyGzgnGVhW5GnZofiyZrT7HCb9mW
cfptoken: Co2FP2AdUaKmUMLg4aGRTTNqKAQEwgAgAh5RVFXJhzar
cost: 17
cpty: 21
efprt: 0.02454
efp1btc: 2458.1227
energy: 100168
forest: Forst88SM5gkHt18BKQUtTzXRTc1LiqzDKVoocYeTpNV
gctoken: BTCG4EGjivgfgnfKfkqgZkDXuj5KdTeWuJsEGFFzkjai
gcwallet: BTCG4EGjivgfgnfKfkqgZkDXuj5KdTeWuJsEGFFzkjai
logwallet: RMco2JfZqQCsWHCcmeDXYyyCqUyE2xib6V6wgGJs4ew
micwallet: Fg2RSRChcR5m1x8wTJWYbA1GD6kcKytcQM12kDNApf37
mutkey: Qme8XesJo6QxGJTQhDqTDcf3BSmJiYg3P7x6mjjpsXyJPE
nskey: QmSLfpbX7uRUHVFkihT9ugnPE1Q8vAxKqWo8sZDbUdUdVH
solkey: QmXPxSdATbobC2zBTnnZmhvgLKcdwRvJAW8dEXWCi1d2EX
usrwallet: 2yKC6S6LRePCLT3eXh5dSb7iSLZSsWSEdrUJqd3AmVFj
layout: default
---
<meta charset="utf8"/>
## Carbon Zero System Status

[1]: https://explorer.solana.com/address/$gcwallet$?cluster=devnet
[2]: https://blockchain.com/btc/address/$btcwallet$
[3]: https://explorer.solana.com/address/$ccwaller$?cluster=devnet
[4]: https://solscan.io/address/$burried$?cluster=devnet
[5]: https://explorer.solana.com/address/$usrwallet$?cluster=devnet
[6]: https://ipfs.safewatch.xyz/ipns/$nskey$/offchain/certificate.pdf
[7]: https://ipfs.safewatch.xyz/ipns/$nskey$/
[8]: https://ipfs.safewatch.xyz/ipns/$solkey$/SOLwatchlet.log
[9]: https://ipfs.safewatch.xyz/ipfs/$qm$/gcmint.htm
[10]: https://ipfs.safewatch.xyz/ipns/$mutkey/gcmint.htm

* 1BTC: $efp1btc$kg CO2e
* previous page: [$qm$][9]
* current page: [$mutkey$][10]

### Accounts:

* balance log: [SOLwatchlet.log][8]
* CarbonZero Bitcoin Wallet: [$gcwallet$][1] (reserve)
* User Wallet: [$usrwallet$][5]
* User Metadata: [$usermeta$][7]
* User Certificate: [$qm$/offchain/certificate.pdf][6]

________________________________________________________________________
### Balances on ($date$)

* Bitcoin balance (BTC): $btcbal$ BTC $btcco2$ kg; [$btcwallet$][2] (pool)
* Uncertificed Bitcoin balance: $ubtcbal$ BTC $ubtcco2$ kg; [$btcwallet$][2] (mined)
* Carbon Zero Bitcoin balance: $gcbal$ BTC $gcco2$ kg; [$gcwallet$][1] (reserve)
* Emission Removed (Credit): $ccco2$ kg ($ccbal$ BTC); [$ccwallet$][3]
* Past Emission Removed: $brco2$ kg ($brbal$ BTC); [][4] (used)
* Certified User Carbon Zero Bitcoin balance: $ctmbal$ mBTC ($ctco2$ kg); [$usrwallet$][5] (used)
* Carbon Footprint: $cfco2$ kg ($cfbal$ BTC) (left)

________________________________________________________________________
### Carbon Removal Status and Triggered Actions (oracle):

* CarbonZero bitcoins: $clmbal$ mBTC ($clco2$kg)
* CarbonPositive (Uncertified) bitcoins: $drmbal$ mBTC ($drco2$kg)
* CarbonZero Reserve: $gcmbal$ mBTC ($gcco2$kg)
* Emission Removed (Credit):  $ccmbal$ mBTC ($ccco2$kg CO2e)
* steps for clean-up:
   - minting: 0.0000000 CarbonZero milliBitcoin (mBTC-Z)
   1. ``spl-token transfer CarBoNrDsrBtp4YgjuxjXQnrpaLDB4HoL2dDLBFUnZjq 0.000000000 BuRRyZyaEg51tMJVXexSXzi9pMLzY3CSGtBpxKMzdGnU --allow-unfunded-recipient --fund-recipient``
   2. ``spl-token mint BTCG4EGjivgfgnfKfkqgZkDXuj5KdTeWuJsEGFFzkjai 0.0000000000``
   - reset: ``spl-burn.sh BTCG4EGjivgfgnfKfkqgZkDXuj5KdTeWuJsEGFFzkjai 0.0060000000`` (after credit transfer)
* remaining footprint: 0.0000000 mBTC (1 trees needed)

```sh
spl-token transfer BTCG4EGjivgfgnfKfkqgZkDXuj5KdTeWuJsEGFFzkjai 0.0060000000 2yKC6S6LRePCLT3eXh5dSb7iSLZSsWSEdrUJqd3AmVFj --allow-unfunded-recipient --fund-recipient
```

------------------------------------------------------------------------
<script></script>
