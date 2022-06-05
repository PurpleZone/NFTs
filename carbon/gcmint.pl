#!/usr/bin/perl

# usage:
#  perl gcmint.pl CarboNQ5A4gaVVhYt7foVdFraXRzV1ykWh5vutNHAoy7
#  perl gcmint.pl FDhJEXbh4Hd79oREXUoAT1NkrcCF4W9SifaHv8HZ5r7H

my $cluster='devnet';
my $configf="config.yml";
use YAML::XS qw(LoadFile Dump);

my $nc = "\e[0m";
my $yellow = "\e[1;33m";
my $default = "\e[39m";
my $red = "\e[31m";
my $green = "\e[1;32m";
my $cyan = "\e[36m";
my $grey = "\e[0;90m";

local $/ = "\n";

my $cfg = LoadFile($configf);
my $wallet = '';
my $usrbal = 0;
if (@ARGV) {
   $wallet = shift;
} else {
   print "SOL wallet: ";
   $wallet = <STDIN>; chomp $wallet;
}
if ($wallet ne '') {
  printf "wallet: ",$wallet;
  $usrbal = &gettokenbal($cfg->{gctoken},$wallet);
  if ($usrbal eq '') {
     system sprintf "spl-token transfer %s 0 %s --fund-recipient\n",$cfg->{gctoken},$wallet;
  }
}

my $resp = &jsonresp(sprintf'spl-token account-info %s --output json',$cfg->{gctoken});
my $decimals = $resp->{tokenAmount}{decimals};
my $scale = 10**$decimals;
while (1) {
print '='x76,"\n";

my $qm = `ipfs add -w SOLwatchlet.log gcmint.* --progress=false -Q`; chomp $qm;


# ------------------------------------------------------------
my $btcwallet = $cfg->{btcwallet};
my $gcwallet = $gctoken = $cfg->{gctoken};
my $ccwallet = $cctoken = $cfg->{cctoken};
my $cfpwallet = $cfg->{cfpwallet};

my $burried = $cfg->{burried};
   $cfg->{usrwallet} = $wallet if ($wallet ne '');

my $energy = $cfg->{energy};
my $efprt = $cfg->{efprt}; # hydro energy footprint ~24g/kWh
my $btcco2 = $energy * $efprt; # kg
my $cpty = $cfg->{cpty}; # kg/tree.yr
my $cost = $cfg->{cost}; # USD per BTC

my $gcstate = LoadFile('gcstate.yml');
$gcstate->{usrbal} = $usrbal;
$usrbal = &gettokenbal($gctoken,$cfg->{usrwallet});
if ($usrbal != $gcstate->{usrbal}) {
  my $tic = time;
  my $date = &hdate(time);
  my $record = sprintf "%s: %s %s # %s %s\n",$tic,$cfg->{usrwallet},$usrbal*1000,'mBTC',$date;
  my $status = appendfile('SOLwatchlet.log',$record);
}
printf "--- gcstate: %s\n",Dump($gcstate);


# get trigger balances
my $changes = 0;
my $tic = time; my $date = &hdate($tic);
my $ccbal = &getmintbal($cctoken);
if ($ccbal != $gcstate->{ccbal}) {
   printf "ccbal: ${green}%s${nc} (was %s)\n",$ccbal,$gcstate->{ccbal};
   my $record = sprintf "%s: %s %s # %s %s\n",$tic,$cctoken,$ccbal,'kg',$date;
   my $status = appendfile('SOLwatchlet.log',$record);
   $changes++;
}
my $gcsupply = 0;
   $gcsupply = &getmintsupply($gctoken); # minted (no yet in circulation)
if ($gcsupply != $gcstate->{gcsupply}) {
   printf "gcsupply: ${green}%s${nc} (was %s)\n",$gcsupply,$gcstate->{gcsupply};
   $changes++;
}

my $gcbal = $gcstate->{gcbal};
my $burbal = $gcstate->{burbal};
my $btcbal = $gcstate->{btcbal};
my $satobal = $btcbal * 100_000_000;

if ($cfg->{trigger} || $changes != 0) {
   printf "getbalance: 'triggered'\n";
   $gcbal = &getmintbal($gctoken); # minted (no yet in circulation)
   my $record = sprintf "%s: %s %s # %s\n",$tic,$gctoken,$gcbal*1000,'mBTC';
   my $status = appendfile('SOLwatchlet.log',$record);
   $burbal = &gettokenbal($cctoken,$burried);
   my $record = sprintf "%s: %s %s # %s\n",$tic,$burried,$burbal,'kg';
   my $status = appendfile('SOLwatchlet.log',$record);
   $satobal = &getbtcbal($btcwallet);
   $btcbal = $satobal / 100_000_000;
   my $record = sprintf "%s: %s %s # %s %s\n",$tic,$btcwallet,$btcbal*1000,'mBTC',$date;
   my $status = appendfile('SOLwatchlet.log',$record);
}
my $qmsol = `ipfs add -w SOLwatchlet.log qm.log --progress=false -Q`; chomp $qmsol;

# detect changes
my $prevstate =`ipfs add gcstate.yml --progress=false -Q`; chomp $prevstate; 
my $curstate = <<EOT;
--- # gcstate
btcbal: $btcbal
gcsupply: $gcsupply
gcbal: $gcbal
ccbal: $ccbal
burbal: $burbal
EOT
my $status = &writefile('gcstate.yml',$curstate);
my $qmstate =`ipfs add gcstate.yml --progress=false -Q`; chomp $qmstate; 

my $mutpath=sprintf'/ipns/%s/%s/assets',$cfg->{nskey},$cfg->{usrwallet};
my $qmasset = qmresolve($mutpath);
printf "wallet: https://explorer.solana.com/address/%s/tokens?cluster=%s\n",$cfg->{usrwallet},$cluster;
printf "asset_url: https://ipfs.safewatch.xyz/ipfs/%s\n",$qmasset;
#
# ---------------------------------------
my $btcbal = $satobal / 100_000_000; # 8 decimals
my $credit = $ccbal / $btcco2; # in BTC
my $clean = $burbal / $btcco2; # in BTC
# ---------------------------------------
my $dirty = $btcbal - $clean;
my $amount = &min( int ( $dirty * $scale  + 0.99999 ) / $scale, $credit); # transferable ...
print "${red}",'-'x56,${nc},"\n";
printf "dirty: %s mBTC; %.6fkg CO2e\n",$dirty * 1000,$dirty * $btcco2;
printf "credit: ${green}%s mBTC${nc} %.6fkg CO2e\n",$credit * 1000, $ccbal;
printf "clean: %s mBTC %.6fkg CO2e\n",$clean * 1000, $burbal;
printf "amount: %s mBTC %.6fkg CO2e (usable)\n",$amount * 1000, $amount * $btcco2;
print "${red}",'-'x56,${nc},"\n";

# ---------------------------------------------
# detection changes, update, skip events ...
my $skip = 0;
my $update = 0;
if ($dirty > 0 && $credit > 0 && $btcbal > $clean) { print "flag: dirty!\n"; $update++; }
if ($cfg->{redo}) { print "flag: redo!\n"; $update++; }
if (! -e 'gcmint.md') { print "flag: gcmint\n"; $update = 1 }
if ($cfg->{trigger}) { print "flag: trigger\n"; $update++; }
if ($qmstate eq $prevstate) { print "flag: ${yellow}same qmstate${nc} (skip)\n"; $skip++; }
if ($cfg->{skip}) { print "flag: skip!\n";$skip++; }
printf "skip: %s\n",$skip;
printf "update: %s\n",$update;
if ($update <= 0 && $skip > 0) {
  printf "url: http://127.0.0.1:8390/ipns/%s/gcmint.htm\n",$cfg->{mutkey};
  printf "qmstate: %s # (%s change)\n",$qmstate, ($qmstate eq $prevstate) ? 'no' : 'some';
  if ($cfg->{delay} == 0) {
     printf "please: press enter to continue\n";
     my $ans = <STDIN>;
     if ($ans =~ /=/) {
       eval "$ans";
     }
  } else {
     printf "sleeping-for: %ssec\n",$cfg->{delay};
     sleep $cfg->{delay};
  }
  $cfg = LoadFile($configf);
  next;
}
# ---------------------------------------------

open MD,'>','gcmint.md';
printf MD "---\nlayout: default\n# config %s---\n",Dump($cfg);
printf MD qq'<meta charset="utf8"/>\n';
printf MD qq'<!-- qm: %s-->\n',$qm;
printf MD qq'## Carbon Zero System Status <span id=time></span>\n';
print  MD "\n";
print  MD "<div id=console></div>\n\n";

printf MD "[1]: https://explorer.solana.com/address/%s?cluster=%s\n",$cfg->{gcwallet},$cluster;
printf MD "[2]: https://blockchain.com/btc/address/%s\n",$cfg->{btcwallet};
printf MD "[3]: https://explorer.solana.com/address/%s?cluster=%s\n",$cfg->{ccwallet},$cluster;
printf MD "[4]: https://solscan.io/address/%s/tokens?cluster=%s\n",$cfg->{burried},$cluster;
printf MD "[5]: https://explorer.solana.com/address/%s/tokens?cluster=%s\n",$cfg->{usrwallet},$cluster;
printf MD "[6]: https://ipfs.safewatch.xyz/ipns/%s/%s/assets/CarbonZero-Certificate.pdf\n",$cfg->{nskey},$cfg->{usrwallet};
printf MD "[7]: https://ipfs.safewatch.xyz/ipfs/%s\n",$qmasset;
printf MD "[7m]: https://ipfs.safewatch.xyz/ipfs/%s/%s\n",$cfg->{nskey},$cfg->{usrwallet};
printf MD "[8]: https://ipfs.safewatch.xyz/ipfs/%s/SOLwatchlet.log\n",$qmsol;
printf MD "[9]: https://ipfs.safewatch.xyz/ipfs/%s/gcmint.htm\n",$qm;
printf MD "[10]: https://ipfs.safewatch.xyz/ipns/%s/gcmint.htm\n",$cfg->{mutkey};
printf MD "[cointraker]: https://www.cointracker.io/wallet/bitcoin?address=%s\n",$cfg->{btcwallet};
printf MD "[blockchair]: https://blockchair.com/bitcoin/address/%s\n",$cfg->{btcwallet};
printf MD "[bitref]: https://bitref.com/%s\n",$cfg->{btcwallet};
printf MD "[btc]: https://explorer.btc.com/btc/address/%s\n",$cfg->{btcwallet};
print  MD "\n";

printf MD "![CarbonZeroBitcoinLogo](%s)\n<style>img[alt=CarbonZeroBitcoinLogo] { width: 140px; float: right }</style>\n\n",
  'https://PurpleZone.github.io/NFTs/btcz/btc-z.svg';
printf MD "* 10mBTC: %0.4fkg CO2e\n",10*$btcco2/1000;
printf MD "* [__%s__][blockchair] balance: %s satoshi (%7fmBTC)\n",$btcwallet,$satobal,$satobal/100_000_000 * 1000;
printf MD "* Energy burn for %s BTC: %.4f kWh, %.4fkg CO2e (mining)\n",$btcbal,$cfg->{energy} * $btcbal,$cfg->{energy} * $btcbal * $cfg->{efprt};
printf MD "* previous block: [%s][9]\n",$qm;
printf MD "* head block: [%s][10]\n",$cfg->{mutkey};
print  MD "\n";

printf MD "### Accounts \n\n";
printf MD "* User Wallet: [%s][5]\n",$cfg->{usrwallet};
printf MD "   -   balance: __%.7f mBTC (%6f kg)__; [%s][5]\n",$usrbal * 1000,$usrbal * $btcco2,substr($cfg->{usrwallet},0,7);
printf MD "   -   Metadata: [%s][7]\n",$qmasset;
printf MD "   -   Certificate: [/%s/assets/certificate.pdf][6]\n",$cfg->{usrwallet};
printf MD "* CarbonZero Bitcoin Wallet: [%s][1] (reserve)\n",$cfg->{gcwallet};
printf MD "   -   balance: %.7f mBTC (%6f kg); [%s][1] \n",$gcbal*1000,$gcbal * $btcco2,substr($cfg->{gcwallet},0,7);
printf MD "* balance log: [SOLwatchlet.log][8]\n";
print  MD "\n";
printf MD "### Tokens\n\n";
printf MD "* Carbon Zero Bitcoin supply: %.10f BTC %6f kg; [%s][1] (total)\n",$gcsupply,$gcsupply * $btcco2,$cfg->{gcwallet};
printf MD "* Carbon Removed (Credit): __%6f kg__ (%.10f BTC); [%s][3]\n",$ccbal,$credit,$cfg->{ccwallet};
printf MD "* Past Emission Removed: %6f kg (%.10f BTC); [%s][4] (used)\n",$burbal,$clean,$burried;
printf MD qq'* see also carbon spot price: <a href="%s">%s</a>\n','https://carboncredits.com/carbon-prices-today/','carbon-prices-today';

printf MD "\n".'_'x 72 ."\n";
my $tic = time;
my $date = &hdate($tic);
printf MD "### Balances (on %s)\n\n",$date;

printf MD "* Bitcoin balance (BTC): %.7f mBTC %6f kg; [%s][2] (pool)\n",$btcbal*1000,$btcbal * $btcco2, $cfg->{btcwallet};
printf MD "* Uncertificed Bitcoin balance: __%.7f mBTC__ %6f kg; [%s][2] (mined)\n",$dirty*1000,$dirty * $btcco2, $cfg->{btcwallet};
printf MD "* Carbon Zero Bitcoin balance: %.7f mBTC %6f kg; [%s][1] (reserve)\n",$gcbal*1000,$gcbal * $btcco2,$cfg->{gcwallet};
printf MD "* Certified User Carbon Zero Bitcoin balance: %.7f mBTC (%6f kg); [%s][5] (user)\n",$usrbal * 1000,$usrbal * $btcco2,$cfg->{usrwallet};
my $nt; # trees required
my $footprint;

printf MD "* Carbon Footprint: %6f kg (%.10f BTC) (left)\n",$dirty * $btcco2,$dirty;

printf MD "\n".'_'x 72 ."\n";
printf MD "### Carbon Removal Status and Triggered Actions (oracle):\n\n";

if ($credit > 0 && $dirty > 0) {

   printf MD "* CarbonZero bitcoins: %.7f mBTC (%.3fkg)\n",$clean*1000,$clean * $btcco2;
   printf MD "* CarbonPositive (Uncertified) bitcoins: %.7f mBTC (%.3fkg)\n",$dirty*1000,$dirty * $btcco2;
   printf MD "* CarbonZero Reserve: %.7f mBTC (%.3fkg)\n",$gcbal*1000,$gcbal * $btcco2;
   printf MD "* Emission Removed (Credit):  %.7f mBTC (%.6fkg CO2e)\n",$credit*1000,$ccbal;
   printf MD "* steps for clean-up:\n";
   printf MD "   - minting: %.07f CarbonZero milliBitcoin (mBTC-Z)\n",$amount*1000;
   printf MD "   1. ``spl-token transfer %s %.09f %s --allow-unfunded-recipient --fund-recipient``\n",$cfg->{cctoken},$amount * $btcco2,$cfg->{burried};
   printf MD "   2. ``spl-token mint %s %.10f``\n",$cfg->{gctoken},$amount;
 #   printf "   - \\# spl-burn.sh %s %.09f\n",$cctoken,$amount * $btcco2;
 #   printf MD "   - reset: ``spl-burn.sh %s %.010f`` (after credit transfer)\n",$cfg->{gctoken},$gcbal + $amount;
   $footprint = ($dirty - $amount) * $energy * $efprt;
   $nt = int($footprint / $cpty + 1);
   printf MD "* remaining footprint: %.07f mBTC (%s trees needed)\n",$dirty - $amount,$nt;

} elsif ($dirty > 0) {
   $footprint = $dirty * $energy * $efprt;
   $nt = int($footprint / $cpty + 1);
   printf MD "\nThere are CarbonPositive (Uncertified) bitcoin left: %.10f BTC (removal cost: __%s USD__)\n",$dirty,$price;
} else {
   printf MD "\nStatus: CarbonZero bitcoin: %.10f BTC (%.1fkg CO2e)\n",$clean,$burbal;
}
if ($gcbal > 0) {
   printf MD "\n\`\`\`sh\nspl-token transfer %s %.10f %s --fund-recipient --allow-unfunded-recipient\n\`\`\`\n",$cfg->{gctoken},$gcbal,$cfg->{usrwallet};
}

if ($dirty - $amount > 0) {
   my $price = $cost * $dirty;
   my $footprint = ($dirty - $amount) * $energy * $efprt;
   my $nt = int($footprint / $cpty + 1);
   printf MD "\nactions:\n\n";
   printf MD "* plant: %s trees (%.6fkg CO2e)\n",$nt,$footprint;
   printf MD "  <br> estimated price: %.3f USD\n",$price;
   printf MD "* spl-token mint %s %s -- %s\n",$cctoken,$footprint,$cfg->{mintkey};
   printf MD "* spl-token transfer %s %s %s\n",$cfg->{cctoken},$footprint,$cfg->{burried};
}
printf MD "\n".'-'x 72 ."\n";

print MD <<EOT;
<script>
 if (location.href.match(/ipns/)) { // Auto refresh
   window.setTimeout(_=>{ location.reload(); }, 30_000);
 }
 let now = Date.now();
 let today = new Date(now);
 let ISOdate = today.toISOString();
 let [date,time] = ISOdate.split('T');
 console.log('date:',today)
 document.getElementById('time').innerText = time
</script>
EOT

close MD;
## create html
print "creating gcmint.htm\n";
system "pandoc gcmint.md -t html > gcmint.htm";
my $tic = time;
print "pushing file to ipfs\n";
my $qm=`ipfs add -w SOLwatchlet.log gcmint.* qm.log --progress=false -Q`; chomp $qm;
printf "url: https://ipfs.safewatch.xyz/ipfs/%s/gcmint.htm\n",$qm;
my $status = &appendfile('qm.log',sprintf"%s: %s\n",$tic,$qm);
printf "url: https://ipfs.safewatch.xyz/ipns/%s/gcmint.htm\n",$cfg->{mutkey};
if (fork() == 0) { system sprintf "ipfs name publish --key=%s %s --ipns-base b58mh --allow-offline",$cfg->{mutkey},$qm; exit 0}
printf "url: http://127.0.0.1:8390/ipns/%s/gcmint.htm\n",$cfg->{mutkey};

system sprintf "/usr/bin/xdg-open https://ipfs.safewatch.xyz/ipfs/%s/gcmint.htm\n",$qm;
sleep 2;

printf "note: credit %s, dirty: %s\n",$credit,$dirty;
if ($credit > 0 && $amount > 0) {
   print " ${green}minting ...${nc}\n";
   my $mintpair = sprintf "/keybase/private/%s/SOLkeys/%s.json",$ENV{USER},$cfg->{mintauth};

   my $cmd = sprintf "spl-token transfer %s %.09f %s --fee-payer %s", $cfg->{cctoken},$amount * $btcco2,$cfg->{burried},${mintpair};
   my $resp = jsonresp($cmd);

   my $resp = jsonresp(sprintf "spl-token account-info %s %s --output json", $cfg->{gctoken},$cfg->{usrwallet});
   if (! exists $resp->{address}) { # create associated account !
      my $cmd = sprintf "spl-token create-account %s --owner %s --output json",$cfg->{gctoken},$cfg->{usrwallet};
      my $status = jsonresp($cmd);
      printf "status: %s\n",Dump($status);
   }
   my $cmd = sprintf "spl-token mint %s %.10f --mint-authority %s -- %s",
               $cfg->{gctoken},$amount,$mintpair,$resp->{address};
   my $resp = jsonresp($cmd);
   $dirty -= $amount;
   sleep 10;
}
# reload config ... just in case
my $cfg = LoadFile($configf);
}


exit $?;

sub min { return ($_[0] > $_[1]) ? $_[1] : $_[0]; }

# -----------------------------------------------------------------------
sub hdate { # return HTTP date (RFC-1123, RFC-2822) 
  my ($time,$delta) = @_;
  my $stamp = $time+$delta;
  my $tic = int($stamp);
  #my $ms = ($stamp - $tic)*1000;
  my $DoW = [qw( Sun Mon Tues Wed Thur Fri Sat )];
  my $MoY = [qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec )];
  my ($sec,$min,$hour,$mday,$mon,$yy,$wday) = (gmtime($tic))[0..6];
  my ($yr4,$yr2) =($yy+1900,$yy%100);

  # Mon, 01 Jan 2010 00:00:00 GMT
  my $date = sprintf '%3s, %02d %3s %04u %2u:%02u:%02u GMT',
             $DoW->[$wday],$mday,$MoY->[$mon],$yr4, $hour,$min,$sec;
  return $date;
}
# -----------------------------------------------------------------------

sub getbtcbal($) {
 my $addr = shift;
 my $url = sprintf 'https://blockchain.info/balance?active=%s&testnet=1',$addr;
 my $resp = &get_obj($url);
 printf "--- # balance %s...\n",Dump($resp);
 return $resp->{$addr}{final_balance};
   
}

sub getmintsupply($) {
  my $supply= `spl-token supply $_[0]`;
  chomp $supply;
  chomp $supply;
  print "mintsup($_[0])=$supply\n";
  return $supply
}
sub getmintbal($) {
  my $bal= `spl-token balance $_[0]`;
  chomp $bal;
  chomp $bal;
  print "mintbal($_[0])=$bal\n";
  return $bal
}

sub gettokenbal($$) {
  #printf "spl-token balance $_[0] --owner $_[1]\n";
  my $bal= `spl-token balance $_[0] --owner $_[1]`;
  chomp $bal;
  chomp $bal;
  my $label = substr($_[0],0,6);
  if ($bal ne '') {
    print "tokenbal($_[1])=$bal $label\n";
  }
  return $bal
}

sub qmresolve($) {
 my $ipath = shift;
 my $url = sprintf 'http://127.0.0.1:5311/api/v0/name/resolve?arg=%s',$ipath;
 my $resp = &post_obj($url);
 my $qpath = $resp->{Path};
 my $qm = $qpath; $qm =~ s,/ipfs/,,;
 return $qm;
}

sub post_obj {
   my $url = shift;
   use LWP::UserAgent qw();
   my $ua = LWP::UserAgent->new();
   my $resp = $ua->post($url);
   if ($resp->is_success) {
      my $obj = &objectify($resp->content);
      return $obj;
   } else {
      warn "Couldn't get $url";
      return $resp;
   }
}
sub get_obj {
   my $url = shift;
   my $content = '400 Error';
   if ( iscached($url) ) {
     $content = get_cache($url);
   } else {
     use LWP::Simple qw(get);
     $content = get $url;
     warn "Couldn't get $url" unless defined $content;
     set_cache($url,$content);
   }
   my $obj = &objectify($content);
   return $obj;
}

sub objectify {
  my $content = shift;
  use JSON::XS qw(decode_json);
  if ($content =~ m/\}\n\{/m) { # nd-json format (stream)
    my $resp = [ map { &decode_json($_) } split("\n",$content) ] ;
    return $resp;
  } elsif ($content =~ m/^{/ || $content =~ m/^\[/) { # plain json]}
    #printf "[DBUG] Content: %s\n",$content;
    my $resp = &decode_json($content);
    return $resp;
  } elsif ($content =~ m/^--- /) { # /!\ need the trailing space
    use YAML::XS qw(Load);
    my $resp = Load($content);
    return $resp;
  } else {
    return $content;
  }
}

sub khash { # keyed hash
   use Crypt::Digest qw();
   my $alg = shift;
   my $data = join'',@_;
   my $msg = Crypt::Digest->new($alg) or die $!;
      $msg->add($data);
   my $hash = $msg->digest();
   return $hash;
}

sub iscached {
  my $url = shift;
  my $hash = &khash('SHA1','GET '.$url);
  my $file = sprintf 'cached/%s.dat',unpack'H*',$hash;
  if (-e $file) {
     my @times = sort { $a <=> $b } (lstat($file))[9,10]; # ctime,mtime
     my $elapsed = (time - $times[-1]);
     printf "elapsed: %d\n",$elapsed;
     return ($elapsed <  300 * 60) ? 1 : 0; # 5hr cache
  } else {
  return 0; # cache miss
  }
}
sub get_cache {
  my $url = shift;
  my $hash = &khash('SHA1','GET '.$url);
  my $file = sprintf 'cached/%s.dat',unpack'H*',$hash;
  printf "use-cache: %s\n",$file;
  my $content = &readfile($file);
  return $content;
}
sub set_cache {
  my $url = shift;
  my $data = shift;
  my $hash = &khash('SHA1','GET '.$url);
  my $file = sprintf 'cached/%s.dat',unpack'H*',$hash;
  my $status = &writefile($file,$data);
  return $status;
}

sub readfile { # Ex. my $content = &readfile($filename);
  #y $intent = "read a (simple) file";
  my $file = shift;
  if (! -e $file) {
    print "// Error: readfile.file: ! -e $file\n";
    return undef;
  }
  local *F; open F,'<',$file; binmode(F);
  local $/ = undef;
  my $buf = <F>;
  close F;
  return $buf;
}

sub writefile { # Ex. &writefile($filename, $data1, $data2);
  #y $intent = "write a (simple) file";
  my $file = shift;
  local *F; open F,'>',$file; binmode(F);
  print "# // storing file: $file\n";
  for (@_) { print F $_; }
  close F;
  return $.;
}

sub appendfile { # Ex. &appendfile($filename, $data1, $data2);
  #y $intent = "append dta to a (simple) file";
  my $file = shift;
  local *F; open F,'>>',$file; binmode(F);
  #print "# // append to file: $file\n";
  for (@_) { print F $_; }
  close F;
  return $.;
}



sub jsonresp {
   my $cmd = shift;
   printf "exec: |-\n ${cyan}%s${nc}\n",$cmd;
   local *EXEC;
   open EXEC,"$cmd|";
   local $/ = undef;
   my $buf = <EXEC>;
   close EXEC;
   use JSON::XS qw(decode_json);
   if ($buf !~ m/^{/) {
     return { error => $? };
   } else {
     my $obj = &decode_json($buf);
     return $obj;
   }
}

1;
