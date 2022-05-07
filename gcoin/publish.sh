#

symb=gcoin
mutkey=$(ipfs key list -l --ipns-base b58mh | grep -w $symb | cut -d' ' -f1)
ppath=$(ipfs name resolve $mutkey)
qmprev=${ppath#/ipfs/}
echo prev: $qmprev

find . -name '*~1' -delete
pandoc -t html -o factsheet.html factsheet.md
pandoc -t html -o README.html README.md
qm=$(ipfs add -w README.md gcoin.* *.pdf *.htm* *.png -Q)
echo url: https://ipfs.safewatch.xyz/ipfs/$qm

ipfs name publish --key=$symb $qm --ipns-base b58mh --allow-offline
ipfs pin remote add --service=nft --name=$symb --background $qm
echo url: https://nftstorage.link/ipfs/$qm
exit $?

