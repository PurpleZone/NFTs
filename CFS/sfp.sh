#

cat $1 | json_xs -t json | ipfs add --raw-leaves --cid-base base58btc
