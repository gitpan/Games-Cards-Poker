#!/usr/bin/perl -w
# 444Hw9q - test.pl created by Pip Stuart <Pip@CPAN.Org> to validate 
#     Games::Cards::Poker functionality.
#   Before `make install' is performed this script should be run with
#     `make test'.  After `make install' it should work as `perl test.pl'.

BEGIN { $| = 1; print "0..7\n"; }
END   { print "not ok 1\n" unless($loaded); }
use Games::Cards::Poker;

my $calc; my $result; my $TESTNUM = 0;
$loaded = 1;
&report(1);

sub report { # prints test progress
  my $bad = !shift;
  print "not " x $bad;
  print "ok ", $TESTNUM++, "\n";
  print @_ if $ENV{TEST_VERBOSE} and $bad;
}

my @deck = Deck();
$result = $deck[0];
&report($result eq 'As' , "$result\n");

$result = $deck[3];
&report($result eq 'Ac' , "$result\n");

$result = $deck[4];
&report($result eq 'Ks' , "$result\n");

$result = $deck[51];
&report($result eq '2c' , "$result\n");

my @hand = qw( 4c 9d Td 4s Ah );
SortCards(\@hand);
$result = $hand[0];
&report($result eq 'Ah' , "$result\n");

$result = $hand[1];
&report($result eq 'Td' , "$result\n");

$result = ShortHand(@hand);
&report($result eq 'AT944' , "$result\n");
