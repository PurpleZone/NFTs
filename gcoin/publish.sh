#

symb=gcoin
mutkey=$(ipfs key list -l --ipns-base b58mh | grep -w $symb | cut -d' ' -f1)
ppath=$(ipfs name resolve $mutkey)
qmprev=${ppath#/ipfs/}
echo prev: $qmprev

pandoc -t html -o README.html README.md
qm=$(ipfs add -w README.md gcoin.* *.pdf *.htm* -Q)
echo url: https://nftstorage.link/ipfs/$qm

ipfs name publish --key=$symb $qm --allow-offline
ipfs pin remote add --service=nft --name=$symb --background $qm
exit $?

