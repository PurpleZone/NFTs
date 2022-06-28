#

# https://token-creator-lac.vercel.app/ 

top=$(git rev-parse --show-toplevel)
name=${PWD##*/}
echo "name: $name"
image=${1:-token.svg}
mint=3vWrgWxvTi3sW9ecaF83MzqavSbdrmr5UreLe7digWXX

png=${image%.*}.png
json=${image%.*}.json
find . -name "*~1" -delete
inkscape --without-gui ${image} -w 1170 -o ${png}
key=$(ipfs key list -l --ipns-base b58mh | grep -w $name | cut -d' ' -f1)

json_xs < $json -e "\$_->{attributes}[1]{value} = '$key'" -e "\$_->{mint} = '$mint'" > metadata.json


git add $image $png $json index.md metadata.json
tic=$(date +%s%N | cut -c-13)
git user
git commit -a -uno -m "${image%.*} @$tic"
git push
echo uri: https://purpleZone.github.io/NFTs/generic/metadata.json
