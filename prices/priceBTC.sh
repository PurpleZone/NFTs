#

export PATH=$PATH:/home/$USER/repo/gitea/bin
# ------------------------------------------------------------------------
# get BTC price
sol=zNZHO_Sjf
btc=Qwsogvtv82FCd
wbtc=x4WXHge-vvFY
eth=razxDUgYGNAdQ
usd=yhjMzLPhuIDl
chf=eXMH_Xz9YUhh
eur=5k-_VTxqtCEI
api_url=https://api.coinranking.com/v2

find . -maxdepth 1 -name 'coinset.json' -mtime +1
stat coinset.json
found=$(find . -name 'coinset.json' -mtime +0 | wc -l)
if [ "$found" != '1' ]; then
tic=$(date +%s%N | cut -c-13)
priceSOLinCHF=$(curl -s $api_url/coin/$sol/price?referenceCurrencyUuid=$chf | json_xs -t string -e '$_ = $_->{data}{price}')
echo SOL price: $priceSOLinCHF CHF
echo $tic: $priceSOLinCHF >> priceSOL.yml
curl -s "$api_url/coins?uuids=$sol,$btc,$eth&referenceCurrencyUuid=$usd&orderBy=listedAt" | json_xs > coinset.json
else
priceSOLinCHF=$(tail -1 priceSOL.yml | cut -d' ' -f2)
fi
priceSOL=$(cat coinset.json | json_xs -t string -e '$_ = $_->{data}{coins}[0]{price}')
priceETH=$(cat coinset.json | json_xs -t string -e '$_ = $_->{data}{coins}[1]{price}')
priceBTC=$(cat coinset.json | json_xs -t string -e '$_ = $_->{data}{coins}[2]{price}')
echo SOL price: $priceSOL USD
echo BTC price: $priceBTC USD
echo ETH price: $priceETH USD

priceUSDinSOL=$(echo 1 / $priceSOL | bc -l);
echo USD price: $priceUSDinSOL SOL
priceSOLinBTC=$(cat coinset.json | json_xs -t string -e '$_ = $_->{data}{coins}[0]{btcPrice}')
priceBTCinSOL=$(echo 1 / $priceSOLinBTC | bc -l);
echo BTC price: $priceBTCinSOL SOL
#priceSOL=$(curl -s $api_url/coin/$sol/price?referenceCurrencyUuid=$chf | json_xs -t string -e '$_ = $_->{data}{price}')
#priceBTC=$(curl -s $api_url/coin/$btc/price?referenceCurrencyUuid=$chf | json_xs -t string -e '$_ = $_->{data}{price}')
#priceSOLinBTC=$(curl -s $api_url/coin/$sol/price?referenceCurrencyUuid=$btc | json_xs -t string -e '$_ = $_->{data}{price}')
# ------------------------------------------------------------------------

date=$(date +"%Y-%m-%d @ %H:%M")
git commit -a -m "price on $date: $priceBTCinSOL SOL"
git push origin
