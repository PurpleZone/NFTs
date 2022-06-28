#!perl

my $traits = [];
foreach my $a (@{$_->{attributes}}) {
  my $type = (keys %$a)[0];
  my $trait_type = $type; $trait_type =~ s/_/ /g;
  my $value = $a->{$type};
  push @{$traits}, { trait_type => $trait_type, value => $value };
}
$_->{attributes} = $traits;


