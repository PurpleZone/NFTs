#

intent="mint $1 to $2 wallet"

amount=$1
addr=$2

if [ "0$amount" = '0' ]; then
  amount=$(random.pl 48)
fi
tokenid=67LFyGDurTaN6TKtZaa8YyrYscKBc8rtA63a4vzMaJuD
tokenid=E6ScSUwK7ZV4ZuvVaYVHQGby93uKs9WUtpwngZjAjCKA

key=6NvHFsKtPZ2GETwYKiJVXk9h9ShxMYwThp3xMXYCvjZq
mintauth=6NvHFsKtPZ2GETwYKiJVXk9h9ShxMYwThp3xMXYCvjZq


keypair=/keybase/private/$USER/SOLkeys/$key.json
mintpair=/keybase/private/$USER/SOLkeys/$mintauth.json

cluster=devnet
solana config set -k $keypair
rpc_url=https://api.$cluster.solana.com
solana config set -u $rpc_url

solana address
solana balance  -u devnet


opt="--allow-unfunded-recipient --fund-recipient"
account=$(spl-token account-info $tokenid $addr | json_xs -f yaml -t string -e '$_=$_->{Address}')
if [ "x$account" = 'x' ]; then
spl-token create-account $tokenid --fee-payer $mintpair --owner $addr
account=$(spl-token account-info $tokenid $addr | json_xs -f yaml -t string -e '$_=$_->{Address}')
#spl-token transfer $opt $tokenid $amount --with-memo "Welcome to Eden Alliance" $account 
else
echo status: $?
#spl-token mint $tokenid $amount --mint-authority $mintpair -- --owner $addr
fi
echo "minting: $amount $account"
spl-token mint $tokenid $amount --mint-authority $mintpair -- $account

spl-token balance $tokenid --owner $addr

spl-token accounts --owner $addr
