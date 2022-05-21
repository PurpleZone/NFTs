#!/usr/bin/perl

use YAML::XS qw(Dump);
use JSON::XS qw(decode_json);


my $prices = &initTab();
#printf "prices: %s---\n",Dump($prices);

my $amount = shift;
my $priceBTC = $prices->{BTC}{price};
my $priceETH = $prices->{ETH}{price} || 1;
printf "%s BTC = %f ETH\n",$amount,$amount * $priceBTC / $priceETH;
exit $?; 


sub initTab {
my $content = &readfile('coinset.json');
my $coinset = decode_json($content);
  my $tab = {};
  foreach my $coin (@{$coinset->{data}{coins}}) {
    my $symbol = $coin->{symbol};
    my $name = $coin->{name};
    my $price = $coin->{price};
    #print "name: $name; price: $price\n";
    $tab->{$symbol} = { name => $name, price => $price };
  }
  return $tab;
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

1;
