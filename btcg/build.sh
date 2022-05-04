#

symb=$(cat token-item.json | json_xs -t string -e '$_ = $_->{symbol}')
key=$(ipfs key list -l --ipns-base b58mh | grep -w -e $symb | cut -d' ' -f1)
echo key: $key

cat $symb.yml | json_xs -f yaml -t json > $symb.json
jsinc.pl $symb-tmpl.svg  > $symb.svg
inkscape --without-gui ${symb}.svg -w 256 -h 256 -o $symb.png
git add $symb-tmpl.svg $symb.js $symb.svg $symb.json $symb.png
git commit -a -m "$symb updated on $(date +%y-%m-%d)"
#git push 


