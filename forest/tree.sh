#
tic=$(date +%s%N | cut -c-13)

top=$(git rev-parse --show-toplevel)
configf=$top/carbon/config.yml
eval $(cat $configf | eyml)

crpty=${cpty:-21}
tokenid=CarBoNrDsrBtp4YgjuxjXQnrpaLDB4HoL2dDLBFUnZjq
usrwallet=${usrwallet:-CarboNQ5A4gaVVhYt7foVdFraXRzV1ykWh5vutNHAoy7}
mintkey=Fg2RSRChcR5m1x8wTJWYbA1GD6kcKytcQM12kDNApf37
keypair=/keybase/private/$USER/SOLkeys/$usrwallet.json
mintpair=/keybase/private/$USER/SOLkeys/$mintkey.json
speed=${speed:-1}

if [ "x$1" != 'x']; then
  destwallet=${1:-$usrwallet}
fi

pt=$(echo "3600 * 365.25 * 24" | bc -q)
echo "pt: $pt" # tree period 

# carbon per minutes.tree (mg)
crpmt=$(echo "scale=5; 60 * $crpty * 1000000 / $pt" | bc -q)
echo cr/m.t: ${crpmt}mg / minute.tree

pspeed=1
while true; do
addr=$(spl-token account-info $tokenid $destwallet --output json | json_xs -t string -e '$_=$_->{address}')
echo "addr: $addr"
eval $(cat $configf | eyml)
if [ "$speed" != "$pspeed" ]; then tic=$(date +%s%N | cut -c-13); fi
pspeed=$speed

nt=$(spl-token balance $trtoken --owner $usrwallet)
echo "n-trees: $nt"
echo "destination: $destwallet"

now=$(date +%s%N | cut -c-13)
elapse=$(echo "$now - $tic" | bc -q)
#echo "scale=16; ($elapse * $nt * $crpty) / $pt / 1000"
cr=$(echo "scale=16; $speed * ($elapse * $nt * $crpty) / $pt / 1000" | bc -q -l)

echo "cr: ${cr}kg for ${elapse} ms at ${speed}x speed"

if [ $(echo "$cr > 1.000000" | bc -l) = '1' ]; then
tic=$now
spl-token mint $tokenid $cr --mint-authority $mintpair -- $addr
#spl-token mint $tokenid $cr
echo .
fi
ccbal=$(spl-token balance $cctoken --owner $destwallet)
if [ $(echo "$ccbal > 40" | bc -q) = '1' ]; then
  echo "ccbal: $ccbal"
  break
fi
delay=10
echo "sleep for ${delay}s"
sleep $delay
done



