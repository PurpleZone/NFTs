#

. ./rc.sh
userwallet=${1:-$usrwallet}
gcbal=$(spl-token balance $gcwallet)
usrbal=$(spl-token balance $gctoken --owner $userwallet)
btcbal=$(perl getbtcbal.pl $btcwallet | json_xs -f yaml -t string -e "\$_ = \$_->{'$btcwallet'}{final_balance} / 100_000000")
ccbal=$(spl-token accounts $cctoken | tail -2)
burbal=$(spl-token accounts $cctoken --owner $burried | tail -2)

cat > gcstate.yml~ <<EOT
--- # gcstate
btcbal: $btcbal
gcbal: $gcbal
ccbal: $ccbal
burbal: $burbal
EOT
cat gcstate.yml~
echo usrbal: $usrbal
diff gcstate.yml gcstate.yml~
