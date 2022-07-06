#

gw=https://ipfs.safewatch.xyz

find . -name "*~1" -delete
series=$(cat _data/personalized.yml | json_xs -f yaml -t string -e '$_=$_->{series}')
lot=$(cat _data/personalized.yml | json_xs -f yaml -t string -e '$_=$_->{lot}')

qmint=$(ipfs add -r ../intention/public -Q)
echo "int.url: $gw/ipfs/$qmint"
qmvit=$(ipfs add -r -w ../S* -Q)
echo "vit.url: $gw/ipfs/$qmvit"
qmseries=$(ipfs add -r -w ${series} -Q)
echo "series.url: $gw/ipfs/$qmseries"
#rm $series/$lot.html
qmlot=$(ipfs add -w ${series}/${lot}.* -Q)
echo "lot.url: $gw/ipfs/$qmlot"
tee _data/ipfs.yml <<EOF
qmint: $qmint
qmvit: $qmvit
qmseries: $qmseries
EOF
echo "qmlot: $qmlot"

jekyll build -d public

# re-belotte ...
cp -p public/token.html $series/$lot.html
cp -p public/token.json $series/$lot.json
qmseries=$(ipfs add -r -w ${series} -Q)
qmlot=$(ipfs add -w ${series}/${lot}.* -Q)
cat > _data/ipfs.yml <<EOF
qmint: $qmint
qmvit: $qmvit
qmseries: $qmseries
qmlot: $qmlot
EOF
jekyll build -d public 1>/dev/null 2>&1
cp -p public/token.html $series/$lot.html
cp -p public/token.json $series/$lot.json

qm=$(ipfs add -r public -Q);
echo "distributed.public: $qm"
gwport=$(ipfs config Addresses.Gateway | cut -d'/' -f 5)
ipfs pin remote add --service=phenomx --name=distibuted-vit $qm --background
echo url: http://127.0.0.1:$gwport/ipfs/$qm
echo url: https://nftstorage.link/ipfs/$qm/token.json
echo url: https://gateway.pinata.cloud/ipfs/$qm/token.json
echo url: https://ipfs.safewatch.care/ipfs/$qm/token.json
