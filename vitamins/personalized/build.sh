#

gw=https://ipfs.safewatch.xyz

find . -name "*~1" -delete
series=$(cat _data/personalized.yml | json_xs -f yaml -t string -e '$_=$_->{series}')
lot=$(cat _data/personalized.yml | json_xs -f yaml -t string -e '$_=$_->{lot}')
qmsrc=$(ipfs add -r . --ignore public -Q)

qmint=$(ipfs add -r ../intention/public -Q)
echo "intent.url: $gw/ipfs/$qmint"
qmvit=$(ipfs add -r -w ../S* -Q)
echo "vit.url: $gw/ipfs/$qmvit"
if [ ! -d ../distributed/${series} ]; then mkdir -p ../distributed/${series}; fi
qmseries=$(ipfs add -r -w ../distributed/${series} -Q)
echo "series.url: $gw/ipfs/$qmseries"
#rm ../distributed/$series/$lot.html
qmlot=$(ipfs add -w ../distributed/${series}/${lot}.* -Q)
echo "lot.url: $gw/ipfs/$qmlot"
tee _data/ipfs.yml <<EOF
qmsrc: $qmsrc
qmint: $qmint
qmvit: $qmvit
qmseries: $qmseries
EOF
echo "qmlot: $qmlot"

jekyll build -d public

# re-belotte ...
cp -p public/token.svg ../distributed/$series/$lot.svg
cp -p public/token.html ../distributed/$series/$lot.html
cp -p public/token.json ../distributed/$series/$lot.json
qmseries=$(ipfs add -r -w ../distributed/${series} -Q)
qmlot=$(ipfs add -w ../distributed/${series}/${lot}.* -Q)
cat > _data/ipfs.yml <<EOF
qmsrc: $qmsrc
qmint: $qmint
qmvit: $qmvit
qmseries: $qmseries
qmlot: $qmlot
EOF
jekyll build -d public 1>/dev/null 2>&1
cp -p public/token.svg ../distributed/$series/$lot.svg
cp -p public/token.html ../distributed/$series/$lot.html
cp -p public/token.json ../distributed/$series/$lot.json
qm=$(ipfs add -r public -Q);
qmroot=$(ipfs object patch add-link $qm src $qmsrc)
echo qmroot: $qmroot
echo "personalized.public: $qm"
gwport=$(ipfs config Addresses.Gateway | cut -d'/' -f 5)
ipfs pin remote rm --force --service=phenomx --name=distibuted-vit
ipfs pin remote add --service=phenomx --name=distibuted-vit $qm --background
echo url: http://127.0.0.1:$gwport/ipfs/$qmroot
echo url: https://nftstorage.link/ipfs/$qm/token.json
echo url: https://gateway.pinata.cloud/ipfs/$qm/token.json
echo url: https://ipfs.safewatch.care/ipfs/$qm/token.json
