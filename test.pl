#!/usr/bin/perl -w
# 444Hw9q - test.pl created by Pip Stuart <Pip@CPAN.Org> to validate 
#     Games::Cards::Poker functionality.
#   Before `make install' is performed this script should be run with
#     `make test'.  After `make install' it should work as `perl test.pl'.

BEGIN { $| = 1; print "0..15\n"; }
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

$result = ScoreHand(@hand);
&report($result == 5552 , "$result\n");

my @hol0 = qw( As Ac );
my @hol1 = qw( Ad Kh );
my @hol2 = qw( Ah Kd );
my @bord = qw( 9s 3d Ks );
my @best = BestHoldEmIndices(@hol0, @bord);
my @crdz = @hol0; push(@crdz, @bord);
   @hand = (); foreach(@best) { push(@hand, $crdz[$_]); }
$result = ScoreHand(@hand);
&report($result == 3357 , "$result\n");

#$result = ScoreHand(BestHoldEmHand(BestHoldEmIndices(@hol0, @bord), @hol0, @bord));
#&report($result == 3357 , "$result\n");

$result = ScoreHand(BestHoldEmHand(@hol0, @bord));
&report($result == 3357 , "$result\n");

$result = ScoreHand(BestHoldEmHand(@hol1, @bord));
&report($result == 3577 , "$result\n");

$result = ScoreHand(BestHoldEmHand(@hol2, @bord));
&report($result == 3577 , "$result\n");

   @bord = qw( 9s 3d Ks 3c );
$result = ScoreHand(BestHoldEmHand(@hol0, @bord));
&report($result == 2577 , "$result\n");

$result = ScoreHand(BestHoldEmHand(@hol1, @bord));
&report($result == 2698 , "$result\n");

$result = ScoreHand(BestHoldEmHand(@hol2, @bord));
&report($result == 2698 , "$result\n");

#   @bord = qw( 9s 3d Ks 3c Kc );
#$result = ScoreHand(BestHoldEmHand(@hol0, @bord));
#&report($result == 2470 , "$result\n");
#
#$result = ScoreHand(BestHoldEmHand(@hol1, @bord));
#&report($result ==  188 , "$result\n");
#
#$result = ScoreHand(BestHoldEmHand(@hol2, @bord));
#&report($result ==  188 , "$result\n");
