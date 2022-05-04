#

if [ -e token-item.json ];then
symb=$(cat token-item.json | json_xs -t string -e '$_ = $_->{symbol}')
else
symb=eo-coin
fi
if ! ipfs key list | grep -w $symb; then
key=$(ipfs key gen -t rsa -s 3072 --ipns-base b58mh $symb)
else
key=$(ipfs key list -l --ipns-base b58mh| grep -w $symb | cut -d' ' -f1)
fi
echo key: $key

cat $symb.yml | json_xs -f yaml -t json > $symb.json

find . -name '*~1' -delete
qm=$(ipfs add -r . -Q)
ipfs name publish --key=$symb $qm


