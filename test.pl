#!/usr/bin/perl -w
# 444Hw9q - test.pl created by Pip Stuart <Pip@CPAN.Org> to validate 
#     Games::Cards::Poker functionality.
#   Before `make install' is performed this script should be run with
#     `make test'.  After `make install' it should work as `perl test.pl'.

BEGIN { $| = 1; print "0..15\n"; }
END   { print "not ok 1\n" unless($loaded); }
use Games::Cards::Poker;

my $dbug = 1; my $calc; my $result; my $TESTNUM = 0;
$loaded  = 1;
&report(1);

sub report { # prints test progress
  my $bad = !shift;
  print "not " x $bad;
  print "ok ", $TESTNUM++, "\n";
  print @_ if(($ENV{TEST_VERBOSE} || $dbug) and $bad);
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
my @best = BestIndices(@hol0, @bord);
my @crdz = @hol0; push(@crdz, @bord);
   @hand = (); foreach(@best) { push(@hand, $crdz[$_]); }
$result = ScoreHand(@hand);
&report($result == 3357 , "$result\n");

#$result = ScoreHand(BestHand(BestIndices(@hol0, @bord), @hol0, @bord));
#&report($result == 3357 , "$result\n");

$result = ScoreHand(BestHand(@hol0, @bord));
&report($result == 3357 , "$result\n");

$result = ScoreHand(BestHand(@hol1, @bord));
&report($result == 3577 , "$result\n");

$result = ScoreHand(BestHand(@hol2, @bord));
&report($result == 3577 , "$result\n");

   @bord = qw( 9s 3d Ks 3c );
$result = ScoreHand(BestHand(@hol0, @bord));
&report($result == 2577 , "$result\n");

$result = ScoreHand(BestHand(@hol1, @bord));
&report($result == 2698 , "$result\n");

$result = ScoreHand(BestHand(@hol2, @bord));
&report($result == 2698 , "$result\n");

#print "  15 done!\n";
#   @bord = qw( 9s 3d Ks 3c Kc );
#$result = ScoreHand(BestHand(@hol0, @bord));
#&report($result == 2470 , "$result\n");
#
#$result = ScoreHand(BestHand(@hol1, @bord));
#&report($result ==  188 , "$result\n");
#
#$result = ScoreHand(BestHand(@hol2, @bord));
#&report($result ==  188 , "$result\n");
#
#$result = ScoreHand('AT944');
#&report($result == 5552 , "$result\n");
#
#$result = ScoreHand('AT943s');
#&report($result ==  708, "$result\n");
#
#@hand = qw( As Ts 9s 4s 4h );
#$result = ScoreHand(\@hand);
#&report($result ==  5552, "$result\n");
#
#$hand[4] = '3s';
#$result = ScoreHand(\@hand);
#&report($result ==  708, "$result\n");
#
#$result = HandScore(5552);
#&report($result eq 'AT944', "$result\n");
#$result = HandScore(708);
#&report($result eq 'AT943s', "$result\n");
#$result = HandScore(0);
#&report($result eq 'AKQJTs', "$result\n");
#$result = HandScore(7459);
#&report($result eq '76532', "$result\n");
#print "pre27\n";
#$result = ScoreHand('65542');
#&report($result == 5522, "$result\n");
#$result = ScoreHand('65532');
#&report($result == 5523, "$result\n");
#$result = ScoreHand('55432');
#&report($result == 5524, "$result\n");
#$result = ScoreHand('AKQ44');
#&report($result == 5525, "$result\n");
#print "pre31\n";
#$result = ScoreHand('65442');
#&report($result == 5742, "$result\n");
#$result = ScoreHand('64432');
#&report($result == 5743, "$result\n");
#$result = ScoreHand('54432');
#&report($result == 5744, "$result\n");
#$result = ScoreHand('AKQ33');
#&report($result == 5745, "$result\n");
#print "pre35\n";
#$result = ScoreHand('65332');
#&report($result == 5962, "$result\n");
#$result = ScoreHand('64332');
#&report($result == 5963, "$result\n");
#$result = ScoreHand('54332');
#&report($result == 5964, "$result\n");
#$result = ScoreHand('AKQ22');
#&report($result == 5965, "$result\n");
#print "pre39\n";
#$result = ScoreHand('65322');
#&report($result == 6182, "$result\n");
#$result = ScoreHand('64322');
#&report($result == 6183, "$result\n");
#$result = ScoreHand('54322');
#&report($result == 6184, "$result\n");
#$result = ScoreHand('AKQJ9');
#&report($result == 6185, "$result\n");
#
#for(my $i=0;$i<=7459;$i++){
#  $result = HandScore($i);
#  if(ScoreHand($result) != $i) {
#    for(my $j=-2;$j<=2;$j++) {
#      if(($i + $j) <= 7459) {
#        $result = HandScore($i + $j);
#        printf("!*EROR*! i:%4d != scor:%4d  shrt:$result!\n", ($i+$j), ScoreHand($result));
#      }
#    }
#    last;
#  }
#}
#
#print "pre43\n";
## what needs to sort:
##  'A'..'2'
##  'As'..'Ac'
##  'AA','AKs','AK'..'A2'
##  'AAA','AAK'..'AKQs','AKQ'..'222'
##  'AAAAK','AAAAQ'..'AKQJTs','AKQJT'..'32222' # based on rank values not scores
#@hand = qw( A K J 9 Q T 7 );
#$result = ShortHand(SortCards(\@hand));
#&report($result eq 'AKQJT97', "$result\n");
#@hand = Deck();
#$result = ShortHand(SortCards(\@hand));
#&report($result eq 'AAAAKKKKQQQQJJJJTTTT99998888777766665555444433332222', "$result\n");
#@hand = Shuffle(Deck());
#$result = ShortHand(SortCards(\@hand));
#&report($result eq 'AAAAKKKKQQQQJJJJTTTT99998888777766665555444433332222', "$result\n");
#@hand = qw( AA AQ AQs AKs A2 A2s K2 22 AK );
#SortCards(\@hand);
#$result = "@hand"; 
#&report($result eq 'AA AKs AK AQs AQ A2s A2 K2 22', "$result\n");
#print "pre47\n";
#@hand = qw( A32 AKQ 222 AAQ A32s AAK AAA AKQs );
#SortCards(\@hand);
#$result = "@hand"; 
#&report($result eq 'AAA AAK AAQ AKQs AKQ A32s A32 222', "$result\n");
#@hand = qw( A5432 AKQJT 32222 AAAAQ AKQJTs A5432s AAAAK );
#SortCards(\@hand);
#$result = "@hand"; 
#&report($result eq 'AAAAK AAAAQ AKQJTs AKQJT A5432s A5432 32222', "$result\n");
#
#$result = CardName('As');
#&report($result eq 'Ace of Spades', "$result\n");
#$result = NameCard($result);
#&report($result eq 'As', "$result\n");
#
#print "pre51\n";
#$result = CardName('2c');
#&report($result eq 'Two of Clubs', "$result\n");
#$result = NameCard($result);
#&report($result eq '2c', "$result\n");
#
#$result = HandName(0);
#&report($result eq 'Royal Flush', "$result\n");
#$result = HandName('AKQJTs');
#&report($result eq 'Royal Flush', "$result\n");
#print "pre55\n";
#$result = HandName(qw( Jh Kh Th Ah Qh ));
#&report($result eq 'Royal Flush', "$result\n");
#@hand = qw( Jh Kh Th Ah Qh );
#$result = HandName(\@hand);
#&report($result eq 'Royal Flush', "$result\n");
#
#$result = HandName(1);
#&report($result eq 'Straight Flush', "$result\n");
#$result = HandName('KQJT9s');
#&report($result eq 'Straight Flush', "$result\n");
#print "pre59\n";
#$result = HandName(qw( Jh Kh Th 9h Qh ));
#&report($result eq 'Straight Flush', "$result\n");
#@hand = qw( Jh Kh Th 9h Qh );
#$result = HandName(\@hand);
#&report($result eq 'Straight Flush', "$result\n");
#
#$result = HandName(2000);
#&report($result eq 'Three-of-a-Kind', "$result\n");
#$result = HandName(7000);
#&report($result eq 'High Card', "$result\n");
#print "pre63\n";
#$result = HandName(HandScore(7000));
#&report($result eq 'High Card', "$result\n");
