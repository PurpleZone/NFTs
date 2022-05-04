---
title: facts about bitcoin emission
wallet: 1BTCG4m8boripfRKCJXCdRm1t7YY4N1WZH
tokenid: BTCGZYMqyfA8WBKNgwcpZn21ruNBvHvbfnrYNsd4xtTZ
source: hydroelectricity
mining: 2.454 # tons per mining (hydro)
emiskg: 2454 # kg per mine
dam: 24  # g per kWh
trees: 78 # planted tree
cpt: 314 # kg carbon sequestred per tree (lifetime)
reminder: 48 # emiskg - trees * cpt
energypc: 100 # MWh per btc
ewaste: 32 # kg of ewaste
...
### Here are the (immutable) facts about the BTC-G coin

<!--
<svg id=btcg>
<use href=btc-g.svg#btcg />
</svg>
<style>#btcg { max-width: 24vw; float: right }</style>
<hr>
-->

[![BTCG](https://cdn.jsdelivr.net/gh/PurpleZone/NFTs/btcg/btc-g.svg)][1]
<style>img[alt=BTCG] { max-width: 24vw; float: right }</style>

This [BTC-G][1] coin is a wrapped bitcoin, minted to track and negate the emission
generated from the mining of the original [bitcoin][2].
We ensure the coin is carbon neutral by guaranteing the right amont of living
trees is planted and protected until the total emitted carbon is sequestred
back in the ground.

(note: remember a transaction on the bitcoin main chain emit 417kg of CO₂,
so please plant 1 to 3 tree if you want to move the bitcoin arround)

[1]: https://explorer.solana.com/address/$tokenid$?cluster=devnet
[2]: https://www.blockchain.com/btc/address/$wallet$

#### CARBON NEUTRAL

Carbon Footprint per Green Bitcoin: $emiskg$ - $trees$ x $cpt$ = $reminder$kg
<br>Energy source: $source$


Total Carbon Used to produce Bitcoin: *$mining$ tCO₂-eq*
<br> (this includes $dam$g CO₂-eq per kWh for the Dam)

Equivalent Trees Planted: $trees$

* energy cost : $energypc$MWh
* C02 emission are : $emiskg$kg
* e-waste: $ewaste$ kg
* water consumption: 522,000,000l

see the metadata: [here](btc-g.json)


[3]: https://ceepr.mit.edu/wp-content/uploads/2021/09/2018-018.pdf
[4]: https://www.forbes.com/sites/philippsandner/2021/11/19/bitcoin-co2-emissions-from-an-investor-perspective-and-how-to-compensate-them/

<!--
  old calculation:
  4.608 tCO₂-eq per Bitcoin
  100,000 kwh per coin
  Dam 24 gCO₂-eq/kWh

  4.608 tCO₂-eq per Bitcoin
  Equivalent Trees Planted: 144 
  (320kg / tree)
  
  new calculation: 
  Carbon Footprint per Bitcoin: 0.00
  Energy source: hydroelectricity
  Total Carbon Used to produce Bitcoin: 2.454 tCO₂-eq
  Equivalent Trees Planted: 78
  (314kg/ tree)

  (Yannick's rules ~400kg C during life of a tree)

  2018, to be 48.2 TWh, and estimate that annual carbon emissions range from 21.5 to 53.6 MtCO2
  https://ceepr.mit.edu/wp-content/uploads/2021/09/2018-018.pdf
  
  0.65 tons CO2 per MWh https://www.coindesk.com/markets/2014/04/07/what-is-the-carbon-footprint-of-a-bitcoin/
  
  Carlson: 
  10 TH/sec (10,000 GH/sec) make 1 bitcoin per day at the current
  difficulty, he says. His hardware uses one watt per GH/sec, meaning
  that it takes 10,000 watts (10kW) to run 10TH of equipment.  He runs
  that 10kW of equipment for a whole day to mine a bitcoin, which means
  that he spends 240 kW·h. That's 24% of a megawatt hour (MW·h).
  Remember that according to the IEA data, 1 MW·h of mains electricity
  produces 1300lb of carbon (590kg). Based on Carlson's figures, that means that
  the energy he's using would release 24% of that, or 312lbs, of carbon
  dioxide into the air per coin.
  
  Bitcoin is thought to consume 707 kwH per transaction (->417kg/tx) -> 1-3 trees per transaction
  https://news.climate.columbia.edu/2021/09/20/bitcoins-impacts-on-climate-and-the-environment/
  
  369.49 kgCO2eq per bitcoin transaction
  https://www.forbes.com/sites/philippsandner/2021/11/19/bitcoin-co2-emissions-from-an-investor-perspective-and-how-to-compensate-them/?sh=5168bb738c1c
  
 39% mining energy comes from renewable: 
   https://journals.library.columbia.edu/index.php/consilience/blog/view/349
   
 Greenidge draws 139 million gallons of fresh water out of Seneca Lake each day
 bitcoin 11.5 kilotons of e-waste each year
 
 11500 / 365 = 32kg /days (globally: so 32kg every 10min)
 
 138 * 3.785 = 522Ml/day

 https://www.leafscore.com/blog/the-9-most-sustainable-cryptocurrencies-for-2021/
 
 https://climate360news.lmu.edu/cryptocurrency-mining-has-a-huge-carbon-footprint-heres-what-experts-think-we-should-do-about-it/
 
 https://www.forbes.com/sites/philippsandner/2021/11/19/bitcoin-co2-emissions-from-an-investor-perspective-and-how-to-compensate-them/?sh=5168bb738c1c
 
 https://www.coindesk.com/business/2022/01/10/cardano-reaches-goal-of-planting-1m-trees/
 
 https://cryptotrees.earth/
 
 https://forestcoin.earth/
 
 https://www.bloomberg.com/crypto
 
 
 bitcoin 115Mtx / year
 https://fortune.com/2021/11/06/offsetting-bitcoins-carbon-footprint-would-require-planting-300-million-new-trees/
 
 https://real-leaders.com/forget-bitcoin-planting-trees-offers-amazing-returns/
 
 https://globalshakers.com/blockchain-startup-treecoin-plans-to-plant-37-million-trees/
 
 https://www.prnewswire.com/news-releases/binance-charity-launches-nft-tree-planting-project-tree-millions-to-plant-10m-trees-worldwide-301380558.html
 
 https://fortune.com/2021/05/16/elon-musk-tesla-bitcoin-mining-fossil-fuels-sustainable-green/?queryly=related_article
-->
