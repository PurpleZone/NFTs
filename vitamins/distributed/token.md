---
gateway: https://ipfs.safewatch.xyz
---
<meta charset="utf8"/>
{%- include definitions.liquid -%}
## PhenomX vitamins for {{perso.recipient}} 

[![phxvit]({{page.gateway}}/ipfs/{{ipfs.qmseries}}/{{perso.series}}/{{perso.lot}}.svg)]({{page.gateway}}/ipfs/{{ipfs.qmseries}}/{{perso.series}}/{{perso.lot}}.html)
<style>img[alt=phxvit] { float: right; width: 240px; }</style>

Series: [{{perso.series}}]({{page.gateway}}/ipfs/{{ipfs.qmvit}}/S{{perso.series}}),
lot: {{perso.lot}}
{% if ipfs.qmlot %}<br>hash: [{{ipfs.qmlot}}]({{page.gateway}}/ipfs/{{ipfs.qmlot}}/){% else %}<br>hash: [{{ipfs.qmseries}}]({{page.gateway}}/ipfs/{{ipfs.qmseries}}/{{perso.series}}){% endif %}
<br>Composition: {{meta.composition | jsonify}}
<br>image: [{{perso.lot}}.svg]({{page.gateway}}/ipfs/{{ipfs.qmseries}}/{{perso.series}}/{{perso.lot}}.svg)
<br>json: [{{perso.lot}}.json]({{page.gateway}}/ipfs/{{ipfs.qmseries}}/{{perso.series}}/{{perso.lot}}.json)

> Note:
 {{perso.note}}
 <br>~{{perso.signature}} 

Wallet: [{{perso.wallet}}](https://explorer.solana.com/address/{{perso.wallet}}/tokens?cluster=devnet)
<br>Attributes: [{{perso.mint}}](https://explorer.solana.com/address/{{perso.mint}}/attributes?cluster=devnet)
<br>Metadata: [{{perso.mint}}](https://explorer.solana.com/address/{{perso.mint}}/persodata?cluster=devnet)
<br>Distribution: [{{perso.mint}}](https://explorer.solana.com/address/{{perso.mint}}/largest?cluster=devnet)

 
 

Explore: <https://explorer.solana.com/address/{{perso.wallet}}?cluster=devnet>
<br>Mint: <https://explorer.solana.com/address/{{perso.mint}}?cluster=devnet>
<br>Token: <https://solscan.io/token/{{perso.mint}}?cluster=devnet>
<br>Search: <https://duckduckgo.com/?q={{perso.mint}}>
