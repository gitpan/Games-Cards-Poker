#!/usr/bin/perl -w
# 44KDCFi - benchmrk.pl created by Pip Stuart <Pip@CPAN.Org> to compare
#     Games::Cards::Poker BestIndices() + ScoreHand() speed versus
#     Best() + Scor().
# Notz:
#   On my P3-800MHz 768MB:
#     took 82seconds to just loop through all 2,598,560 possible hands
#       with no additional computation
#     took 20minutes to test all result validity
#     took 60seconds to run through first 4096 possible hole+boards w/ UseSlow
#     took 34seconds to run through first 4096 possible hole+boards
#   On my P4-2.7GHz 1GB:
#     took 41seconds to just loop through all 2,598,560 possible hands
#     took 10minutes to test all result validity
#
#   Stats:
#     133,784,560 7-card combos you can have between hole && board
#        choo(52, 7)
#       2,598,960 5-card combos you can have in a final hand
#        choo(52, 5)
#           7,462 unique scores out of all possible final hands
#       2,118,760 5-card boards you can have after you have two hole cards
#        choo(50, 5)
#          19,600 2-card holes  you can be dealt
#        choo(52, 2)
#   Useful stuff to calc:
#     # of ways to get each possible hole
#     For each possible hole:
#       Hands You Win         && %
#       Hands You Lose        && %
#       Hands You Tie         && %
#       Hands You Don't Lose  && % (Win + Tie)

use strict;
use Algorithm::ChooseSubsets;
use Games::Cards::Poker;
use Time::PT;

my $limt = 4096; # limit of how many total hole+boards to test for each
my @deck = Deck();
my $choo = Algorithm::ChooseSubsets->new(\@deck, 7);
my $ptb4; my $ptaf; my $sdif; my $fdif; my $hbrd; my $coun; my @hand;
UseSlow(1);
$ptb4 = Time::PT->new();
printf("SlowPTb4:$ptb4 expand:%s\n", $ptb4->expand());
$coun = 0;
while($coun++ < $limt) { # limit not reached
  if($hbrd = $choo->next()) { # test hole + board SLOW
    @hand = BestHand(@{$hbrd});
  }
}
$ptaf = Time::PT->new();
printf("SlowPTaf:$ptaf expand:%s\n", $ptaf->expand());
$sdif = ($ptaf - $ptb4); # Time::Frame
printf(" SlowDif:%s seconds:%s\n", $sdif->total_frames(), ($sdif->total_frames() / 60));
$choo->reset();
UseSlow(0);
$ptb4 = Time::PT->new();
printf("FastPTb4:$ptb4 expand:%s\n", $ptb4->expand());
$coun = 0;
while($coun++ < $limt) { # limit not reached
  if($hbrd = $choo->next()) { # test hole + board FAST
    @hand = BestHand(@{$hbrd});
  }
}
$ptaf = Time::PT->new();
printf("FastPTaf:$ptaf expand:%s\n", $ptaf->expand());
$fdif = ($ptaf - $ptb4); # Time::Frame
printf(" FastDif:%s seconds:%s\n", $fdif->total_frames(), ($fdif->total_frames() / 60));
printf("  Fast took only %3.2f%% as long as Slow to run!\n", ($fdif->total_frames() / $sdif->total_frames()) * 100);
