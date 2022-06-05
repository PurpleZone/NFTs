#!/usr/bin/perl

use YAML::XS qw(Dump);
my $cfg = {
gctoken => "CZERo1zERhXQqGbMvWb9rJEsqNSujymo4UkJuUrkSR86",
cctoken => "CarBoNrDsrBtp4YgjuxjXQnrpaLDB4HoL2dDLBFUnZjq",
usrwallet => 'CarboNQ5A4gaVVhYt7foVdFraXRzV1ykWh5vutNHAoy7',
mintauth => "Fg2RSRChcR5m1x8wTJWYbA1GD6kcKytcQM12kDNApf37",
greenwl => "GreenMMudce22thwc1iG596982uEF74hge55GRfwmEQm",
recipient => "Fg2RSRChcR5m1x8wTJWYbA1GD6kcKytcQM12kDNApf37",
null => null
};
my $ownpair = sprintf "/keybase/private/%s/SOLkeys/%s.json",$ENV{USER},$cfg->{usrwallet};
my $mintpair = sprintf "/keybase/private/%s/SOLkeys/%s.json",$ENV{USER},$cfg->{mintauth};
# ------------------------------------------------------------------------------------------
#my $test = sprintf "spl-token create-account %s --owner %s --output json", $cfg->{gctoken},$cfg->{usrwallet},$cfg->{mintauth};
my $test = sprintf "spl-token balance %s --owner %s --output json", $cfg->{cctoken},$cfg->{usrwallet};
#my $test = sprintf "spl-token supply %s --output json", $cfg->{gctoken},$cfg->{usrwallet};
my $test = sprintf "spl-token transfer %s %s %s --fund-recipient --owner %s --output json", $cfg->{cctoken},"0.0001$$",$cfg->{recipient},$ownpair;
my $test = sprintf "spl-token balance %s --owner %s --output json", $cfg->{gctoken},$cfg->{recipient};
my $test = sprintf "spl-token balance %s --owner %s --output json", $cfg->{gctoken},$cfg->{usrwallet};
my $test = sprintf"spl-token supply %s --output json",$cfg->{gctoken};
# ------------------------------------------------------------------------------------------
printf "exec: %s\n",$test;
my $resp = &jsonresp($test);
printf "resp: %s\n",Dump($resp);

exit $?;


sub jsonresp {
   my $cmd = shift;
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
