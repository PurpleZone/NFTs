
#rm -rf .cache
# url=https://metaplex.devnet.rpcpool.com/ 
export MTP_HOME=$HOME/clients/ideator/metaplex
yarn --version
ts-node $MTP_HOME/js/packages/cli/src/candy-machine-v2-cli.ts --version
cluster=devnet
cache=assets
configf=candy-config.json

# 1LP = 1nSOL
LAMPORT_PER_SOL=1000000000



c=$(date +%H);
cachename="cz-certificate-$c"



key=Fg2RSRChcR5m1x8wTJWYbA1GD6kcKytcQM12kDNApf37
keypair=${keypair:-$HOME/.config/solana/devnet.json}

reskey=RentbrxTJDHfk3r5Z46tVqaikjFhKci2FWjP9qLhh4s
rentpair=/keybase/private/$USER/SOLkeys/$reskey.json

tic=$(date +%s%N | cut -c-13)
solbal=$(solana balance $key | cut -d' ' -f1)
echo $tic: $key $solbal >> $XDG_CONFIG_HOME/solana/balance.yml


ns=$(date +%N | cut -c-8)
mod=$(expr $ns % 2)
if [ "$mod" = '1' ]; then
rpc_url=https://metaplex.$cluster.rpcpool.com/
else
rpc_url=https://api.$cluster.solana.com
fi
echo rpc_url: $rpc_url

solana config set -u $rpc_url
solana balance $key
#sol-airdrop.sh $key
qm=$(ipfs add -r $cache -Q)
echo url: https://ipfs.safewatch.xyz/ipfs/$qm

echo cachename=$cachename
if [ -e .cache/devnet-$cachename.json ]; then
cmid=$(json_xs < .cache/devnet-$cachename.json -t string -e '$_=$_->{program}{candyMachine}')
if [ "no$cmid" != 'no' ]; then
echo cmid: $cmid
fi

fi
