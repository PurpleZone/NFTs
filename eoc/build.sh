#

if [ -e token-item.json ];then
symb=$(cat token-item.json | json_xs -t string -e '$_ = $_->{symbol}')
else
symb=eo-coin
fi
echo symb: $symb
if ! ipfs key list | grep -w $symb >/dev/null; then
key=$(ipfs key gen -t rsa -s 3072 --ipns-base b58mh $symb)
else
key=$(ipfs key list -l --ipns-base b58mh| grep -w $symb | cut -d' ' -f1)
fi
echo key: $key

cat $symb.yml | json_xs -f yaml -t json > $symb.json
jsinc.pl $symb-tmpl.svg  > $symb.svg
inkscape --without-gui ${symb}.svg -w 256 -o $symb.png

pandoc --template=README.md README.md | pandoc -f markdown -t html --template=layout.htm -o factsheet.html



find . -name '*~1' -delete
qm=$(ipfs add -r . -Q)
ipfs name publish --key=$symb --ipns-base b58mh $qm

git add $symb-tmpl.svg $symb.js $symb.svg $symb.json $symb.png
git commit -uno -m "$symb updated on $(date +%y-%m-%d)"
