#

image=evitamin.svg
origin=${image%.*}-orig.svg
yamlf=${image%.*}.yml
jsonf=${image%.*}.json
#cat $yamlf | json_xs -f yaml > $jsonf

file=$(cat $yamlf | json_xs -f yaml -t string -e '$_=$_->{file}')
title=$(grep -P -e '\w:' $file | json_xs -f yaml -t string -e '$_=$_->{title}')

json=${file%.*}.json
qmhash=$(ipfs add -w $file $json -Q)

initials=$(cat $yamlf | json_xs -f yaml -t string -e '$_=$_->{initials}')
symbol=$(cat $yamlf | json_xs -f yaml -t string -e '$_=$_->{symbol}')
assets=./assets
intent=$(ipfs add -Q $file)
echo "intent: $intent"
n=$(cat params.yml | json_xs -f yaml -t string -e '$_=$_->{n}+1')
sig=$(expr "$$" % $n)
echo "sig: $sig"
perl -S intent.pl -i "$intent" | tee intent.yml
seed=$(cat intent.yml | grep -w -e seed: | cut -d' ' -f2)
series="S$seed";
echo series: $series

qmid=$(ipfs add $yamlf -Q)
cat > nft-mutable.yml <<EOT
--- # evitamin parameters
qmhash: $qmhash
intent: $intent
desc: "$title"
symbol: "$symbol"
initials: "$initials"
series: "S$seed"
EOT
echo qmid: $qmid | cat nft-meta.yml params.yml $yamlf nft-mutable.yml - | grep -v '^---'| \
perl -S setnftattributes.pl $jsonf | json_xs | grep ini
# create json, tmpl.svg, svg
echo qmid: $qmid | cat nft-meta.yml params.yml $yamlf nft-mutable.yml - | grep -v '^---'| \
perl -S setnftattributes.pl $jsonf > $assets/0.json
perl -S jsonapply.pl $assets/0.json $origin spl-token-templ.svg
perl -S jsinc.pl spl-token-templ.svg  > $image
echo qmid: $qmid | cat nft-meta.yml params.yml $yamlf nft-mutable.yml -
jitter $image $sig $intent

find $cache -name '*~1' -delete
cp -p S$seed/PNGs/${image%.*}-sig.png $assets/0.png
qm=$(ipfs add -r $assets $file -Q)
ipfs pin remote add --service=nft --name=$symbol-$sig $qm --background

set -xe
if grep -q keypair: $yamlf; then
keypair=$(cat $yamlf | json_xs -f yaml -t string -e '$_=$_->{keypair}')
fi
keypair=${keypair:-$HOME/.config/solana/devnet.json}
wallet=$(solana address -k $keypair)
echo "wallet: $wallet"
solana balance  -u devnet $wallet
solana airdrop 1 $wallet

exit;

livedate=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
grep -v '^#' > nft-config.json <<EOF
{
"price": "0.05",
"number": 1,
"gatekeeper": null,
"solTreasuryAccount": "$wallet",
"splTokenAccount": null,
"splToken": null,
"goLiveDate": "$livedate",
"endSettings": null,
"whitelistMintSettings": null,
"hiddenSettings": null,
"storage": "pinata",
"ipfsInfuraProjectId": null,
"ipfsInfuraSecret": null,
"pinataJwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySW5mb3JtYXRpb24iOnsiaWQiOiJjYTYyYWNmMS0yODk0LTQ3ZTMtOTVjNC1lMGJhNjE2NGNkZDMiLCJlbWFpbCI6Im1pY2hlbGNAZHJpdC5tbCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJwaW5fcG9saWN5Ijp7InJlZ2lvbnMiOlt7ImlkIjoiRlJBMSIsImRlc2lyZWRSZXBsaWNhdGlvbkNvdW50IjoxfV0sInZlcnNpb24iOjF9LCJtZmFfZW5hYmxlZCI6ZmFsc2V9LCJhdXRoZW50aWNhdGlvblR5cGUiOiJzY29wZWRLZXkiLCJzY29wZWRLZXlLZXkiOiI1MTM2NjczY2QxMjg1ZjRhZGQ3NSIsInNjb3BlZEtleVNlY3JldCI6ImQ3NDAxMDJjZWQwMTJlMzViYzVjNjM5ZjE1YjFhNjFiYTQyNmQ4ODg5YzFmNGY5Zjk1M2ZjZjYzZDRkMzQ1ZTUiLCJpYXQiOjE2NDAyMDU5NTV9.GFOPo7tBbM_uljCvvyIbIcrC-iBc3zellt8KOlnD7V4",
"pinataGateway": null,
#"pinataGateway": "https://gateway.pinata.cloud",
"awsS3Bucket": null,
"noRetainAuthority": false,
"noMutable": false
}
EOF

cache=assets
export MTP_HOME=$HOME/clients/ideator/metaplex

# upload (creating the candy machine)
ts-node $MTP_HOME/js/packages/cli/src/candy-machine-v2-cli.ts upload \
    -e devnet \
    -k "$keypair" \
    -cp nft-config.json \
    -c $symbol \
     $cache | tee candy_upload.log
ts-node $MTP_HOME/js/packages/cli/src/candy-machine-v2-cli.ts mint_one_token \
    -e devnet \
    -k $keypair \
    -c $symbol | tee candy_mint_one.log
