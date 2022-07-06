#
image=evitamin.svg
origin=${image%.*}-orig.svg
yamlf=${image%.*}.yml
file=$(cat $yamlf | json_xs -f yaml -t string -e '$_=$_->{file}')
echo file: $file
if [ -d intention ]; then
 rm -f intent.yml
cd intention;
find . -name '*~1' -delete
jekyll build -d public
intent=$(ipfs add -Q -r public)
cd ..
fi


echo "intent: $intent"
if [ ! -e intent.yml ]; then
perl -S intent.pl -i "$intent" > intent.yml
fi
seed=$(cat intent.yml | grep -w -e seed: | cut -d' ' -f2)
#seed=416638
echo seed: $seed




n=$(cat params.yml | json_xs -f yaml -t string -e '$_=$_->{n}+1')
lot=$(expr "$$" % $n)

echo lot: $lot / $n

echo "running: jitter $image $seed $lot"
jitter $image $seed $lot
exit $?;


