#

image=evitamin.svg
origin=${image%.*}-orig.svg
yamlf=${image%.*}.yml
jsonf=${image%.*}.json
#cat $yamlf | json_xs -f yaml > $jsonf

file=$(cat $yamlf | json_xs -f yaml -t string -e '$_=$_->{file}')
usrwallet=$(cat $yamlf | json_xs -f yaml -t string -e '$_=$_->{recipient}')
title=$(grep -P -e '\w:' $file | json_xs -f yaml -t string -e '$_=$_->{title}')

json=${file%.*}.json
qmhash=$(ipfs add -w $file $json $origin -Q)

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

nskey=$(ipfs key list -l | grep -w ${image%.*} | cut -d' ' -f1)
qmid=$(ipfs add $yamlf -Q)
cat > nft-mutable.yml <<EOT
--- # evitamin parameters
SOL_Wallet: $usrwallet
nskey: $nskey
qmid: $qmid
intent: $intent
desc: "$title"
symbol: "$symbol"
initials: "$initials"
series: "S$seed"
sig: $sig
n: $n
EOT
qmhash=$(ipfs add -w $file $json $origin nft-mutable.yml -Q)
echo qmhash: $qmhash | cat nft-meta.yml params.yml $yamlf nft-mutable.yml - | grep -v '^---'| \
perl -S setnftattributes.pl $jsonf | json_xs | grep ini
# create json, tmpl.svg, svg
echo qmhash: $qmhash | cat nft-meta.yml params.yml $yamlf nft-mutable.yml - | grep -v '^---'| \
perl -S setnftattributes.pl $jsonf > $assets/0.json
perl -S jsonapply.pl $assets/0.json $origin spl-token-templ.svg
perl -S jsinc.pl spl-token-templ.svg  > $image

echo "qmhash: $qmhash" | cat nft-meta.yml params.yml $yamlf nft-mutable.yml -
jitter $image $sig $intent


find $cache -name '*~1' -delete
cp -p S$seed/PNGs/${image%.*}-sig.png $assets/0.png
qm=$(ipfs add -r -w $assets $file -Q)
ipfs pin remote add --service=nft --name=$symbol-$sig $qm --background
curl -I "https://ipfs.safewatch.xyz/ipfs/$qm" | grep -i Etag
echo "https://gateway.pinata.cloud/ipfs/$qm"

set -xe
if grep -q keypair: $yamlf; then
keypair=$(cat $yamlf | json_xs -f yaml -t string -e '$_=$_->{keypair}')
fi
wallet=$(solana address -k $keypair)
echo "wallet: $wallet"
solbal=$(solana balance  -u devnet $wallet | cut -d' ' -f1)
if [ $(echo "$solbal < 1.0" | bc -l) = '1' ]; then
solana airdrop 1.9997 $wallet
else
sol-airdrop.sh $wallet
fi

livedate=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
grep -v '^#' > nft-config.json <<EOF
{
"price": "0.001",
"number": 1,
"gatekeeper": null,
"solTreasuryAccount": "$wallet",
"splTokenAccount": null,
"splToken": null,
"goLiveDate": "$livedate",
"endSettings": null,
"whitelistMintSettings": null,
"hiddenSettings": null,
#"storage": "pinata",
"storage": "nft-storage",
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

#exit;

cluster=devnet
cachename=$symbol
phxkey=phxH6DzoPNkMDTMTqKHdSjwUxoEgjjDTw8xZXDzgVZ8
keypair=${keypair:-/keybase/private/$USER/SOLkeys/$phxkey.json}
export MTP_HOME=$HOME/clients/ideator/metaplex

connect.sh 
echo "https://ipfs.safewatch.xyz/ipfs/$qm/assets/"
curl -I "https://ipfs.safewatch.xyz/ipfs/$qm/assets/0.json" | grep -i Etag
curl -I "https://gateway.pinata.cloud/ipfs/$qm/assets/0.png" | grep -i Etag &

set -e
trial=1
# upload (creating the candy machine)
cachename=$symbol-$trial
while [ "$trial" \> 0 ]; do
    echo cachename: $cachename
ts-node $MTP_HOME/js/packages/cli/src/candy-machine-v2-cli.ts upload \
    -e $cluster -l debug -nc\
    -k "$keypair" \
    -cp nft-config.json \
    -c $cachename \
     $assets | tee candy_upload.log
  if grep -q -i -e 'Successful = false' candy_upload.log; then
    trial=$(expr "$trial" + 1)
    cachename=$symbol-$trial
    echo "trial: $trial"
  else
    break
  fi
done
cmid=$(cat .cache/devnet-$cachename.json | json_xs -t string -e '$_ = $_->{program}{candyMachine}')
echo "cmid: $cmid"
link=$(cat .cache/devnet-$cachename.json | json_xs -t string -e '$_ = $_->{items}{0}{link}')
echo "link: $link"
cat .cache/devnet-$cachename.json | json_xs -t yaml > candy_machine.yml
# verify
ts-node $MTP_HOME/js/packages/cli/src/candy-machine-v2-cli.ts verify_upload \
    -e $cluster -k $keypair \
    -c $cachename | tee candy_verify.log

ts-node $MTP_HOME/js/packages/cli/src/candy-machine-v2-cli.ts mint_one_token \
    -e $cluster -l debug \
    -k $keypair \
    -c $symbol | tee candy_mint_one.log

sig=$(grep mint_one candy_mint_one.log | tail -1 | cut -d' ' -f3)
echo sig: $sig

nft=$(solana confirm -v --output json $sig | json_xs -t string -e '$_=$_->{transaction}{message}{accountKeys}[1]')
echo nft: $nft;

spl-token transfer $nft 1 $usrwallet --owner $keypair --fund-recipient --allow-unfunded-recipient



ts-node $MTP_HOME/js/packages/cli/src/candy-machine-v2-cli.ts withdraw_all -k $keypair

