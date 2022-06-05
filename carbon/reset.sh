#

. ./rc.sh

greenwallet=GreenMMudce22thwc1iG596982uEF74hge55GRfwmEQm
usrkey=CarboNQ5A4gaVVhYt7foVdFraXRzV1ykWh5vutNHAoy7
usrpair=/keybase/private/$USER/SOLkeys/$usrkey.json

mickey=Fg2RSRChcR5m1x8wTJWYbA1GD6kcKytcQM12kDNApf37
micpair=/keybase/private/$USER/SOLkeys/$mickey.json

mintpair=/keybase/private/$USER/SOLkeys/$mintkey.json
burpair=/keybase/private/$USER/SOLkeys/$burried.json

# reset gctoken
bal=$(spl-token balance $gctoken)
if [ $bal \> 0 ]; then
spl-token transfer $gctoken $bal $greenwallet --fund-recipient --allow-unfunded-recipient
fi
bal=$(spl-token balance $gctoken --owner $usrkey)
if [ $bal \> 0 ]; then
spl-token transfer $gctoken $bal $greenwallet --fund-recipient --allow-unfunded-recipient --owner $usrpair 
fi
# reset credits
bal=$(spl-token balance $cctoken)
if [ $bal \> 0 ]; then
spl-token transfer $cctoken $bal $greenwallet --allow-unfunded-recipient --owner $micpair 
fi
# reset burried
bal=$(spl-token balance $cctoken --owner $burried)
if [ $bal \> 0 ]; then
spl-token transfer $cctoken $bal $greenwallet --allow-unfunded-recipient --owner $burpair
fi
# reset burried
tic=$(date +%s%N | cut -c-13)
echo "$tic: $burried 0.00000000 # reset !" >> SOLwatchlet.log


spl-token balance $gctoken


# adjust trees 
nt=$(spl-token balance $trtoken --owner $usrwallet)
echo "trees: $nt"
if false; then
delta=$(echo "$nt - 3" | bc -q)
if [ $delta \> 0 ]; then
echo "delta: $delta"
spl-token transfer $trtoken $delta $greenwallet --allow-unfunded-recipient --owner $usrpair
fi
fi

rm gcmint.md
