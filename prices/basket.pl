#!/usr/bin/perl

use YAML::XS qw(Dump);

my $weight = {};
my $crypt = [ qw( SOL BTC ETH MYC ) ]; @{$weight}
{@{$crypt}} = qw( 0.1 0.5 0.1 0.3 );
printf "weight: %s...\n",Dump($weight);
exit $?;


my $content = &readfile('coinset.json');
my $coinset = decode_json($content);

my $tab = {};
foreach my $coin (@$coinset->{data}{coins}) {
    my $symbol = $coin->{symbol};
    my $name = $coin->{name};
    my $price = $coin->{price};
    $tab->{$symbol} = { name => $name, price => $price }
}
foreach my $coin (@$crypt) {
  if (exists $tab->{$coin}) {
    printf $coin->{name}
  }
}

