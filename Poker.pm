# 43KNlxM - Games::Cards::Poker.pm created by Pip Stuart <Pip@CPAN.Org> to provide
#   Poker functions (&& maybe later objects) using only Perl.

=head1 NAME

Games::Cards::Poker - Pure Perl Poker functions

=head1 VERSION

This documentation refers to version 1.0.44P0KER of 
Games::Cards::Poker, which was released on Sun Apr 25 00:20:14:27 2004.

=head1 SYNOPSIS

  use Games::Cards::Poker;

  # Deal 4 players hands && score them...
  my $players   = 4; # number of players to get hands dealt
  my $hand_size = 5; # number of cards to deal to each player
  my @hands     = ();# player hand data
  my @deck      = Shuffle(Deck());
  while($players--) {
    foreach(1..$hand_size) {
      push(@{$hands[$players]}, pop(@deck));
    }
    printf("Player%d score:%4d hand:@{$hands[$players]}\n", 
      $players, ScoreHand(@{$hands[$players]}));
  }

=head1 DESCRIPTION

Poker provides a few simple functions for creating 
decks of cards && manipulating them for simple Poker games 
or simulations.

=head1 2DO

=over 2

=item - mk Games::Cards compatability object interface

=item - better error checking

=item -    What else does Poker need?

=back

=head1 USAGE

=head2 Deck()

Returns a new array of scalars with the abbreviated Poker names of
cards (eg. 'As' for 'Ace of Spades', 'Td' for 'Ten of Diamonds', 
'2c' for 'Two of Clubs', etc.).

Use CardName() to expand abbreviated cards into their full names.

=head2 Shuffle(@cards)

Shuffles the passed in @cards array in one quick pass.  Shuffle() 
returns a shuffled copy of the @cards array.

Shuffle() can also take an arrayref parameter instead of an explicit
@cards array in which case, the passed in arrayref will be shuffled
in place && the return value need not be reassigned.

=head2 SortCards(@cards)

Sorts the passed in @cards array.  SortCards() returns a sorted copy
of the @cards array.

SortCards() can also take an arrayref parameter instead of an explicit
@cards array in which case, the passed in arrayref will be sorted
in place && the return value need not be reassigned.

SortCards() works consistently on the return values of ShortHand()
as well as abbreviated cards (eg. 'AAA', 'AAK'..'AKQs', 'AKQ'..'222').

=head2 ShortHand(@hand)

Returns a scalar string containing the abbreviated Poker description
of @hand (eg. 'AKQJTs' eq 'Royal Flush', 'QQ993' eq 'Two Pair', etc.).

ShortHand() calls SortCards() on it's parameter before doing the
abbreviation to make sure that the return value is consistent.

ShortHand() can be called on fewer cards than a full @hand of 5 to
obtain other useful abbreviations (eg. ShortHand(@hole) will return
the abbreviated form of a player's two hole [pocket] cards or
ShortHand(@flop) will abbreviate the three community cards which
flop onto the board in Texas Hold'Em).

=head2 SlowScoreHand(@hand)

Returns an integer score (where lower is better) for the passed in 
Poker @hand.  This means 0 (zero) is returned for a Royal Flush && 
the worst possible score is 7461 awarded to 7, 5, 4, 3, 2 unsuited.

If you want higher scores to mean higher hands, just subtract the 
return value from 7461.

All suits are considered to have equal value in this scoring function.
It should be easy to use ScoreHand() as a first pass where ties can
be resolved by another suit-comparison function if you want such 
behavior.

=head2 HandScore($score)

This function is the opposite of ScoreHand().  It takes an integer
$score parameter && returns the corresponding ShortHand string.

HandScore() uses a fully enumerated table to just index the
associated ShortHand so it should be quite fast.  The table was 
generated using SlowScoreHand().

=head2 ScoreHand(@hand)

This is a new version of SlowScoreHand() which does the opposite of
HandScore() by indexing a ShortHand() key string into a hash of
corresponding score values.  This faster version should be used for
any normal hand scoring needs.  If you still want to use the slower
version, you can call the UseSlow() function to make ScoreHand()
actually call SlowScoreHand() instead of just indexing the answer
score in a hash.

=head2 UseSlow([$slow])

UseSlow() is a function provided in case you'd prefer to actually 
employ the SlowScoreHand() function whenever you call ScoreHand().

UseSlow() takes an optional $slow value.  If you don't 
provide $slow, UseSlow() will toggle the slow state.

UseSlow() always returns the current state of whether 
SlowScoreHand() is being used whenever ScoreHand() is called.

=head2 BestIndices(@cards)

BestIndices() takes 5 or more cards (normally 7) which can be
split among separate arrays (like BestIndices(@hole, @board) for
Hold'Em) && returns an array of the indices of the 5 cards (hand)
which yield the best score.

=head2 BestHand(@best, @cards)

BestHand() takes the return value of BestIndices() as the
first parameter (which is an array of the best indices) && then the
same other parameters (@cards) or (@hole, @board) to give you a copy
of just the best cards.  The return value of this function can be
passed to ScoreHand() to get the score of the best hand.

BestHand() can optionally take just the @cards like
BestIndices() && it will automagically call BestIndices()
first to obtain @best.  It will then return copies of those indexed
cards from the @cards.

=head2 CardName($card)

CardName() takes an abbreviated card (eg. 'As', 'Kh', '2c') && 
returns the expanded full name of the card ('Ace of Spades', 
'King of Hearts', 'Two of Clubs').

=head2 NameCard($name)

NameCard() does the opposite of CardName() by taking an expanded 
full name (eg. 'Queen of Diamonds', 'Jack of Hearts', 'Ten of Clubs')
&& returns the abbreviated card (eg. 'Qd', 'Jh', 'Tc').

=head2 HandName($score)

HandName() takes a HandScore() parameter && returns the name of
the corresponding scoring category it falls under (eg. 'Royal Flush',
'Three-of-a-Kind', 'High Card').

HandName() can optionally accept an arrayref to a hand, the @hand
itself, or a ShortHand instead of the $score parameter to find out
the HandName of any of those.

=head1 WHY?

Games::Poker::* wouldn't compile correctly for me so I thought it 
  shouldn't take too long to write my own. =)  It was a fun problem...
  much trickier than I first imagined but I think I have solved the
  problem elegantly once && for all.

=head1 NOTES

Suits are: s,h,d,c (Spade,Heart,Diamond,Club) like bridge (alphabetical).
  Although they are sorted && appear in this order, suits are ignored for
  scoring by default (but can be optionally reordered && scored later)

B64 notes: Cards map perfectly into A..Z,a..z so += 10 for only letter rep

 B64 Cards: 0.As 4.Ks 8.Qs C.Js G.Ts K.9s O.8s S.7s W.6s a.5s e.4s i.3s m.2s
            1.Ah 5.Kh 9.Qh D.Jh H.Th L.9h P.8h T.7h X.6h b.5h f.4h j.3h n.2h
            2.Ad 6.Kd A.Qd E.Jd I.Td M.9d Q.8d U.7d Y.6d c.5d g.4d k.3d o.2d
            3.Ac 7.Kc B.Qc F.Jc J.Tc N.9c R.8c V.7c Z.6c d.5c h.4c l.3c p.2c
     Ranks:   0    1    2    3    4    5    6    7    8    9    A    B    C 
 B64 Cards: 0.As   1.Ah   2.Ad   3.Ac        Ranks: 0
            4.Ks   5.Kh   6.Kd   7.Kc               1
            8.Qs   9.Qh   A.Qd   B.Qc               2
            C.Js   D.Jh   E.Jd   F.Jc               3
            G.Ts   H.Th   I.Td   J.Tc               4
            K.9s   L.9h   M.9d   N.9c               5
            O.8s   P.8h   Q.8d   R.8c               6
            S.7s   T.7h   U.7d   V.7c               7
            W.6s   X.6h   Y.6d   Z.6c               8
            a.5s   b.5h   c.5d   d.5c               9
            e.4s   f.4h   g.4d   h.4c               A
            i.3s   j.3h   k.3d   l.3c               B
            m.2s   n.2h   o.2d   p.2c               C
            q.Jok0 r.Jok1                          -1

Error checking is minimal.

I hope you find Games::Cards::Poker useful.  Please feel free to e-mail 
me any suggestions or coding tips or notes of appreciation 
("app-ree-see-ay-shun").  Thank you.  TTFN.

=head1 CHANGES

Revision history for Perl extension Games::Cards::Poker:

=over 4

=item - 1.0.44P0KER  Sun Apr 25 00:20:14:27 2004

* made CardName() to return 'Ace of Spades' or 'Two of Clubs' for
          'As'or'A' or '2c'or'z' && NameCard() to do inverse

* made HandName() to return 'Royal Flush' or 'High Card' for
          ScoreHand() or ShortHand() or @hand or \@hand && NameHand()

* rewrote SortCards() to accept any length ShortHand() params

* s/valu/rank/g s/scor/score/g s/bord/board/g

=item - 1.0.44LCEw8  Wed Apr 21 12:14:58:08 2004

* s/HoldEm//g; on advice from Joe since Best*() are useful for more
    than just Hold'Em (like 7-card stud)

* fixed minor typos in POD

=item - 1.0.44KFNKP  Tue Apr 20 15:23:20:25 2004

* wrote UseSlow() so that benchmrk.pl would still work without Best()
    && in case anyone would rather have ScoreHand() call 
    SlowScoreHand() every time instead.

* since my old Best() was actually slower than BestHoldEmIndices() =O
    I removed Best().

* since old Scor() was so much faster than old ScoreHand(), I renamed
    them to ScoreHand() && SlowScoreHand() respectively since 
    computational version is unnecessary now.

* wrote benchmrk.pl to test BestHoldEmIndices() + ScoreHand() against
    Best() + Scor().  Best()+Scor() only took 60% as long to run.

* added SortCards() call on ShortHand() param just in case

=item - 1.0.44ILBKV  Sun Apr 18 21:11:20:31 2004

* wrote Scor() with gen'd enumerated hash of ShortHand => Score

* wrote HandScore() to just lookup index of a ShortHand from a score

* squashed 4 scoring bugs in one pair section

* used Algorithm::ChooseSubsets for new BestHoldEmIndices
    (on Jan's recommendation)

* renamed enumerated BestHoldEmIndices() as Best()

* gave ScoreHand() optional arrayref param like others

* gave ScoreHand() optional ShortHand() string param

* updated 2do && tidied up documentation a bit

=item - 1.0.44H2DUS  Sat Apr 17 02:13:30:28 2004

* added BestHoldEmIndices() && BestHoldEmHand() for Tim && Jan

* commented unnecessary Games::Cards inheritance since I haven't written
any compatability / object interface yet

=item - 1.0.44F2Q8F  Thu Apr 15 02:26:08:15 2004

* original version

=back

=head1 INSTALL

Please run:

    `perl -MCPAN -e "install Games::Cards::Poker"`

or uncompress the package and run the standard:

    `perl Makefile.PL; make; make test; make install`

=head1 LICENSE

Most source code should be Free!
  Code I have lawful authority over is and shall be!
Copyright: (c) 2004, Pip Stuart.  All rights reserved.
Copyleft :  I license this software under the GNU General Public 
  License (version 2).  Please consult the Free Software Foundation 
  (http://www.fsf.org) for important information about your freedom.

=head1 AUTHOR

Pip Stuart <Pip@CPAN.Org>

=cut

package Games::Cards::Poker;
require     Exporter;
#require              Games::Cards;
use strict;
use base qw(Exporter);# Games::Cards);
use Math::BaseCnv  qw(:all);
use Algorithm::ChooseSubsets;

our @EXPORT      = qw(Shuffle Deck SortCards    ShortHand ScoreHand CardName
     UseSlow HandName BestIndices  BestHand SlowScoreHand HandScore NameCard);
our $VERSION     = '1.0.44P0KER'; # major . minor . PipTimeStamp
our $PTVR        = $VERSION; $PTVR =~ s/^\d+\.\d+\.//; # strip major and minor
# See http://Ax9.Org/pt?$PTVR and `perldoc Time::PT`

# rank progression, suit progression
my @rprg = ('A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2');
my @sprg = ('s', 'h', 'd', 'c'); # Spade, Heart, Diamond, Club  (Club, Diam)?
my @rnam = ('Ace',   'King', 'Queen', 'Jack', 'Ten',   'Nine', 'Eight', 
            'Seven', 'Six',  'Five',  'Four', 'Three', 'Two'); # Rank Names
my @snam = ('Spades', 'Hearts', 'Diamonds', 'Clubs');          # Suit Names
my %rprv; foreach my $indx (0..$#rprg) { $rprv{$rprg[$indx]} = $indx; }
my @hndz = (); my %scrh = (); # array && hash for faster ShortHand => score
my $slow = 0; # UseSlow() flag to use SlowScoreHand() instead of ScoreHand()

sub Deck { # return an array of cards as a whole new deck in clean new order
  my @deck = ();
  foreach my $rank (@rprg) {
    foreach my $suit (@sprg) {
      push(@deck, "$rank$suit");
    }
  }
  return(@deck);
}

sub Shuffle { # takes an arrayref or list of items to shuffle
  return(0) unless(@_); # must have at least one parameter
  my $aflg = 0; $aflg = 1 if(ref($_[0]) eq 'ARRAY');
  my $size = 0; my $aref = 0; my @data = @_;
  if($aflg) { $aref = $_[0];  }
  else      { $aref = \@data; }
  $size = @{$aref};
  for(my $indx = ($size - 1); $indx; $indx--) {
    my $rand = int(rand($indx));
    ($aref->[$indx], $aref->[$rand]) = ($aref->[$rand], $aref->[$indx]);
  }
  if($aflg) { return($aref); }
  else      { return(@data); }
}

sub SortCards { # takes an arrayref or list of cards to sort
  return(0) unless(@_); # must have at least one parameter
  my $aflg = 0; $aflg = 1 if(ref($_[0]) eq 'ARRAY');
  my $aref = 0; my @data = @_;
  if($aflg) { $aref = $_[0];  }
  else      { $aref = \@data; }
# what needs to sort:
#  'A'..'2'
#  'As'..'Ac'
#  'AA','AKs','AK'..'A2'
#  'AAA','AAK'..'AKQs','AKQ'..'222'
#  'AAAAK','AAAAQ'..'AKQJTs','AKQJT'..'32222' # based on rank values not scores
  @{$aref} = sort {
    my $indx = 0;
    my $suba = 0; 
    my $subb = 0;
    while($suba eq $subb && $indx < length($a)
                         && $indx < length($b)) {
      $suba = substr($a, $indx, 1);
      $subb = substr($b, $indx, 1);
      $indx++;
    } # find first different char
    if   ($suba eq 'A' && $subb ne 'A') { return(-1); }
    elsif($suba ne 'A' && $subb eq 'A') { return( 1); }
    elsif($suba eq 'K' && $subb ne 'K') { return(-1); }
    elsif($suba ne 'K' && $subb eq 'K') { return( 1); }
    elsif($suba eq 'Q' && $subb ne 'Q') { return(-1); }
    elsif($suba ne 'Q' && $subb eq 'Q') { return( 1); }
    elsif($suba eq 'J' && $subb ne 'J') { return(-1); }
    elsif($suba ne 'J' && $subb eq 'J') { return( 1); }
    elsif($suba eq 'T' && $subb ne 'T') { return(-1); }
    elsif($suba ne 'T' && $subb eq 'T') { return( 1); }
    elsif($suba eq $subb)               { 
      if   (length($a) >  $indx) { return(-1); }
      elsif(length($b) >  $indx) { return( 1); }
      else                       { return( 0); }
    } else                              { return($b cmp $a); }
  } @{$aref};
  if($aflg) { return($aref); }
  else      { return(@data); }
}

sub ShortHand { # takes an arrayref or list of cards to abbrev.
  return(0) unless(@_); # must have at least one parameter
  my $aflg = 0; $aflg = 1 if(ref($_[0]) eq 'ARRAY');
  my $aref = 0; my @data = @_; my $shrt = ''; my $suit = 1;
  if($aflg) { $aref = $_[0];  }
  else      { $aref = \@data; }
  SortCards($aref) unless(@{$aref} == 1); # make sure cards are sorted first
  foreach(@{$aref}) { 
    $shrt .=      substr($_, 0, 1); 
    $suit  = 0 if($suit && (length($_) < 2 ||
                  substr($_, 1, 1) ne substr($aref->[0], 1, 1)));
  }
  $shrt .= 's' if($suit);
  return($shrt);
}

sub SlowScoreHand { # takes 1 ShortHand or 5 cards && returns Poker hand score
  my @hand = @_; return(0) unless(@hand == 1 || @hand == 5);
  my $aflg = 0; $aflg = 1 if(ref( $hand[0]) eq 'ARRAY'); my $aref = 0;
  if($aflg) { $aref =  $hand[0]; }
  else      { $aref = \@hand;    }
  my $scor = 7462; my @data = (); my $flsh = 0; my $strt = 0;
  my ($set0, $set1);                      # temp values for matched sets
  my ($xtr0, $xtr1, $xtr2, $xtr3, $xtr4); # temp values for extra cards
  SortCards($aref) unless(@{$aref} == 1);
  for(my $indx=0; $indx<5; $indx++) {
    if(@{$aref} == 1) {
      ($data[$indx]{'rank'}, $data[$indx]{'suit'}) = (substr($aref->[0], $indx, 1), 's');
    } else {
      ($data[$indx]{'rank'}, $data[$indx]{'suit'}) = split(//, $aref->[$indx]);
    }
  } 
  # make data unsuited if ShortHand param only had 5 ranks (no 's' on the end)
  $data[0]{'suit'} = 'h' if(@{$aref} == 1 && length($aref->[0]) == 5);
#  Hand            ScoreRange  Size  Description
#--------------------------------------------------------
#  Royal    Flush     0           1  only one
#  Straight Flush     1..   9     9  King High through 5 High
#  Four-of-a-Kind    10.. 165   156  (13 choose 2) * 2
#  Full House       166.. 321   156  (13 choose 2) * 2
#           Flush   322..1598  1277  (13 choose 5) - 9
#  Straight        1599..1608    10  Ace  High through 5 High
#  Three-of-a-Kind 1609..2466   858  (13 choose 3) * 3
#  Two Pair        2467..3324   858  (13 choose 3) * 3
#  One Pair        3325..6184  2860  (13 choose 4) * 4
#  High Card       6185..7461  1277  (13 choose 5) - 9

#  general straight test
  if     (@rprg            >         ( $rprv{$data[1]{'rank'}} + 1 )   &&
          $data[2]{'rank'} eq $rprg[ ( $rprv{$data[1]{'rank'}} + 1 ) ] &&
          @rprg            >         ( $rprv{$data[1]{'rank'}} + 2 )   &&
          $data[3]{'rank'} eq $rprg[ ( $rprv{$data[1]{'rank'}} + 2 ) ] &&
          @rprg            >         ( $rprv{$data[1]{'rank'}} + 3 )   &&
          $data[4]{'rank'} eq $rprg[ ( $rprv{$data[1]{'rank'}} + 3 ) ] &&
        ((                             $rprv{$data[1]{'rank'}}         &&
          $data[0]{'rank'} eq $rprg[ ( $rprv{$data[1]{'rank'}} - 1 ) ] ) ||
         ($data[0]{'rank'} eq 'A' && $data[1]{'rank'} eq '5'))) { $strt = 1; }
#  general flush    test
  if     ($data[0]{'suit'} eq $data[1]{'suit'} &&
          $data[0]{'suit'} eq $data[2]{'suit'} &&
          $data[0]{'suit'} eq $data[3]{'suit'} &&
          $data[0]{'suit'} eq $data[4]{'suit'})                 { $flsh = 1; }
#  Royal    Flush     0           1  only one
  if     ($data[1]{'rank'} eq 'K' && $strt && $flsh) {
    $scor = 0;
#  Straight Flush     1..   9     9  King High through 5 High
  } elsif($strt && $flsh) {
    $scor =       $rprv{$data[0]{'rank'}};
    $scor =  9 if(      $data[0]{'rank'} eq 'A' &&
                        $data[1]{'rank'} eq '5');
#  Four-of-a-Kind    10.. 165   156  (13 choose 2) * 2
  } elsif($data[1]{'rank'} eq $data[2]{'rank'} &&
          $data[1]{'rank'} eq $data[3]{'rank'} &&
         ($data[1]{'rank'} eq $data[4]{'rank'} ||
          $data[1]{'rank'} eq $data[0]{'rank'})) {
    if($data[1]{'rank'} eq $data[0]{'rank'}) { # xxxx y
      $set0 = $rprv{$data[0]{'rank'}};
      $xtr0 = $rprv{$data[4]{'rank'}} - 1;
    } else {                                   # x yyyy
      $set0 = $rprv{$data[4]{'rank'}};
      $xtr0 = $rprv{$data[0]{'rank'}};
    }
    $scor = (10 + ($set0 * 12) + $xtr0);
#  Full House       166.. 321   156  (13 choose 2) * 2
  } elsif($data[0]{'rank'} eq $data[1]{'rank'} &&
          $data[3]{'rank'} eq $data[4]{'rank'} &&
         ($data[0]{'rank'} eq $data[2]{'rank'} ||
          $data[3]{'rank'} eq $data[2]{'rank'})) {
    if($data[0]{'rank'} eq $data[2]{'rank'}) { # xxx yy
      $set0 = $rprv{$data[0]{'rank'}};
      $set1 = $rprv{$data[4]{'rank'}} - 1;
    } else {                                   # xx yyy
      $set0 = $rprv{$data[4]{'rank'}};
      $set1 = $rprv{$data[0]{'rank'}};
    }
    $scor = (166 + ($set0 * 12) + $set1);
#           Flush   322..1598  1277  (13 choose 5) - 9
  } elsif($flsh) {
    $xtr0 = $rprv{$data[0]{'rank'}};
    $xtr1 = $rprv{$data[1]{'rank'}};
    $xtr2 = $rprv{$data[2]{'rank'}};
    $xtr3 = $rprv{$data[3]{'rank'}};
    $xtr4 = $rprv{$data[4]{'rank'}} - $xtr3;
    $scor = 322;
    $scor-- if($xtr0);
    $scor++ if($xtr1 ==  9);
    $scor++ if($xtr2 == 10);
    while($xtr0-- > 0) { $scor += (choo((11 - $xtr0), 4) - 1); }
    while($xtr1-- > 1) { $scor +=  choo((11 - $xtr1), 3)     ; }
    while($xtr2-- > 2) { $scor +=  choo((11 - $xtr2), 2)     ; }
    while($xtr3-- > 3) { $scor +=       (12 - $xtr3)         ; }
                         $scor += (           $xtr4      - 2);
#  Straight        1599..1608    10  King High through 5 High
  } elsif($strt) {
    $scor = (1599 +  $rprv{$data[0]{'rank'}});
    $scor =  1608 if(      $data[0]{'rank'} eq 'A' &&
                           $data[1]{'rank'} eq '5');
#  Three-of-a-Kind 1609..2466   858  (13 choose 3) * 3
  } elsif(($data[0]{'rank'} eq $data[1]{'rank'} &&
           $data[0]{'rank'} eq $data[2]{'rank'}) || # xxx y z
          ($data[1]{'rank'} eq $data[2]{'rank'} &&
           $data[2]{'rank'} eq $data[3]{'rank'}) || # x yyy z
          ($data[2]{'rank'} eq $data[3]{'rank'} &&
           $data[3]{'rank'} eq $data[4]{'rank'})) { # x y zzz
    if     ($data[0]{'rank'} eq $data[2]{'rank'}) { # xxx y z
      $set0 = $rprv{$data[0]{'rank'}};
      $xtr0 = $rprv{$data[3]{'rank'}} - 1;
      $xtr1 = $rprv{$data[4]{'rank'}} - 2;
    } elsif($data[1]{'rank'} eq $data[3]{'rank'}) { # x yyy z
      $xtr0 = $rprv{$data[0]{'rank'}};
      $set0 = $rprv{$data[1]{'rank'}};
      $xtr1 = $rprv{$data[4]{'rank'}} - 2;
    } else {                                        # x y zzz
      $xtr0 = $rprv{$data[0]{'rank'}};
      $xtr1 = $rprv{$data[1]{'rank'}} - 1;
      $set0 = $rprv{$data[2]{'rank'}};
    }
    $scor = (1609 +
             (      $set0  * summ(  11 )) +
             ((12 * $xtr0) - summ($xtr0)) +
             (      $xtr1  -      $xtr0 ));
#  Two Pair        2467..3324   858  (13 choose 3) * 3
  } elsif(($data[0]{'rank'} eq $data[1]{'rank'} &&
           $data[2]{'rank'} eq $data[3]{'rank'}) || # xx yy z
          ($data[0]{'rank'} eq $data[1]{'rank'} &&
           $data[3]{'rank'} eq $data[4]{'rank'}) || # xx y zz
          ($data[1]{'rank'} eq $data[2]{'rank'} &&
           $data[3]{'rank'} eq $data[4]{'rank'})) { # x yy zz
    if($data[0]{'rank'} eq $data[1]{'rank'}) {      # xx
      if($data[2]{'rank'} eq $data[3]{'rank'}) {    #    yy z
        $set0 = $rprv{$data[0]{'rank'}};
        $set1 = $rprv{$data[2]{'rank'}} - 1;
        $xtr0 = $rprv{$data[4]{'rank'}} - 2;
      } else {                                      #    y zz
        $set0 = $rprv{$data[0]{'rank'}};
        $xtr0 = $rprv{$data[2]{'rank'}} - 1;
        $set1 = $rprv{$data[3]{'rank'}} - 1;
      }
    } else {                                        # x yy zz
      $xtr0 = $rprv{$data[0]{'rank'}};
      $set0 = $rprv{$data[1]{'rank'}};
      $set1 = $rprv{$data[3]{'rank'}} - 1;
    }
    $scor = (2467 +
             (((13*$set0) - summ($set0)) * 11) +
             ((    $set1  -      $set0 ) * 11) +
                   $xtr0                      );
#  One Pair        3325..6184  2860  (13 choose 4) * 4
  } elsif($data[0]{'rank'} eq $data[1]{'rank'} ||   # ww x y z
          $data[1]{'rank'} eq $data[2]{'rank'} ||   # w xx y z
          $data[2]{'rank'} eq $data[3]{'rank'} ||   # w x yy z
          $data[3]{'rank'} eq $data[4]{'rank'}) {   # w x y zz
    if     ($data[0]{'rank'} eq $data[1]{'rank'}) { # ww
      $set0 = $rprv{$data[0]{'rank'}};
      $xtr0 = $rprv{$data[2]{'rank'}} - 1;
      $xtr1 = $rprv{$data[3]{'rank'}} - 1;
      $xtr2 = $rprv{$data[4]{'rank'}} - 1;
    } elsif($data[1]{'rank'} eq $data[2]{'rank'}) { #   xx
      $xtr0 = $rprv{$data[0]{'rank'}};
      $set0 = $rprv{$data[1]{'rank'}};
      $xtr1 = $rprv{$data[3]{'rank'}} - 1;
      $xtr2 = $rprv{$data[4]{'rank'}} - 1;
    } elsif($data[2]{'rank'} eq $data[3]{'rank'}) { #     yy
      $xtr0 = $rprv{$data[0]{'rank'}};
      $xtr1 = $rprv{$data[1]{'rank'}};
      $set0 = $rprv{$data[2]{'rank'}};
      $xtr2 = $rprv{$data[4]{'rank'}} - 1;
    } else {                                        #       zz
      $xtr0 = $rprv{$data[0]{'rank'}};
      $xtr1 = $rprv{$data[1]{'rank'}};
      $xtr2 = $rprv{$data[2]{'rank'}};
      $set0 = $rprv{$data[3]{'rank'}};
    }
    $scor  = 3325;
    $scor +=  ($set0 * choo(12, 3));
    $scor++ if($xtr0 == 9);
    $xtr2 -=  ($xtr1 +  1);
    while($xtr0-- > 0) { $scor +=  choo((10 - $xtr0), 2)     ; }
    while($xtr1-- > 1) { $scor += (     (12 - $xtr1)     - 1); }
                         $scor +=             $xtr2          ;
#  High Card       6185..7461  1277  (13 choose 5) - 9
  } else {
    $xtr0 = $rprv{$data[0]{'rank'}};
    $xtr1 = $rprv{$data[1]{'rank'}};
    $xtr2 = $rprv{$data[2]{'rank'}};
    $xtr3 = $rprv{$data[3]{'rank'}};
    $xtr4 = $rprv{$data[4]{'rank'}} - $xtr3;
    $scor = 6185;
    $scor-- if($xtr0);
    $scor++ if($xtr1 ==  9);
    $scor++ if($xtr2 == 10);
    while($xtr0-- > 0) { $scor += (choo((11 - $xtr0), 4) - 1); }
    while($xtr1-- > 1) { $scor +=  choo((11 - $xtr1), 3)     ; }
    while($xtr2-- > 2) { $scor +=  choo((11 - $xtr2), 2)     ; }
    while($xtr3-- > 3) { $scor +=       (12 - $xtr3)         ; }
                         $scor += (           $xtr4      - 2);
  }
  return($scor);
}

sub BestIndices { # takes 5+ cards (7) && returns indices of the best 5
  my @crdz = @_; return(0) unless(@crdz >= 5); my @best = (); my @bhnd = ();
  my $choo = Algorithm::ChooseSubsets->new(scalar(@crdz), 5);
  while(my $choi = $choo->next()) {
    my @hand = ();
    for(my $cndx = 0; $cndx < 5; $cndx++) {
      push(@hand, $crdz[ $choi->[ $cndx ] ]);
      if(@hand == 5 && (!@best || ScoreHand(@bhnd) > ScoreHand(@hand))) {
        @best = @{$choi}; @bhnd = ();
        push(@bhnd, $crdz[$_]) foreach(@best);
      }
    }
  }
  return(@best);
}

sub BestHand { # takes return value of BestIndices() && all cards
  my @best = (shift, shift, shift, shift, shift); # get best indices
  my @crdz = @_;
  if(@crdz <= 2) { # if only 7 params given, pass onto Indices first
    unshift(@crdz, @best);
    @best = BestIndices(@crdz);
  }
  return(0) unless(@best == 5 && @crdz >= 5); # ck for valid sizes
  my @hand = (); push(@hand, $crdz[$_]) foreach(@best); # copy best cards
  return(@hand);
}

sub HandScore { # returns the ShortHand representation of passed in score param
  my $scor = shift || 0;
  unless(@hndz) { # define Look-Up Table (LUT) only the first time it's called
    @hndz = ( # this table was generated from the SlowScoreHand() function
      'AKQJTs', 'KQJT9s', 'QJT98s', 'JT987s', 'T9876s', '98765s', '87654s',
      '76543s', '65432s', 'A5432s', 'AAAAK' , 'AAAAQ' , 'AAAAJ' , 'AAAAT' ,
      'AAAA9' , 'AAAA8' , 'AAAA7' , 'AAAA6' , 'AAAA5' , 'AAAA4' , 'AAAA3' ,
      'AAAA2' , 'AKKKK' , 'KKKKQ' , 'KKKKJ' , 'KKKKT' , 'KKKK9' , 'KKKK8' ,
      'KKKK7' , 'KKKK6' , 'KKKK5' , 'KKKK4' , 'KKKK3' , 'KKKK2' , 'AQQQQ' ,
      'KQQQQ' , 'QQQQJ' , 'QQQQT' , 'QQQQ9' , 'QQQQ8' , 'QQQQ7' , 'QQQQ6' ,
      'QQQQ5' , 'QQQQ4' , 'QQQQ3' , 'QQQQ2' , 'AJJJJ' , 'KJJJJ' , 'QJJJJ' ,
      'JJJJT' , 'JJJJ9' , 'JJJJ8' , 'JJJJ7' , 'JJJJ6' , 'JJJJ5' , 'JJJJ4' ,
      'JJJJ3' , 'JJJJ2' , 'ATTTT' , 'KTTTT' , 'QTTTT' , 'JTTTT' , 'TTTT9' ,
      'TTTT8' , 'TTTT7' , 'TTTT6' , 'TTTT5' , 'TTTT4' , 'TTTT3' , 'TTTT2' ,
      'A9999' , 'K9999' , 'Q9999' , 'J9999' , 'T9999' , '99998' , '99997' ,
      '99996' , '99995' , '99994' , '99993' , '99992' , 'A8888' , 'K8888' ,
      'Q8888' , 'J8888' , 'T8888' , '98888' , '88887' , '88886' , '88885' ,
      '88884' , '88883' , '88882' , 'A7777' , 'K7777' , 'Q7777' , 'J7777' ,
      'T7777' , '97777' , '87777' , '77776' , '77775' , '77774' , '77773' ,
      '77772' , 'A6666' , 'K6666' , 'Q6666' , 'J6666' , 'T6666' , '96666' ,
      '86666' , '76666' , '66665' , '66664' , '66663' , '66662' , 'A5555' ,
      'K5555' , 'Q5555' , 'J5555' , 'T5555' , '95555' , '85555' , '75555' ,
      '65555' , '55554' , '55553' , '55552' , 'A4444' , 'K4444' , 'Q4444' ,
      'J4444' , 'T4444' , '94444' , '84444' , '74444' , '64444' , '54444' ,
      '44443' , '44442' , 'A3333' , 'K3333' , 'Q3333' , 'J3333' , 'T3333' ,
      '93333' , '83333' , '73333' , '63333' , '53333' , '43333' , '33332' ,
      'A2222' , 'K2222' , 'Q2222' , 'J2222' , 'T2222' , '92222' , '82222' ,
      '72222' , '62222' , '52222' , '42222' , '32222' , 'AAAKK' , 'AAAQQ' ,
      'AAAJJ' , 'AAATT' , 'AAA99' , 'AAA88' , 'AAA77' , 'AAA66' , 'AAA55' ,
      'AAA44' , 'AAA33' , 'AAA22' , 'AAKKK' , 'KKKQQ' , 'KKKJJ' , 'KKKTT' ,
      'KKK99' , 'KKK88' , 'KKK77' , 'KKK66' , 'KKK55' , 'KKK44' , 'KKK33' ,
      'KKK22' , 'AAQQQ' , 'KKQQQ' , 'QQQJJ' , 'QQQTT' , 'QQQ99' , 'QQQ88' ,
      'QQQ77' , 'QQQ66' , 'QQQ55' , 'QQQ44' , 'QQQ33' , 'QQQ22' , 'AAJJJ' ,
      'KKJJJ' , 'QQJJJ' , 'JJJTT' , 'JJJ99' , 'JJJ88' , 'JJJ77' , 'JJJ66' ,
      'JJJ55' , 'JJJ44' , 'JJJ33' , 'JJJ22' , 'AATTT' , 'KKTTT' , 'QQTTT' ,
      'JJTTT' , 'TTT99' , 'TTT88' , 'TTT77' , 'TTT66' , 'TTT55' , 'TTT44' ,
      'TTT33' , 'TTT22' , 'AA999' , 'KK999' , 'QQ999' , 'JJ999' , 'TT999' ,
      '99988' , '99977' , '99966' , '99955' , '99944' , '99933' , '99922' ,
      'AA888' , 'KK888' , 'QQ888' , 'JJ888' , 'TT888' , '99888' , '88877' ,
      '88866' , '88855' , '88844' , '88833' , '88822' , 'AA777' , 'KK777' ,
      'QQ777' , 'JJ777' , 'TT777' , '99777' , '88777' , '77766' , '77755' ,
      '77744' , '77733' , '77722' , 'AA666' , 'KK666' , 'QQ666' , 'JJ666' ,
      'TT666' , '99666' , '88666' , '77666' , '66655' , '66644' , '66633' ,
      '66622' , 'AA555' , 'KK555' , 'QQ555' , 'JJ555' , 'TT555' , '99555' ,
      '88555' , '77555' , '66555' , '55544' , '55533' , '55522' , 'AA444' ,
      'KK444' , 'QQ444' , 'JJ444' , 'TT444' , '99444' , '88444' , '77444' ,
      '66444' , '55444' , '44433' , '44422' , 'AA333' , 'KK333' , 'QQ333' ,
      'JJ333' , 'TT333' , '99333' , '88333' , '77333' , '66333' , '55333' ,
      '44333' , '33322' , 'AA222' , 'KK222' , 'QQ222' , 'JJ222' , 'TT222' ,
      '99222' , '88222' , '77222' , '66222' , '55222' , '44222' , '33222' ,
      'AKQJ9s', 'AKQJ8s', 'AKQJ7s', 'AKQJ6s', 'AKQJ5s', 'AKQJ4s', 'AKQJ3s',
      'AKQJ2s', 'AKQT9s', 'AKQT8s', 'AKQT7s', 'AKQT6s', 'AKQT5s', 'AKQT4s',
      'AKQT3s', 'AKQT2s', 'AKQ98s', 'AKQ97s', 'AKQ96s', 'AKQ95s', 'AKQ94s',
      'AKQ93s', 'AKQ92s', 'AKQ87s', 'AKQ86s', 'AKQ85s', 'AKQ84s', 'AKQ83s',
      'AKQ82s', 'AKQ76s', 'AKQ75s', 'AKQ74s', 'AKQ73s', 'AKQ72s', 'AKQ65s',
      'AKQ64s', 'AKQ63s', 'AKQ62s', 'AKQ54s', 'AKQ53s', 'AKQ52s', 'AKQ43s',
      'AKQ42s', 'AKQ32s', 'AKJT9s', 'AKJT8s', 'AKJT7s', 'AKJT6s', 'AKJT5s',
      'AKJT4s', 'AKJT3s', 'AKJT2s', 'AKJ98s', 'AKJ97s', 'AKJ96s', 'AKJ95s',
      'AKJ94s', 'AKJ93s', 'AKJ92s', 'AKJ87s', 'AKJ86s', 'AKJ85s', 'AKJ84s',
      'AKJ83s', 'AKJ82s', 'AKJ76s', 'AKJ75s', 'AKJ74s', 'AKJ73s', 'AKJ72s',
      'AKJ65s', 'AKJ64s', 'AKJ63s', 'AKJ62s', 'AKJ54s', 'AKJ53s', 'AKJ52s',
      'AKJ43s', 'AKJ42s', 'AKJ32s', 'AKT98s', 'AKT97s', 'AKT96s', 'AKT95s',
      'AKT94s', 'AKT93s', 'AKT92s', 'AKT87s', 'AKT86s', 'AKT85s', 'AKT84s',
      'AKT83s', 'AKT82s', 'AKT76s', 'AKT75s', 'AKT74s', 'AKT73s', 'AKT72s',
      'AKT65s', 'AKT64s', 'AKT63s', 'AKT62s', 'AKT54s', 'AKT53s', 'AKT52s',
      'AKT43s', 'AKT42s', 'AKT32s', 'AK987s', 'AK986s', 'AK985s', 'AK984s',
      'AK983s', 'AK982s', 'AK976s', 'AK975s', 'AK974s', 'AK973s', 'AK972s',
      'AK965s', 'AK964s', 'AK963s', 'AK962s', 'AK954s', 'AK953s', 'AK952s',
      'AK943s', 'AK942s', 'AK932s', 'AK876s', 'AK875s', 'AK874s', 'AK873s',
      'AK872s', 'AK865s', 'AK864s', 'AK863s', 'AK862s', 'AK854s', 'AK853s',
      'AK852s', 'AK843s', 'AK842s', 'AK832s', 'AK765s', 'AK764s', 'AK763s',
      'AK762s', 'AK754s', 'AK753s', 'AK752s', 'AK743s', 'AK742s', 'AK732s',
      'AK654s', 'AK653s', 'AK652s', 'AK643s', 'AK642s', 'AK632s', 'AK543s',
      'AK542s', 'AK532s', 'AK432s', 'AQJT9s', 'AQJT8s', 'AQJT7s', 'AQJT6s',
      'AQJT5s', 'AQJT4s', 'AQJT3s', 'AQJT2s', 'AQJ98s', 'AQJ97s', 'AQJ96s',
      'AQJ95s', 'AQJ94s', 'AQJ93s', 'AQJ92s', 'AQJ87s', 'AQJ86s', 'AQJ85s',
      'AQJ84s', 'AQJ83s', 'AQJ82s', 'AQJ76s', 'AQJ75s', 'AQJ74s', 'AQJ73s',
      'AQJ72s', 'AQJ65s', 'AQJ64s', 'AQJ63s', 'AQJ62s', 'AQJ54s', 'AQJ53s',
      'AQJ52s', 'AQJ43s', 'AQJ42s', 'AQJ32s', 'AQT98s', 'AQT97s', 'AQT96s',
      'AQT95s', 'AQT94s', 'AQT93s', 'AQT92s', 'AQT87s', 'AQT86s', 'AQT85s',
      'AQT84s', 'AQT83s', 'AQT82s', 'AQT76s', 'AQT75s', 'AQT74s', 'AQT73s',
      'AQT72s', 'AQT65s', 'AQT64s', 'AQT63s', 'AQT62s', 'AQT54s', 'AQT53s',
      'AQT52s', 'AQT43s', 'AQT42s', 'AQT32s', 'AQ987s', 'AQ986s', 'AQ985s',
      'AQ984s', 'AQ983s', 'AQ982s', 'AQ976s', 'AQ975s', 'AQ974s', 'AQ973s',
      'AQ972s', 'AQ965s', 'AQ964s', 'AQ963s', 'AQ962s', 'AQ954s', 'AQ953s',
      'AQ952s', 'AQ943s', 'AQ942s', 'AQ932s', 'AQ876s', 'AQ875s', 'AQ874s',
      'AQ873s', 'AQ872s', 'AQ865s', 'AQ864s', 'AQ863s', 'AQ862s', 'AQ854s',
      'AQ853s', 'AQ852s', 'AQ843s', 'AQ842s', 'AQ832s', 'AQ765s', 'AQ764s',
      'AQ763s', 'AQ762s', 'AQ754s', 'AQ753s', 'AQ752s', 'AQ743s', 'AQ742s',
      'AQ732s', 'AQ654s', 'AQ653s', 'AQ652s', 'AQ643s', 'AQ642s', 'AQ632s',
      'AQ543s', 'AQ542s', 'AQ532s', 'AQ432s', 'AJT98s', 'AJT97s', 'AJT96s',
      'AJT95s', 'AJT94s', 'AJT93s', 'AJT92s', 'AJT87s', 'AJT86s', 'AJT85s',
      'AJT84s', 'AJT83s', 'AJT82s', 'AJT76s', 'AJT75s', 'AJT74s', 'AJT73s',
      'AJT72s', 'AJT65s', 'AJT64s', 'AJT63s', 'AJT62s', 'AJT54s', 'AJT53s',
      'AJT52s', 'AJT43s', 'AJT42s', 'AJT32s', 'AJ987s', 'AJ986s', 'AJ985s',
      'AJ984s', 'AJ983s', 'AJ982s', 'AJ976s', 'AJ975s', 'AJ974s', 'AJ973s',
      'AJ972s', 'AJ965s', 'AJ964s', 'AJ963s', 'AJ962s', 'AJ954s', 'AJ953s',
      'AJ952s', 'AJ943s', 'AJ942s', 'AJ932s', 'AJ876s', 'AJ875s', 'AJ874s',
      'AJ873s', 'AJ872s', 'AJ865s', 'AJ864s', 'AJ863s', 'AJ862s', 'AJ854s',
      'AJ853s', 'AJ852s', 'AJ843s', 'AJ842s', 'AJ832s', 'AJ765s', 'AJ764s',
      'AJ763s', 'AJ762s', 'AJ754s', 'AJ753s', 'AJ752s', 'AJ743s', 'AJ742s',
      'AJ732s', 'AJ654s', 'AJ653s', 'AJ652s', 'AJ643s', 'AJ642s', 'AJ632s',
      'AJ543s', 'AJ542s', 'AJ532s', 'AJ432s', 'AT987s', 'AT986s', 'AT985s',
      'AT984s', 'AT983s', 'AT982s', 'AT976s', 'AT975s', 'AT974s', 'AT973s',
      'AT972s', 'AT965s', 'AT964s', 'AT963s', 'AT962s', 'AT954s', 'AT953s',
      'AT952s', 'AT943s', 'AT942s', 'AT932s', 'AT876s', 'AT875s', 'AT874s',
      'AT873s', 'AT872s', 'AT865s', 'AT864s', 'AT863s', 'AT862s', 'AT854s',
      'AT853s', 'AT852s', 'AT843s', 'AT842s', 'AT832s', 'AT765s', 'AT764s',
      'AT763s', 'AT762s', 'AT754s', 'AT753s', 'AT752s', 'AT743s', 'AT742s',
      'AT732s', 'AT654s', 'AT653s', 'AT652s', 'AT643s', 'AT642s', 'AT632s',
      'AT543s', 'AT542s', 'AT532s', 'AT432s', 'A9876s', 'A9875s', 'A9874s',
      'A9873s', 'A9872s', 'A9865s', 'A9864s', 'A9863s', 'A9862s', 'A9854s',
      'A9853s', 'A9852s', 'A9843s', 'A9842s', 'A9832s', 'A9765s', 'A9764s',
      'A9763s', 'A9762s', 'A9754s', 'A9753s', 'A9752s', 'A9743s', 'A9742s',
      'A9732s', 'A9654s', 'A9653s', 'A9652s', 'A9643s', 'A9642s', 'A9632s',
      'A9543s', 'A9542s', 'A9532s', 'A9432s', 'A8765s', 'A8764s', 'A8763s',
      'A8762s', 'A8754s', 'A8753s', 'A8752s', 'A8743s', 'A8742s', 'A8732s',
      'A8654s', 'A8653s', 'A8652s', 'A8643s', 'A8642s', 'A8632s', 'A8543s',
      'A8542s', 'A8532s', 'A8432s', 'A7654s', 'A7653s', 'A7652s', 'A7643s',
      'A7642s', 'A7632s', 'A7543s', 'A7542s', 'A7532s', 'A7432s', 'A6543s',
      'A6542s', 'A6532s', 'A6432s', 'KQJT8s', 'KQJT7s', 'KQJT6s', 'KQJT5s',
      'KQJT4s', 'KQJT3s', 'KQJT2s', 'KQJ98s', 'KQJ97s', 'KQJ96s', 'KQJ95s',
      'KQJ94s', 'KQJ93s', 'KQJ92s', 'KQJ87s', 'KQJ86s', 'KQJ85s', 'KQJ84s',
      'KQJ83s', 'KQJ82s', 'KQJ76s', 'KQJ75s', 'KQJ74s', 'KQJ73s', 'KQJ72s',
      'KQJ65s', 'KQJ64s', 'KQJ63s', 'KQJ62s', 'KQJ54s', 'KQJ53s', 'KQJ52s',
      'KQJ43s', 'KQJ42s', 'KQJ32s', 'KQT98s', 'KQT97s', 'KQT96s', 'KQT95s',
      'KQT94s', 'KQT93s', 'KQT92s', 'KQT87s', 'KQT86s', 'KQT85s', 'KQT84s',
      'KQT83s', 'KQT82s', 'KQT76s', 'KQT75s', 'KQT74s', 'KQT73s', 'KQT72s',
      'KQT65s', 'KQT64s', 'KQT63s', 'KQT62s', 'KQT54s', 'KQT53s', 'KQT52s',
      'KQT43s', 'KQT42s', 'KQT32s', 'KQ987s', 'KQ986s', 'KQ985s', 'KQ984s',
      'KQ983s', 'KQ982s', 'KQ976s', 'KQ975s', 'KQ974s', 'KQ973s', 'KQ972s',
      'KQ965s', 'KQ964s', 'KQ963s', 'KQ962s', 'KQ954s', 'KQ953s', 'KQ952s',
      'KQ943s', 'KQ942s', 'KQ932s', 'KQ876s', 'KQ875s', 'KQ874s', 'KQ873s',
      'KQ872s', 'KQ865s', 'KQ864s', 'KQ863s', 'KQ862s', 'KQ854s', 'KQ853s',
      'KQ852s', 'KQ843s', 'KQ842s', 'KQ832s', 'KQ765s', 'KQ764s', 'KQ763s',
      'KQ762s', 'KQ754s', 'KQ753s', 'KQ752s', 'KQ743s', 'KQ742s', 'KQ732s',
      'KQ654s', 'KQ653s', 'KQ652s', 'KQ643s', 'KQ642s', 'KQ632s', 'KQ543s',
      'KQ542s', 'KQ532s', 'KQ432s', 'KJT98s', 'KJT97s', 'KJT96s', 'KJT95s',
      'KJT94s', 'KJT93s', 'KJT92s', 'KJT87s', 'KJT86s', 'KJT85s', 'KJT84s',
      'KJT83s', 'KJT82s', 'KJT76s', 'KJT75s', 'KJT74s', 'KJT73s', 'KJT72s',
      'KJT65s', 'KJT64s', 'KJT63s', 'KJT62s', 'KJT54s', 'KJT53s', 'KJT52s',
      'KJT43s', 'KJT42s', 'KJT32s', 'KJ987s', 'KJ986s', 'KJ985s', 'KJ984s',
      'KJ983s', 'KJ982s', 'KJ976s', 'KJ975s', 'KJ974s', 'KJ973s', 'KJ972s',
      'KJ965s', 'KJ964s', 'KJ963s', 'KJ962s', 'KJ954s', 'KJ953s', 'KJ952s',
      'KJ943s', 'KJ942s', 'KJ932s', 'KJ876s', 'KJ875s', 'KJ874s', 'KJ873s',
      'KJ872s', 'KJ865s', 'KJ864s', 'KJ863s', 'KJ862s', 'KJ854s', 'KJ853s',
      'KJ852s', 'KJ843s', 'KJ842s', 'KJ832s', 'KJ765s', 'KJ764s', 'KJ763s',
      'KJ762s', 'KJ754s', 'KJ753s', 'KJ752s', 'KJ743s', 'KJ742s', 'KJ732s',
      'KJ654s', 'KJ653s', 'KJ652s', 'KJ643s', 'KJ642s', 'KJ632s', 'KJ543s',
      'KJ542s', 'KJ532s', 'KJ432s', 'KT987s', 'KT986s', 'KT985s', 'KT984s',
      'KT983s', 'KT982s', 'KT976s', 'KT975s', 'KT974s', 'KT973s', 'KT972s',
      'KT965s', 'KT964s', 'KT963s', 'KT962s', 'KT954s', 'KT953s', 'KT952s',
      'KT943s', 'KT942s', 'KT932s', 'KT876s', 'KT875s', 'KT874s', 'KT873s',
      'KT872s', 'KT865s', 'KT864s', 'KT863s', 'KT862s', 'KT854s', 'KT853s',
      'KT852s', 'KT843s', 'KT842s', 'KT832s', 'KT765s', 'KT764s', 'KT763s',
      'KT762s', 'KT754s', 'KT753s', 'KT752s', 'KT743s', 'KT742s', 'KT732s',
      'KT654s', 'KT653s', 'KT652s', 'KT643s', 'KT642s', 'KT632s', 'KT543s',
      'KT542s', 'KT532s', 'KT432s', 'K9876s', 'K9875s', 'K9874s', 'K9873s',
      'K9872s', 'K9865s', 'K9864s', 'K9863s', 'K9862s', 'K9854s', 'K9853s',
      'K9852s', 'K9843s', 'K9842s', 'K9832s', 'K9765s', 'K9764s', 'K9763s',
      'K9762s', 'K9754s', 'K9753s', 'K9752s', 'K9743s', 'K9742s', 'K9732s',
      'K9654s', 'K9653s', 'K9652s', 'K9643s', 'K9642s', 'K9632s', 'K9543s',
      'K9542s', 'K9532s', 'K9432s', 'K8765s', 'K8764s', 'K8763s', 'K8762s',
      'K8754s', 'K8753s', 'K8752s', 'K8743s', 'K8742s', 'K8732s', 'K8654s',
      'K8653s', 'K8652s', 'K8643s', 'K8642s', 'K8632s', 'K8543s', 'K8542s',
      'K8532s', 'K8432s', 'K7654s', 'K7653s', 'K7652s', 'K7643s', 'K7642s',
      'K7632s', 'K7543s', 'K7542s', 'K7532s', 'K7432s', 'K6543s', 'K6542s',
      'K6532s', 'K6432s', 'K5432s', 'QJT97s', 'QJT96s', 'QJT95s', 'QJT94s',
      'QJT93s', 'QJT92s', 'QJT87s', 'QJT86s', 'QJT85s', 'QJT84s', 'QJT83s',
      'QJT82s', 'QJT76s', 'QJT75s', 'QJT74s', 'QJT73s', 'QJT72s', 'QJT65s',
      'QJT64s', 'QJT63s', 'QJT62s', 'QJT54s', 'QJT53s', 'QJT52s', 'QJT43s',
      'QJT42s', 'QJT32s', 'QJ987s', 'QJ986s', 'QJ985s', 'QJ984s', 'QJ983s',
      'QJ982s', 'QJ976s', 'QJ975s', 'QJ974s', 'QJ973s', 'QJ972s', 'QJ965s',
      'QJ964s', 'QJ963s', 'QJ962s', 'QJ954s', 'QJ953s', 'QJ952s', 'QJ943s',
      'QJ942s', 'QJ932s', 'QJ876s', 'QJ875s', 'QJ874s', 'QJ873s', 'QJ872s',
      'QJ865s', 'QJ864s', 'QJ863s', 'QJ862s', 'QJ854s', 'QJ853s', 'QJ852s',
      'QJ843s', 'QJ842s', 'QJ832s', 'QJ765s', 'QJ764s', 'QJ763s', 'QJ762s',
      'QJ754s', 'QJ753s', 'QJ752s', 'QJ743s', 'QJ742s', 'QJ732s', 'QJ654s',
      'QJ653s', 'QJ652s', 'QJ643s', 'QJ642s', 'QJ632s', 'QJ543s', 'QJ542s',
      'QJ532s', 'QJ432s', 'QT987s', 'QT986s', 'QT985s', 'QT984s', 'QT983s',
      'QT982s', 'QT976s', 'QT975s', 'QT974s', 'QT973s', 'QT972s', 'QT965s',
      'QT964s', 'QT963s', 'QT962s', 'QT954s', 'QT953s', 'QT952s', 'QT943s',
      'QT942s', 'QT932s', 'QT876s', 'QT875s', 'QT874s', 'QT873s', 'QT872s',
      'QT865s', 'QT864s', 'QT863s', 'QT862s', 'QT854s', 'QT853s', 'QT852s',
      'QT843s', 'QT842s', 'QT832s', 'QT765s', 'QT764s', 'QT763s', 'QT762s',
      'QT754s', 'QT753s', 'QT752s', 'QT743s', 'QT742s', 'QT732s', 'QT654s',
      'QT653s', 'QT652s', 'QT643s', 'QT642s', 'QT632s', 'QT543s', 'QT542s',
      'QT532s', 'QT432s', 'Q9876s', 'Q9875s', 'Q9874s', 'Q9873s', 'Q9872s',
      'Q9865s', 'Q9864s', 'Q9863s', 'Q9862s', 'Q9854s', 'Q9853s', 'Q9852s',
      'Q9843s', 'Q9842s', 'Q9832s', 'Q9765s', 'Q9764s', 'Q9763s', 'Q9762s',
      'Q9754s', 'Q9753s', 'Q9752s', 'Q9743s', 'Q9742s', 'Q9732s', 'Q9654s',
      'Q9653s', 'Q9652s', 'Q9643s', 'Q9642s', 'Q9632s', 'Q9543s', 'Q9542s',
      'Q9532s', 'Q9432s', 'Q8765s', 'Q8764s', 'Q8763s', 'Q8762s', 'Q8754s',
      'Q8753s', 'Q8752s', 'Q8743s', 'Q8742s', 'Q8732s', 'Q8654s', 'Q8653s',
      'Q8652s', 'Q8643s', 'Q8642s', 'Q8632s', 'Q8543s', 'Q8542s', 'Q8532s',
      'Q8432s', 'Q7654s', 'Q7653s', 'Q7652s', 'Q7643s', 'Q7642s', 'Q7632s',
      'Q7543s', 'Q7542s', 'Q7532s', 'Q7432s', 'Q6543s', 'Q6542s', 'Q6532s',
      'Q6432s', 'Q5432s', 'JT986s', 'JT985s', 'JT984s', 'JT983s', 'JT982s',
      'JT976s', 'JT975s', 'JT974s', 'JT973s', 'JT972s', 'JT965s', 'JT964s',
      'JT963s', 'JT962s', 'JT954s', 'JT953s', 'JT952s', 'JT943s', 'JT942s',
      'JT932s', 'JT876s', 'JT875s', 'JT874s', 'JT873s', 'JT872s', 'JT865s',
      'JT864s', 'JT863s', 'JT862s', 'JT854s', 'JT853s', 'JT852s', 'JT843s',
      'JT842s', 'JT832s', 'JT765s', 'JT764s', 'JT763s', 'JT762s', 'JT754s',
      'JT753s', 'JT752s', 'JT743s', 'JT742s', 'JT732s', 'JT654s', 'JT653s',
      'JT652s', 'JT643s', 'JT642s', 'JT632s', 'JT543s', 'JT542s', 'JT532s',
      'JT432s', 'J9876s', 'J9875s', 'J9874s', 'J9873s', 'J9872s', 'J9865s',
      'J9864s', 'J9863s', 'J9862s', 'J9854s', 'J9853s', 'J9852s', 'J9843s',
      'J9842s', 'J9832s', 'J9765s', 'J9764s', 'J9763s', 'J9762s', 'J9754s',
      'J9753s', 'J9752s', 'J9743s', 'J9742s', 'J9732s', 'J9654s', 'J9653s',
      'J9652s', 'J9643s', 'J9642s', 'J9632s', 'J9543s', 'J9542s', 'J9532s',
      'J9432s', 'J8765s', 'J8764s', 'J8763s', 'J8762s', 'J8754s', 'J8753s',
      'J8752s', 'J8743s', 'J8742s', 'J8732s', 'J8654s', 'J8653s', 'J8652s',
      'J8643s', 'J8642s', 'J8632s', 'J8543s', 'J8542s', 'J8532s', 'J8432s',
      'J7654s', 'J7653s', 'J7652s', 'J7643s', 'J7642s', 'J7632s', 'J7543s',
      'J7542s', 'J7532s', 'J7432s', 'J6543s', 'J6542s', 'J6532s', 'J6432s',
      'J5432s', 'T9875s', 'T9874s', 'T9873s', 'T9872s', 'T9865s', 'T9864s',
      'T9863s', 'T9862s', 'T9854s', 'T9853s', 'T9852s', 'T9843s', 'T9842s',
      'T9832s', 'T9765s', 'T9764s', 'T9763s', 'T9762s', 'T9754s', 'T9753s',
      'T9752s', 'T9743s', 'T9742s', 'T9732s', 'T9654s', 'T9653s', 'T9652s',
      'T9643s', 'T9642s', 'T9632s', 'T9543s', 'T9542s', 'T9532s', 'T9432s',
      'T8765s', 'T8764s', 'T8763s', 'T8762s', 'T8754s', 'T8753s', 'T8752s',
      'T8743s', 'T8742s', 'T8732s', 'T8654s', 'T8653s', 'T8652s', 'T8643s',
      'T8642s', 'T8632s', 'T8543s', 'T8542s', 'T8532s', 'T8432s', 'T7654s',
      'T7653s', 'T7652s', 'T7643s', 'T7642s', 'T7632s', 'T7543s', 'T7542s',
      'T7532s', 'T7432s', 'T6543s', 'T6542s', 'T6532s', 'T6432s', 'T5432s',
      '98764s', '98763s', '98762s', '98754s', '98753s', '98752s', '98743s',
      '98742s', '98732s', '98654s', '98653s', '98652s', '98643s', '98642s',
      '98632s', '98543s', '98542s', '98532s', '98432s', '97654s', '97653s',
      '97652s', '97643s', '97642s', '97632s', '97543s', '97542s', '97532s',
      '97432s', '96543s', '96542s', '96532s', '96432s', '95432s', '87653s',
      '87652s', '87643s', '87642s', '87632s', '87543s', '87542s', '87532s',
      '87432s', '86543s', '86542s', '86532s', '86432s', '85432s', '76542s',
      '76532s', '76432s', '75432s', 'AKQJT' , 'KQJT9' , 'QJT98' , 'JT987' ,
      'T9876' , '98765' , '87654' , '76543' , '65432' , 'A5432' , 'AAAKQ' ,
      'AAAKJ' , 'AAAKT' , 'AAAK9' , 'AAAK8' , 'AAAK7' , 'AAAK6' , 'AAAK5' ,
      'AAAK4' , 'AAAK3' , 'AAAK2' , 'AAAQJ' , 'AAAQT' , 'AAAQ9' , 'AAAQ8' ,
      'AAAQ7' , 'AAAQ6' , 'AAAQ5' , 'AAAQ4' , 'AAAQ3' , 'AAAQ2' , 'AAAJT' ,
      'AAAJ9' , 'AAAJ8' , 'AAAJ7' , 'AAAJ6' , 'AAAJ5' , 'AAAJ4' , 'AAAJ3' ,
      'AAAJ2' , 'AAAT9' , 'AAAT8' , 'AAAT7' , 'AAAT6' , 'AAAT5' , 'AAAT4' ,
      'AAAT3' , 'AAAT2' , 'AAA98' , 'AAA97' , 'AAA96' , 'AAA95' , 'AAA94' ,
      'AAA93' , 'AAA92' , 'AAA87' , 'AAA86' , 'AAA85' , 'AAA84' , 'AAA83' ,
      'AAA82' , 'AAA76' , 'AAA75' , 'AAA74' , 'AAA73' , 'AAA72' , 'AAA65' ,
      'AAA64' , 'AAA63' , 'AAA62' , 'AAA54' , 'AAA53' , 'AAA52' , 'AAA43' ,
      'AAA42' , 'AAA32' , 'AKKKQ' , 'AKKKJ' , 'AKKKT' , 'AKKK9' , 'AKKK8' ,
      'AKKK7' , 'AKKK6' , 'AKKK5' , 'AKKK4' , 'AKKK3' , 'AKKK2' , 'KKKQJ' ,
      'KKKQT' , 'KKKQ9' , 'KKKQ8' , 'KKKQ7' , 'KKKQ6' , 'KKKQ5' , 'KKKQ4' ,
      'KKKQ3' , 'KKKQ2' , 'KKKJT' , 'KKKJ9' , 'KKKJ8' , 'KKKJ7' , 'KKKJ6' ,
      'KKKJ5' , 'KKKJ4' , 'KKKJ3' , 'KKKJ2' , 'KKKT9' , 'KKKT8' , 'KKKT7' ,
      'KKKT6' , 'KKKT5' , 'KKKT4' , 'KKKT3' , 'KKKT2' , 'KKK98' , 'KKK97' ,
      'KKK96' , 'KKK95' , 'KKK94' , 'KKK93' , 'KKK92' , 'KKK87' , 'KKK86' ,
      'KKK85' , 'KKK84' , 'KKK83' , 'KKK82' , 'KKK76' , 'KKK75' , 'KKK74' ,
      'KKK73' , 'KKK72' , 'KKK65' , 'KKK64' , 'KKK63' , 'KKK62' , 'KKK54' ,
      'KKK53' , 'KKK52' , 'KKK43' , 'KKK42' , 'KKK32' , 'AKQQQ' , 'AQQQJ' ,
      'AQQQT' , 'AQQQ9' , 'AQQQ8' , 'AQQQ7' , 'AQQQ6' , 'AQQQ5' , 'AQQQ4' ,
      'AQQQ3' , 'AQQQ2' , 'KQQQJ' , 'KQQQT' , 'KQQQ9' , 'KQQQ8' , 'KQQQ7' ,
      'KQQQ6' , 'KQQQ5' , 'KQQQ4' , 'KQQQ3' , 'KQQQ2' , 'QQQJT' , 'QQQJ9' ,
      'QQQJ8' , 'QQQJ7' , 'QQQJ6' , 'QQQJ5' , 'QQQJ4' , 'QQQJ3' , 'QQQJ2' ,
      'QQQT9' , 'QQQT8' , 'QQQT7' , 'QQQT6' , 'QQQT5' , 'QQQT4' , 'QQQT3' ,
      'QQQT2' , 'QQQ98' , 'QQQ97' , 'QQQ96' , 'QQQ95' , 'QQQ94' , 'QQQ93' ,
      'QQQ92' , 'QQQ87' , 'QQQ86' , 'QQQ85' , 'QQQ84' , 'QQQ83' , 'QQQ82' ,
      'QQQ76' , 'QQQ75' , 'QQQ74' , 'QQQ73' , 'QQQ72' , 'QQQ65' , 'QQQ64' ,
      'QQQ63' , 'QQQ62' , 'QQQ54' , 'QQQ53' , 'QQQ52' , 'QQQ43' , 'QQQ42' ,
      'QQQ32' , 'AKJJJ' , 'AQJJJ' , 'AJJJT' , 'AJJJ9' , 'AJJJ8' , 'AJJJ7' ,
      'AJJJ6' , 'AJJJ5' , 'AJJJ4' , 'AJJJ3' , 'AJJJ2' , 'KQJJJ' , 'KJJJT' ,
      'KJJJ9' , 'KJJJ8' , 'KJJJ7' , 'KJJJ6' , 'KJJJ5' , 'KJJJ4' , 'KJJJ3' ,
      'KJJJ2' , 'QJJJT' , 'QJJJ9' , 'QJJJ8' , 'QJJJ7' , 'QJJJ6' , 'QJJJ5' ,
      'QJJJ4' , 'QJJJ3' , 'QJJJ2' , 'JJJT9' , 'JJJT8' , 'JJJT7' , 'JJJT6' ,
      'JJJT5' , 'JJJT4' , 'JJJT3' , 'JJJT2' , 'JJJ98' , 'JJJ97' , 'JJJ96' ,
      'JJJ95' , 'JJJ94' , 'JJJ93' , 'JJJ92' , 'JJJ87' , 'JJJ86' , 'JJJ85' ,
      'JJJ84' , 'JJJ83' , 'JJJ82' , 'JJJ76' , 'JJJ75' , 'JJJ74' , 'JJJ73' ,
      'JJJ72' , 'JJJ65' , 'JJJ64' , 'JJJ63' , 'JJJ62' , 'JJJ54' , 'JJJ53' ,
      'JJJ52' , 'JJJ43' , 'JJJ42' , 'JJJ32' , 'AKTTT' , 'AQTTT' , 'AJTTT' ,
      'ATTT9' , 'ATTT8' , 'ATTT7' , 'ATTT6' , 'ATTT5' , 'ATTT4' , 'ATTT3' ,
      'ATTT2' , 'KQTTT' , 'KJTTT' , 'KTTT9' , 'KTTT8' , 'KTTT7' , 'KTTT6' ,
      'KTTT5' , 'KTTT4' , 'KTTT3' , 'KTTT2' , 'QJTTT' , 'QTTT9' , 'QTTT8' ,
      'QTTT7' , 'QTTT6' , 'QTTT5' , 'QTTT4' , 'QTTT3' , 'QTTT2' , 'JTTT9' ,
      'JTTT8' , 'JTTT7' , 'JTTT6' , 'JTTT5' , 'JTTT4' , 'JTTT3' , 'JTTT2' ,
      'TTT98' , 'TTT97' , 'TTT96' , 'TTT95' , 'TTT94' , 'TTT93' , 'TTT92' ,
      'TTT87' , 'TTT86' , 'TTT85' , 'TTT84' , 'TTT83' , 'TTT82' , 'TTT76' ,
      'TTT75' , 'TTT74' , 'TTT73' , 'TTT72' , 'TTT65' , 'TTT64' , 'TTT63' ,
      'TTT62' , 'TTT54' , 'TTT53' , 'TTT52' , 'TTT43' , 'TTT42' , 'TTT32' ,
      'AK999' , 'AQ999' , 'AJ999' , 'AT999' , 'A9998' , 'A9997' , 'A9996' ,
      'A9995' , 'A9994' , 'A9993' , 'A9992' , 'KQ999' , 'KJ999' , 'KT999' ,
      'K9998' , 'K9997' , 'K9996' , 'K9995' , 'K9994' , 'K9993' , 'K9992' ,
      'QJ999' , 'QT999' , 'Q9998' , 'Q9997' , 'Q9996' , 'Q9995' , 'Q9994' ,
      'Q9993' , 'Q9992' , 'JT999' , 'J9998' , 'J9997' , 'J9996' , 'J9995' ,
      'J9994' , 'J9993' , 'J9992' , 'T9998' , 'T9997' , 'T9996' , 'T9995' ,
      'T9994' , 'T9993' , 'T9992' , '99987' , '99986' , '99985' , '99984' ,
      '99983' , '99982' , '99976' , '99975' , '99974' , '99973' , '99972' ,
      '99965' , '99964' , '99963' , '99962' , '99954' , '99953' , '99952' ,
      '99943' , '99942' , '99932' , 'AK888' , 'AQ888' , 'AJ888' , 'AT888' ,
      'A9888' , 'A8887' , 'A8886' , 'A8885' , 'A8884' , 'A8883' , 'A8882' ,
      'KQ888' , 'KJ888' , 'KT888' , 'K9888' , 'K8887' , 'K8886' , 'K8885' ,
      'K8884' , 'K8883' , 'K8882' , 'QJ888' , 'QT888' , 'Q9888' , 'Q8887' ,
      'Q8886' , 'Q8885' , 'Q8884' , 'Q8883' , 'Q8882' , 'JT888' , 'J9888' ,
      'J8887' , 'J8886' , 'J8885' , 'J8884' , 'J8883' , 'J8882' , 'T9888' ,
      'T8887' , 'T8886' , 'T8885' , 'T8884' , 'T8883' , 'T8882' , '98887' ,
      '98886' , '98885' , '98884' , '98883' , '98882' , '88876' , '88875' ,
      '88874' , '88873' , '88872' , '88865' , '88864' , '88863' , '88862' ,
      '88854' , '88853' , '88852' , '88843' , '88842' , '88832' , 'AK777' ,
      'AQ777' , 'AJ777' , 'AT777' , 'A9777' , 'A8777' , 'A7776' , 'A7775' ,
      'A7774' , 'A7773' , 'A7772' , 'KQ777' , 'KJ777' , 'KT777' , 'K9777' ,
      'K8777' , 'K7776' , 'K7775' , 'K7774' , 'K7773' , 'K7772' , 'QJ777' ,
      'QT777' , 'Q9777' , 'Q8777' , 'Q7776' , 'Q7775' , 'Q7774' , 'Q7773' ,
      'Q7772' , 'JT777' , 'J9777' , 'J8777' , 'J7776' , 'J7775' , 'J7774' ,
      'J7773' , 'J7772' , 'T9777' , 'T8777' , 'T7776' , 'T7775' , 'T7774' ,
      'T7773' , 'T7772' , '98777' , '97776' , '97775' , '97774' , '97773' ,
      '97772' , '87776' , '87775' , '87774' , '87773' , '87772' , '77765' ,
      '77764' , '77763' , '77762' , '77754' , '77753' , '77752' , '77743' ,
      '77742' , '77732' , 'AK666' , 'AQ666' , 'AJ666' , 'AT666' , 'A9666' ,
      'A8666' , 'A7666' , 'A6665' , 'A6664' , 'A6663' , 'A6662' , 'KQ666' ,
      'KJ666' , 'KT666' , 'K9666' , 'K8666' , 'K7666' , 'K6665' , 'K6664' ,
      'K6663' , 'K6662' , 'QJ666' , 'QT666' , 'Q9666' , 'Q8666' , 'Q7666' ,
      'Q6665' , 'Q6664' , 'Q6663' , 'Q6662' , 'JT666' , 'J9666' , 'J8666' ,
      'J7666' , 'J6665' , 'J6664' , 'J6663' , 'J6662' , 'T9666' , 'T8666' ,
      'T7666' , 'T6665' , 'T6664' , 'T6663' , 'T6662' , '98666' , '97666' ,
      '96665' , '96664' , '96663' , '96662' , '87666' , '86665' , '86664' ,
      '86663' , '86662' , '76665' , '76664' , '76663' , '76662' , '66654' ,
      '66653' , '66652' , '66643' , '66642' , '66632' , 'AK555' , 'AQ555' ,
      'AJ555' , 'AT555' , 'A9555' , 'A8555' , 'A7555' , 'A6555' , 'A5554' ,
      'A5553' , 'A5552' , 'KQ555' , 'KJ555' , 'KT555' , 'K9555' , 'K8555' ,
      'K7555' , 'K6555' , 'K5554' , 'K5553' , 'K5552' , 'QJ555' , 'QT555' ,
      'Q9555' , 'Q8555' , 'Q7555' , 'Q6555' , 'Q5554' , 'Q5553' , 'Q5552' ,
      'JT555' , 'J9555' , 'J8555' , 'J7555' , 'J6555' , 'J5554' , 'J5553' ,
      'J5552' , 'T9555' , 'T8555' , 'T7555' , 'T6555' , 'T5554' , 'T5553' ,
      'T5552' , '98555' , '97555' , '96555' , '95554' , '95553' , '95552' ,
      '87555' , '86555' , '85554' , '85553' , '85552' , '76555' , '75554' ,
      '75553' , '75552' , '65554' , '65553' , '65552' , '55543' , '55542' ,
      '55532' , 'AK444' , 'AQ444' , 'AJ444' , 'AT444' , 'A9444' , 'A8444' ,
      'A7444' , 'A6444' , 'A5444' , 'A4443' , 'A4442' , 'KQ444' , 'KJ444' ,
      'KT444' , 'K9444' , 'K8444' , 'K7444' , 'K6444' , 'K5444' , 'K4443' ,
      'K4442' , 'QJ444' , 'QT444' , 'Q9444' , 'Q8444' , 'Q7444' , 'Q6444' ,
      'Q5444' , 'Q4443' , 'Q4442' , 'JT444' , 'J9444' , 'J8444' , 'J7444' ,
      'J6444' , 'J5444' , 'J4443' , 'J4442' , 'T9444' , 'T8444' , 'T7444' ,
      'T6444' , 'T5444' , 'T4443' , 'T4442' , '98444' , '97444' , '96444' ,
      '95444' , '94443' , '94442' , '87444' , '86444' , '85444' , '84443' ,
      '84442' , '76444' , '75444' , '74443' , '74442' , '65444' , '64443' ,
      '64442' , '54443' , '54442' , '44432' , 'AK333' , 'AQ333' , 'AJ333' ,
      'AT333' , 'A9333' , 'A8333' , 'A7333' , 'A6333' , 'A5333' , 'A4333' ,
      'A3332' , 'KQ333' , 'KJ333' , 'KT333' , 'K9333' , 'K8333' , 'K7333' ,
      'K6333' , 'K5333' , 'K4333' , 'K3332' , 'QJ333' , 'QT333' , 'Q9333' ,
      'Q8333' , 'Q7333' , 'Q6333' , 'Q5333' , 'Q4333' , 'Q3332' , 'JT333' ,
      'J9333' , 'J8333' , 'J7333' , 'J6333' , 'J5333' , 'J4333' , 'J3332' ,
      'T9333' , 'T8333' , 'T7333' , 'T6333' , 'T5333' , 'T4333' , 'T3332' ,
      '98333' , '97333' , '96333' , '95333' , '94333' , '93332' , '87333' ,
      '86333' , '85333' , '84333' , '83332' , '76333' , '75333' , '74333' ,
      '73332' , '65333' , '64333' , '63332' , '54333' , '53332' , '43332' ,
      'AK222' , 'AQ222' , 'AJ222' , 'AT222' , 'A9222' , 'A8222' , 'A7222' ,
      'A6222' , 'A5222' , 'A4222' , 'A3222' , 'KQ222' , 'KJ222' , 'KT222' ,
      'K9222' , 'K8222' , 'K7222' , 'K6222' , 'K5222' , 'K4222' , 'K3222' ,
      'QJ222' , 'QT222' , 'Q9222' , 'Q8222' , 'Q7222' , 'Q6222' , 'Q5222' ,
      'Q4222' , 'Q3222' , 'JT222' , 'J9222' , 'J8222' , 'J7222' , 'J6222' ,
      'J5222' , 'J4222' , 'J3222' , 'T9222' , 'T8222' , 'T7222' , 'T6222' ,
      'T5222' , 'T4222' , 'T3222' , '98222' , '97222' , '96222' , '95222' ,
      '94222' , '93222' , '87222' , '86222' , '85222' , '84222' , '83222' ,
      '76222' , '75222' , '74222' , '73222' , '65222' , '64222' , '63222' ,
      '54222' , '53222' , '43222' , 'AAKKQ' , 'AAKKJ' , 'AAKKT' , 'AAKK9' ,
      'AAKK8' , 'AAKK7' , 'AAKK6' , 'AAKK5' , 'AAKK4' , 'AAKK3' , 'AAKK2' ,
      'AAKQQ' , 'AAQQJ' , 'AAQQT' , 'AAQQ9' , 'AAQQ8' , 'AAQQ7' , 'AAQQ6' ,
      'AAQQ5' , 'AAQQ4' , 'AAQQ3' , 'AAQQ2' , 'AAKJJ' , 'AAQJJ' , 'AAJJT' ,
      'AAJJ9' , 'AAJJ8' , 'AAJJ7' , 'AAJJ6' , 'AAJJ5' , 'AAJJ4' , 'AAJJ3' ,
      'AAJJ2' , 'AAKTT' , 'AAQTT' , 'AAJTT' , 'AATT9' , 'AATT8' , 'AATT7' ,
      'AATT6' , 'AATT5' , 'AATT4' , 'AATT3' , 'AATT2' , 'AAK99' , 'AAQ99' ,
      'AAJ99' , 'AAT99' , 'AA998' , 'AA997' , 'AA996' , 'AA995' , 'AA994' ,
      'AA993' , 'AA992' , 'AAK88' , 'AAQ88' , 'AAJ88' , 'AAT88' , 'AA988' ,
      'AA887' , 'AA886' , 'AA885' , 'AA884' , 'AA883' , 'AA882' , 'AAK77' ,
      'AAQ77' , 'AAJ77' , 'AAT77' , 'AA977' , 'AA877' , 'AA776' , 'AA775' ,
      'AA774' , 'AA773' , 'AA772' , 'AAK66' , 'AAQ66' , 'AAJ66' , 'AAT66' ,
      'AA966' , 'AA866' , 'AA766' , 'AA665' , 'AA664' , 'AA663' , 'AA662' ,
      'AAK55' , 'AAQ55' , 'AAJ55' , 'AAT55' , 'AA955' , 'AA855' , 'AA755' ,
      'AA655' , 'AA554' , 'AA553' , 'AA552' , 'AAK44' , 'AAQ44' , 'AAJ44' ,
      'AAT44' , 'AA944' , 'AA844' , 'AA744' , 'AA644' , 'AA544' , 'AA443' ,
      'AA442' , 'AAK33' , 'AAQ33' , 'AAJ33' , 'AAT33' , 'AA933' , 'AA833' ,
      'AA733' , 'AA633' , 'AA533' , 'AA433' , 'AA332' , 'AAK22' , 'AAQ22' ,
      'AAJ22' , 'AAT22' , 'AA922' , 'AA822' , 'AA722' , 'AA622' , 'AA522' ,
      'AA422' , 'AA322' , 'AKKQQ' , 'KKQQJ' , 'KKQQT' , 'KKQQ9' , 'KKQQ8' ,
      'KKQQ7' , 'KKQQ6' , 'KKQQ5' , 'KKQQ4' , 'KKQQ3' , 'KKQQ2' , 'AKKJJ' ,
      'KKQJJ' , 'KKJJT' , 'KKJJ9' , 'KKJJ8' , 'KKJJ7' , 'KKJJ6' , 'KKJJ5' ,
      'KKJJ4' , 'KKJJ3' , 'KKJJ2' , 'AKKTT' , 'KKQTT' , 'KKJTT' , 'KKTT9' ,
      'KKTT8' , 'KKTT7' , 'KKTT6' , 'KKTT5' , 'KKTT4' , 'KKTT3' , 'KKTT2' ,
      'AKK99' , 'KKQ99' , 'KKJ99' , 'KKT99' , 'KK998' , 'KK997' , 'KK996' ,
      'KK995' , 'KK994' , 'KK993' , 'KK992' , 'AKK88' , 'KKQ88' , 'KKJ88' ,
      'KKT88' , 'KK988' , 'KK887' , 'KK886' , 'KK885' , 'KK884' , 'KK883' ,
      'KK882' , 'AKK77' , 'KKQ77' , 'KKJ77' , 'KKT77' , 'KK977' , 'KK877' ,
      'KK776' , 'KK775' , 'KK774' , 'KK773' , 'KK772' , 'AKK66' , 'KKQ66' ,
      'KKJ66' , 'KKT66' , 'KK966' , 'KK866' , 'KK766' , 'KK665' , 'KK664' ,
      'KK663' , 'KK662' , 'AKK55' , 'KKQ55' , 'KKJ55' , 'KKT55' , 'KK955' ,
      'KK855' , 'KK755' , 'KK655' , 'KK554' , 'KK553' , 'KK552' , 'AKK44' ,
      'KKQ44' , 'KKJ44' , 'KKT44' , 'KK944' , 'KK844' , 'KK744' , 'KK644' ,
      'KK544' , 'KK443' , 'KK442' , 'AKK33' , 'KKQ33' , 'KKJ33' , 'KKT33' ,
      'KK933' , 'KK833' , 'KK733' , 'KK633' , 'KK533' , 'KK433' , 'KK332' ,
      'AKK22' , 'KKQ22' , 'KKJ22' , 'KKT22' , 'KK922' , 'KK822' , 'KK722' ,
      'KK622' , 'KK522' , 'KK422' , 'KK322' , 'AQQJJ' , 'KQQJJ' , 'QQJJT' ,
      'QQJJ9' , 'QQJJ8' , 'QQJJ7' , 'QQJJ6' , 'QQJJ5' , 'QQJJ4' , 'QQJJ3' ,
      'QQJJ2' , 'AQQTT' , 'KQQTT' , 'QQJTT' , 'QQTT9' , 'QQTT8' , 'QQTT7' ,
      'QQTT6' , 'QQTT5' , 'QQTT4' , 'QQTT3' , 'QQTT2' , 'AQQ99' , 'KQQ99' ,
      'QQJ99' , 'QQT99' , 'QQ998' , 'QQ997' , 'QQ996' , 'QQ995' , 'QQ994' ,
      'QQ993' , 'QQ992' , 'AQQ88' , 'KQQ88' , 'QQJ88' , 'QQT88' , 'QQ988' ,
      'QQ887' , 'QQ886' , 'QQ885' , 'QQ884' , 'QQ883' , 'QQ882' , 'AQQ77' ,
      'KQQ77' , 'QQJ77' , 'QQT77' , 'QQ977' , 'QQ877' , 'QQ776' , 'QQ775' ,
      'QQ774' , 'QQ773' , 'QQ772' , 'AQQ66' , 'KQQ66' , 'QQJ66' , 'QQT66' ,
      'QQ966' , 'QQ866' , 'QQ766' , 'QQ665' , 'QQ664' , 'QQ663' , 'QQ662' ,
      'AQQ55' , 'KQQ55' , 'QQJ55' , 'QQT55' , 'QQ955' , 'QQ855' , 'QQ755' ,
      'QQ655' , 'QQ554' , 'QQ553' , 'QQ552' , 'AQQ44' , 'KQQ44' , 'QQJ44' ,
      'QQT44' , 'QQ944' , 'QQ844' , 'QQ744' , 'QQ644' , 'QQ544' , 'QQ443' ,
      'QQ442' , 'AQQ33' , 'KQQ33' , 'QQJ33' , 'QQT33' , 'QQ933' , 'QQ833' ,
      'QQ733' , 'QQ633' , 'QQ533' , 'QQ433' , 'QQ332' , 'AQQ22' , 'KQQ22' ,
      'QQJ22' , 'QQT22' , 'QQ922' , 'QQ822' , 'QQ722' , 'QQ622' , 'QQ522' ,
      'QQ422' , 'QQ322' , 'AJJTT' , 'KJJTT' , 'QJJTT' , 'JJTT9' , 'JJTT8' ,
      'JJTT7' , 'JJTT6' , 'JJTT5' , 'JJTT4' , 'JJTT3' , 'JJTT2' , 'AJJ99' ,
      'KJJ99' , 'QJJ99' , 'JJT99' , 'JJ998' , 'JJ997' , 'JJ996' , 'JJ995' ,
      'JJ994' , 'JJ993' , 'JJ992' , 'AJJ88' , 'KJJ88' , 'QJJ88' , 'JJT88' ,
      'JJ988' , 'JJ887' , 'JJ886' , 'JJ885' , 'JJ884' , 'JJ883' , 'JJ882' ,
      'AJJ77' , 'KJJ77' , 'QJJ77' , 'JJT77' , 'JJ977' , 'JJ877' , 'JJ776' ,
      'JJ775' , 'JJ774' , 'JJ773' , 'JJ772' , 'AJJ66' , 'KJJ66' , 'QJJ66' ,
      'JJT66' , 'JJ966' , 'JJ866' , 'JJ766' , 'JJ665' , 'JJ664' , 'JJ663' ,
      'JJ662' , 'AJJ55' , 'KJJ55' , 'QJJ55' , 'JJT55' , 'JJ955' , 'JJ855' ,
      'JJ755' , 'JJ655' , 'JJ554' , 'JJ553' , 'JJ552' , 'AJJ44' , 'KJJ44' ,
      'QJJ44' , 'JJT44' , 'JJ944' , 'JJ844' , 'JJ744' , 'JJ644' , 'JJ544' ,
      'JJ443' , 'JJ442' , 'AJJ33' , 'KJJ33' , 'QJJ33' , 'JJT33' , 'JJ933' ,
      'JJ833' , 'JJ733' , 'JJ633' , 'JJ533' , 'JJ433' , 'JJ332' , 'AJJ22' ,
      'KJJ22' , 'QJJ22' , 'JJT22' , 'JJ922' , 'JJ822' , 'JJ722' , 'JJ622' ,
      'JJ522' , 'JJ422' , 'JJ322' , 'ATT99' , 'KTT99' , 'QTT99' , 'JTT99' ,
      'TT998' , 'TT997' , 'TT996' , 'TT995' , 'TT994' , 'TT993' , 'TT992' ,
      'ATT88' , 'KTT88' , 'QTT88' , 'JTT88' , 'TT988' , 'TT887' , 'TT886' ,
      'TT885' , 'TT884' , 'TT883' , 'TT882' , 'ATT77' , 'KTT77' , 'QTT77' ,
      'JTT77' , 'TT977' , 'TT877' , 'TT776' , 'TT775' , 'TT774' , 'TT773' ,
      'TT772' , 'ATT66' , 'KTT66' , 'QTT66' , 'JTT66' , 'TT966' , 'TT866' ,
      'TT766' , 'TT665' , 'TT664' , 'TT663' , 'TT662' , 'ATT55' , 'KTT55' ,
      'QTT55' , 'JTT55' , 'TT955' , 'TT855' , 'TT755' , 'TT655' , 'TT554' ,
      'TT553' , 'TT552' , 'ATT44' , 'KTT44' , 'QTT44' , 'JTT44' , 'TT944' ,
      'TT844' , 'TT744' , 'TT644' , 'TT544' , 'TT443' , 'TT442' , 'ATT33' ,
      'KTT33' , 'QTT33' , 'JTT33' , 'TT933' , 'TT833' , 'TT733' , 'TT633' ,
      'TT533' , 'TT433' , 'TT332' , 'ATT22' , 'KTT22' , 'QTT22' , 'JTT22' ,
      'TT922' , 'TT822' , 'TT722' , 'TT622' , 'TT522' , 'TT422' , 'TT322' ,
      'A9988' , 'K9988' , 'Q9988' , 'J9988' , 'T9988' , '99887' , '99886' ,
      '99885' , '99884' , '99883' , '99882' , 'A9977' , 'K9977' , 'Q9977' ,
      'J9977' , 'T9977' , '99877' , '99776' , '99775' , '99774' , '99773' ,
      '99772' , 'A9966' , 'K9966' , 'Q9966' , 'J9966' , 'T9966' , '99866' ,
      '99766' , '99665' , '99664' , '99663' , '99662' , 'A9955' , 'K9955' ,
      'Q9955' , 'J9955' , 'T9955' , '99855' , '99755' , '99655' , '99554' ,
      '99553' , '99552' , 'A9944' , 'K9944' , 'Q9944' , 'J9944' , 'T9944' ,
      '99844' , '99744' , '99644' , '99544' , '99443' , '99442' , 'A9933' ,
      'K9933' , 'Q9933' , 'J9933' , 'T9933' , '99833' , '99733' , '99633' ,
      '99533' , '99433' , '99332' , 'A9922' , 'K9922' , 'Q9922' , 'J9922' ,
      'T9922' , '99822' , '99722' , '99622' , '99522' , '99422' , '99322' ,
      'A8877' , 'K8877' , 'Q8877' , 'J8877' , 'T8877' , '98877' , '88776' ,
      '88775' , '88774' , '88773' , '88772' , 'A8866' , 'K8866' , 'Q8866' ,
      'J8866' , 'T8866' , '98866' , '88766' , '88665' , '88664' , '88663' ,
      '88662' , 'A8855' , 'K8855' , 'Q8855' , 'J8855' , 'T8855' , '98855' ,
      '88755' , '88655' , '88554' , '88553' , '88552' , 'A8844' , 'K8844' ,
      'Q8844' , 'J8844' , 'T8844' , '98844' , '88744' , '88644' , '88544' ,
      '88443' , '88442' , 'A8833' , 'K8833' , 'Q8833' , 'J8833' , 'T8833' ,
      '98833' , '88733' , '88633' , '88533' , '88433' , '88332' , 'A8822' ,
      'K8822' , 'Q8822' , 'J8822' , 'T8822' , '98822' , '88722' , '88622' ,
      '88522' , '88422' , '88322' , 'A7766' , 'K7766' , 'Q7766' , 'J7766' ,
      'T7766' , '97766' , '87766' , '77665' , '77664' , '77663' , '77662' ,
      'A7755' , 'K7755' , 'Q7755' , 'J7755' , 'T7755' , '97755' , '87755' ,
      '77655' , '77554' , '77553' , '77552' , 'A7744' , 'K7744' , 'Q7744' ,
      'J7744' , 'T7744' , '97744' , '87744' , '77644' , '77544' , '77443' ,
      '77442' , 'A7733' , 'K7733' , 'Q7733' , 'J7733' , 'T7733' , '97733' ,
      '87733' , '77633' , '77533' , '77433' , '77332' , 'A7722' , 'K7722' ,
      'Q7722' , 'J7722' , 'T7722' , '97722' , '87722' , '77622' , '77522' ,
      '77422' , '77322' , 'A6655' , 'K6655' , 'Q6655' , 'J6655' , 'T6655' ,
      '96655' , '86655' , '76655' , '66554' , '66553' , '66552' , 'A6644' ,
      'K6644' , 'Q6644' , 'J6644' , 'T6644' , '96644' , '86644' , '76644' ,
      '66544' , '66443' , '66442' , 'A6633' , 'K6633' , 'Q6633' , 'J6633' ,
      'T6633' , '96633' , '86633' , '76633' , '66533' , '66433' , '66332' ,
      'A6622' , 'K6622' , 'Q6622' , 'J6622' , 'T6622' , '96622' , '86622' ,
      '76622' , '66522' , '66422' , '66322' , 'A5544' , 'K5544' , 'Q5544' ,
      'J5544' , 'T5544' , '95544' , '85544' , '75544' , '65544' , '55443' ,
      '55442' , 'A5533' , 'K5533' , 'Q5533' , 'J5533' , 'T5533' , '95533' ,
      '85533' , '75533' , '65533' , '55433' , '55332' , 'A5522' , 'K5522' ,
      'Q5522' , 'J5522' , 'T5522' , '95522' , '85522' , '75522' , '65522' ,
      '55422' , '55322' , 'A4433' , 'K4433' , 'Q4433' , 'J4433' , 'T4433' ,
      '94433' , '84433' , '74433' , '64433' , '54433' , '44332' , 'A4422' ,
      'K4422' , 'Q4422' , 'J4422' , 'T4422' , '94422' , '84422' , '74422' ,
      '64422' , '54422' , '44322' , 'A3322' , 'K3322' , 'Q3322' , 'J3322' ,
      'T3322' , '93322' , '83322' , '73322' , '63322' , '53322' , '43322' ,
      'AAKQJ' , 'AAKQT' , 'AAKQ9' , 'AAKQ8' , 'AAKQ7' , 'AAKQ6' , 'AAKQ5' ,
      'AAKQ4' , 'AAKQ3' , 'AAKQ2' , 'AAKJT' , 'AAKJ9' , 'AAKJ8' , 'AAKJ7' ,
      'AAKJ6' , 'AAKJ5' , 'AAKJ4' , 'AAKJ3' , 'AAKJ2' , 'AAKT9' , 'AAKT8' ,
      'AAKT7' , 'AAKT6' , 'AAKT5' , 'AAKT4' , 'AAKT3' , 'AAKT2' , 'AAK98' ,
      'AAK97' , 'AAK96' , 'AAK95' , 'AAK94' , 'AAK93' , 'AAK92' , 'AAK87' ,
      'AAK86' , 'AAK85' , 'AAK84' , 'AAK83' , 'AAK82' , 'AAK76' , 'AAK75' ,
      'AAK74' , 'AAK73' , 'AAK72' , 'AAK65' , 'AAK64' , 'AAK63' , 'AAK62' ,
      'AAK54' , 'AAK53' , 'AAK52' , 'AAK43' , 'AAK42' , 'AAK32' , 'AAQJT' ,
      'AAQJ9' , 'AAQJ8' , 'AAQJ7' , 'AAQJ6' , 'AAQJ5' , 'AAQJ4' , 'AAQJ3' ,
      'AAQJ2' , 'AAQT9' , 'AAQT8' , 'AAQT7' , 'AAQT6' , 'AAQT5' , 'AAQT4' ,
      'AAQT3' , 'AAQT2' , 'AAQ98' , 'AAQ97' , 'AAQ96' , 'AAQ95' , 'AAQ94' ,
      'AAQ93' , 'AAQ92' , 'AAQ87' , 'AAQ86' , 'AAQ85' , 'AAQ84' , 'AAQ83' ,
      'AAQ82' , 'AAQ76' , 'AAQ75' , 'AAQ74' , 'AAQ73' , 'AAQ72' , 'AAQ65' ,
      'AAQ64' , 'AAQ63' , 'AAQ62' , 'AAQ54' , 'AAQ53' , 'AAQ52' , 'AAQ43' ,
      'AAQ42' , 'AAQ32' , 'AAJT9' , 'AAJT8' , 'AAJT7' , 'AAJT6' , 'AAJT5' ,
      'AAJT4' , 'AAJT3' , 'AAJT2' , 'AAJ98' , 'AAJ97' , 'AAJ96' , 'AAJ95' ,
      'AAJ94' , 'AAJ93' , 'AAJ92' , 'AAJ87' , 'AAJ86' , 'AAJ85' , 'AAJ84' ,
      'AAJ83' , 'AAJ82' , 'AAJ76' , 'AAJ75' , 'AAJ74' , 'AAJ73' , 'AAJ72' ,
      'AAJ65' , 'AAJ64' , 'AAJ63' , 'AAJ62' , 'AAJ54' , 'AAJ53' , 'AAJ52' ,
      'AAJ43' , 'AAJ42' , 'AAJ32' , 'AAT98' , 'AAT97' , 'AAT96' , 'AAT95' ,
      'AAT94' , 'AAT93' , 'AAT92' , 'AAT87' , 'AAT86' , 'AAT85' , 'AAT84' ,
      'AAT83' , 'AAT82' , 'AAT76' , 'AAT75' , 'AAT74' , 'AAT73' , 'AAT72' ,
      'AAT65' , 'AAT64' , 'AAT63' , 'AAT62' , 'AAT54' , 'AAT53' , 'AAT52' ,
      'AAT43' , 'AAT42' , 'AAT32' , 'AA987' , 'AA986' , 'AA985' , 'AA984' ,
      'AA983' , 'AA982' , 'AA976' , 'AA975' , 'AA974' , 'AA973' , 'AA972' ,
      'AA965' , 'AA964' , 'AA963' , 'AA962' , 'AA954' , 'AA953' , 'AA952' ,
      'AA943' , 'AA942' , 'AA932' , 'AA876' , 'AA875' , 'AA874' , 'AA873' ,
      'AA872' , 'AA865' , 'AA864' , 'AA863' , 'AA862' , 'AA854' , 'AA853' ,
      'AA852' , 'AA843' , 'AA842' , 'AA832' , 'AA765' , 'AA764' , 'AA763' ,
      'AA762' , 'AA754' , 'AA753' , 'AA752' , 'AA743' , 'AA742' , 'AA732' ,
      'AA654' , 'AA653' , 'AA652' , 'AA643' , 'AA642' , 'AA632' , 'AA543' ,
      'AA542' , 'AA532' , 'AA432' , 'AKKQJ' , 'AKKQT' , 'AKKQ9' , 'AKKQ8' ,
      'AKKQ7' , 'AKKQ6' , 'AKKQ5' , 'AKKQ4' , 'AKKQ3' , 'AKKQ2' , 'AKKJT' ,
      'AKKJ9' , 'AKKJ8' , 'AKKJ7' , 'AKKJ6' , 'AKKJ5' , 'AKKJ4' , 'AKKJ3' ,
      'AKKJ2' , 'AKKT9' , 'AKKT8' , 'AKKT7' , 'AKKT6' , 'AKKT5' , 'AKKT4' ,
      'AKKT3' , 'AKKT2' , 'AKK98' , 'AKK97' , 'AKK96' , 'AKK95' , 'AKK94' ,
      'AKK93' , 'AKK92' , 'AKK87' , 'AKK86' , 'AKK85' , 'AKK84' , 'AKK83' ,
      'AKK82' , 'AKK76' , 'AKK75' , 'AKK74' , 'AKK73' , 'AKK72' , 'AKK65' ,
      'AKK64' , 'AKK63' , 'AKK62' , 'AKK54' , 'AKK53' , 'AKK52' , 'AKK43' ,
      'AKK42' , 'AKK32' , 'KKQJT' , 'KKQJ9' , 'KKQJ8' , 'KKQJ7' , 'KKQJ6' ,
      'KKQJ5' , 'KKQJ4' , 'KKQJ3' , 'KKQJ2' , 'KKQT9' , 'KKQT8' , 'KKQT7' ,
      'KKQT6' , 'KKQT5' , 'KKQT4' , 'KKQT3' , 'KKQT2' , 'KKQ98' , 'KKQ97' ,
      'KKQ96' , 'KKQ95' , 'KKQ94' , 'KKQ93' , 'KKQ92' , 'KKQ87' , 'KKQ86' ,
      'KKQ85' , 'KKQ84' , 'KKQ83' , 'KKQ82' , 'KKQ76' , 'KKQ75' , 'KKQ74' ,
      'KKQ73' , 'KKQ72' , 'KKQ65' , 'KKQ64' , 'KKQ63' , 'KKQ62' , 'KKQ54' ,
      'KKQ53' , 'KKQ52' , 'KKQ43' , 'KKQ42' , 'KKQ32' , 'KKJT9' , 'KKJT8' ,
      'KKJT7' , 'KKJT6' , 'KKJT5' , 'KKJT4' , 'KKJT3' , 'KKJT2' , 'KKJ98' ,
      'KKJ97' , 'KKJ96' , 'KKJ95' , 'KKJ94' , 'KKJ93' , 'KKJ92' , 'KKJ87' ,
      'KKJ86' , 'KKJ85' , 'KKJ84' , 'KKJ83' , 'KKJ82' , 'KKJ76' , 'KKJ75' ,
      'KKJ74' , 'KKJ73' , 'KKJ72' , 'KKJ65' , 'KKJ64' , 'KKJ63' , 'KKJ62' ,
      'KKJ54' , 'KKJ53' , 'KKJ52' , 'KKJ43' , 'KKJ42' , 'KKJ32' , 'KKT98' ,
      'KKT97' , 'KKT96' , 'KKT95' , 'KKT94' , 'KKT93' , 'KKT92' , 'KKT87' ,
      'KKT86' , 'KKT85' , 'KKT84' , 'KKT83' , 'KKT82' , 'KKT76' , 'KKT75' ,
      'KKT74' , 'KKT73' , 'KKT72' , 'KKT65' , 'KKT64' , 'KKT63' , 'KKT62' ,
      'KKT54' , 'KKT53' , 'KKT52' , 'KKT43' , 'KKT42' , 'KKT32' , 'KK987' ,
      'KK986' , 'KK985' , 'KK984' , 'KK983' , 'KK982' , 'KK976' , 'KK975' ,
      'KK974' , 'KK973' , 'KK972' , 'KK965' , 'KK964' , 'KK963' , 'KK962' ,
      'KK954' , 'KK953' , 'KK952' , 'KK943' , 'KK942' , 'KK932' , 'KK876' ,
      'KK875' , 'KK874' , 'KK873' , 'KK872' , 'KK865' , 'KK864' , 'KK863' ,
      'KK862' , 'KK854' , 'KK853' , 'KK852' , 'KK843' , 'KK842' , 'KK832' ,
      'KK765' , 'KK764' , 'KK763' , 'KK762' , 'KK754' , 'KK753' , 'KK752' ,
      'KK743' , 'KK742' , 'KK732' , 'KK654' , 'KK653' , 'KK652' , 'KK643' ,
      'KK642' , 'KK632' , 'KK543' , 'KK542' , 'KK532' , 'KK432' , 'AKQQJ' ,
      'AKQQT' , 'AKQQ9' , 'AKQQ8' , 'AKQQ7' , 'AKQQ6' , 'AKQQ5' , 'AKQQ4' ,
      'AKQQ3' , 'AKQQ2' , 'AQQJT' , 'AQQJ9' , 'AQQJ8' , 'AQQJ7' , 'AQQJ6' ,
      'AQQJ5' , 'AQQJ4' , 'AQQJ3' , 'AQQJ2' , 'AQQT9' , 'AQQT8' , 'AQQT7' ,
      'AQQT6' , 'AQQT5' , 'AQQT4' , 'AQQT3' , 'AQQT2' , 'AQQ98' , 'AQQ97' ,
      'AQQ96' , 'AQQ95' , 'AQQ94' , 'AQQ93' , 'AQQ92' , 'AQQ87' , 'AQQ86' ,
      'AQQ85' , 'AQQ84' , 'AQQ83' , 'AQQ82' , 'AQQ76' , 'AQQ75' , 'AQQ74' ,
      'AQQ73' , 'AQQ72' , 'AQQ65' , 'AQQ64' , 'AQQ63' , 'AQQ62' , 'AQQ54' ,
      'AQQ53' , 'AQQ52' , 'AQQ43' , 'AQQ42' , 'AQQ32' , 'KQQJT' , 'KQQJ9' ,
      'KQQJ8' , 'KQQJ7' , 'KQQJ6' , 'KQQJ5' , 'KQQJ4' , 'KQQJ3' , 'KQQJ2' ,
      'KQQT9' , 'KQQT8' , 'KQQT7' , 'KQQT6' , 'KQQT5' , 'KQQT4' , 'KQQT3' ,
      'KQQT2' , 'KQQ98' , 'KQQ97' , 'KQQ96' , 'KQQ95' , 'KQQ94' , 'KQQ93' ,
      'KQQ92' , 'KQQ87' , 'KQQ86' , 'KQQ85' , 'KQQ84' , 'KQQ83' , 'KQQ82' ,
      'KQQ76' , 'KQQ75' , 'KQQ74' , 'KQQ73' , 'KQQ72' , 'KQQ65' , 'KQQ64' ,
      'KQQ63' , 'KQQ62' , 'KQQ54' , 'KQQ53' , 'KQQ52' , 'KQQ43' , 'KQQ42' ,
      'KQQ32' , 'QQJT9' , 'QQJT8' , 'QQJT7' , 'QQJT6' , 'QQJT5' , 'QQJT4' ,
      'QQJT3' , 'QQJT2' , 'QQJ98' , 'QQJ97' , 'QQJ96' , 'QQJ95' , 'QQJ94' ,
      'QQJ93' , 'QQJ92' , 'QQJ87' , 'QQJ86' , 'QQJ85' , 'QQJ84' , 'QQJ83' ,
      'QQJ82' , 'QQJ76' , 'QQJ75' , 'QQJ74' , 'QQJ73' , 'QQJ72' , 'QQJ65' ,
      'QQJ64' , 'QQJ63' , 'QQJ62' , 'QQJ54' , 'QQJ53' , 'QQJ52' , 'QQJ43' ,
      'QQJ42' , 'QQJ32' , 'QQT98' , 'QQT97' , 'QQT96' , 'QQT95' , 'QQT94' ,
      'QQT93' , 'QQT92' , 'QQT87' , 'QQT86' , 'QQT85' , 'QQT84' , 'QQT83' ,
      'QQT82' , 'QQT76' , 'QQT75' , 'QQT74' , 'QQT73' , 'QQT72' , 'QQT65' ,
      'QQT64' , 'QQT63' , 'QQT62' , 'QQT54' , 'QQT53' , 'QQT52' , 'QQT43' ,
      'QQT42' , 'QQT32' , 'QQ987' , 'QQ986' , 'QQ985' , 'QQ984' , 'QQ983' ,
      'QQ982' , 'QQ976' , 'QQ975' , 'QQ974' , 'QQ973' , 'QQ972' , 'QQ965' ,
      'QQ964' , 'QQ963' , 'QQ962' , 'QQ954' , 'QQ953' , 'QQ952' , 'QQ943' ,
      'QQ942' , 'QQ932' , 'QQ876' , 'QQ875' , 'QQ874' , 'QQ873' , 'QQ872' ,
      'QQ865' , 'QQ864' , 'QQ863' , 'QQ862' , 'QQ854' , 'QQ853' , 'QQ852' ,
      'QQ843' , 'QQ842' , 'QQ832' , 'QQ765' , 'QQ764' , 'QQ763' , 'QQ762' ,
      'QQ754' , 'QQ753' , 'QQ752' , 'QQ743' , 'QQ742' , 'QQ732' , 'QQ654' ,
      'QQ653' , 'QQ652' , 'QQ643' , 'QQ642' , 'QQ632' , 'QQ543' , 'QQ542' ,
      'QQ532' , 'QQ432' , 'AKQJJ' , 'AKJJT' , 'AKJJ9' , 'AKJJ8' , 'AKJJ7' ,
      'AKJJ6' , 'AKJJ5' , 'AKJJ4' , 'AKJJ3' , 'AKJJ2' , 'AQJJT' , 'AQJJ9' ,
      'AQJJ8' , 'AQJJ7' , 'AQJJ6' , 'AQJJ5' , 'AQJJ4' , 'AQJJ3' , 'AQJJ2' ,
      'AJJT9' , 'AJJT8' , 'AJJT7' , 'AJJT6' , 'AJJT5' , 'AJJT4' , 'AJJT3' ,
      'AJJT2' , 'AJJ98' , 'AJJ97' , 'AJJ96' , 'AJJ95' , 'AJJ94' , 'AJJ93' ,
      'AJJ92' , 'AJJ87' , 'AJJ86' , 'AJJ85' , 'AJJ84' , 'AJJ83' , 'AJJ82' ,
      'AJJ76' , 'AJJ75' , 'AJJ74' , 'AJJ73' , 'AJJ72' , 'AJJ65' , 'AJJ64' ,
      'AJJ63' , 'AJJ62' , 'AJJ54' , 'AJJ53' , 'AJJ52' , 'AJJ43' , 'AJJ42' ,
      'AJJ32' , 'KQJJT' , 'KQJJ9' , 'KQJJ8' , 'KQJJ7' , 'KQJJ6' , 'KQJJ5' ,
      'KQJJ4' , 'KQJJ3' , 'KQJJ2' , 'KJJT9' , 'KJJT8' , 'KJJT7' , 'KJJT6' ,
      'KJJT5' , 'KJJT4' , 'KJJT3' , 'KJJT2' , 'KJJ98' , 'KJJ97' , 'KJJ96' ,
      'KJJ95' , 'KJJ94' , 'KJJ93' , 'KJJ92' , 'KJJ87' , 'KJJ86' , 'KJJ85' ,
      'KJJ84' , 'KJJ83' , 'KJJ82' , 'KJJ76' , 'KJJ75' , 'KJJ74' , 'KJJ73' ,
      'KJJ72' , 'KJJ65' , 'KJJ64' , 'KJJ63' , 'KJJ62' , 'KJJ54' , 'KJJ53' ,
      'KJJ52' , 'KJJ43' , 'KJJ42' , 'KJJ32' , 'QJJT9' , 'QJJT8' , 'QJJT7' ,
      'QJJT6' , 'QJJT5' , 'QJJT4' , 'QJJT3' , 'QJJT2' , 'QJJ98' , 'QJJ97' ,
      'QJJ96' , 'QJJ95' , 'QJJ94' , 'QJJ93' , 'QJJ92' , 'QJJ87' , 'QJJ86' ,
      'QJJ85' , 'QJJ84' , 'QJJ83' , 'QJJ82' , 'QJJ76' , 'QJJ75' , 'QJJ74' ,
      'QJJ73' , 'QJJ72' , 'QJJ65' , 'QJJ64' , 'QJJ63' , 'QJJ62' , 'QJJ54' ,
      'QJJ53' , 'QJJ52' , 'QJJ43' , 'QJJ42' , 'QJJ32' , 'JJT98' , 'JJT97' ,
      'JJT96' , 'JJT95' , 'JJT94' , 'JJT93' , 'JJT92' , 'JJT87' , 'JJT86' ,
      'JJT85' , 'JJT84' , 'JJT83' , 'JJT82' , 'JJT76' , 'JJT75' , 'JJT74' ,
      'JJT73' , 'JJT72' , 'JJT65' , 'JJT64' , 'JJT63' , 'JJT62' , 'JJT54' ,
      'JJT53' , 'JJT52' , 'JJT43' , 'JJT42' , 'JJT32' , 'JJ987' , 'JJ986' ,
      'JJ985' , 'JJ984' , 'JJ983' , 'JJ982' , 'JJ976' , 'JJ975' , 'JJ974' ,
      'JJ973' , 'JJ972' , 'JJ965' , 'JJ964' , 'JJ963' , 'JJ962' , 'JJ954' ,
      'JJ953' , 'JJ952' , 'JJ943' , 'JJ942' , 'JJ932' , 'JJ876' , 'JJ875' ,
      'JJ874' , 'JJ873' , 'JJ872' , 'JJ865' , 'JJ864' , 'JJ863' , 'JJ862' ,
      'JJ854' , 'JJ853' , 'JJ852' , 'JJ843' , 'JJ842' , 'JJ832' , 'JJ765' ,
      'JJ764' , 'JJ763' , 'JJ762' , 'JJ754' , 'JJ753' , 'JJ752' , 'JJ743' ,
      'JJ742' , 'JJ732' , 'JJ654' , 'JJ653' , 'JJ652' , 'JJ643' , 'JJ642' ,
      'JJ632' , 'JJ543' , 'JJ542' , 'JJ532' , 'JJ432' , 'AKQTT' , 'AKJTT' ,
      'AKTT9' , 'AKTT8' , 'AKTT7' , 'AKTT6' , 'AKTT5' , 'AKTT4' , 'AKTT3' ,
      'AKTT2' , 'AQJTT' , 'AQTT9' , 'AQTT8' , 'AQTT7' , 'AQTT6' , 'AQTT5' ,
      'AQTT4' , 'AQTT3' , 'AQTT2' , 'AJTT9' , 'AJTT8' , 'AJTT7' , 'AJTT6' ,
      'AJTT5' , 'AJTT4' , 'AJTT3' , 'AJTT2' , 'ATT98' , 'ATT97' , 'ATT96' ,
      'ATT95' , 'ATT94' , 'ATT93' , 'ATT92' , 'ATT87' , 'ATT86' , 'ATT85' ,
      'ATT84' , 'ATT83' , 'ATT82' , 'ATT76' , 'ATT75' , 'ATT74' , 'ATT73' ,
      'ATT72' , 'ATT65' , 'ATT64' , 'ATT63' , 'ATT62' , 'ATT54' , 'ATT53' ,
      'ATT52' , 'ATT43' , 'ATT42' , 'ATT32' , 'KQJTT' , 'KQTT9' , 'KQTT8' ,
      'KQTT7' , 'KQTT6' , 'KQTT5' , 'KQTT4' , 'KQTT3' , 'KQTT2' , 'KJTT9' ,
      'KJTT8' , 'KJTT7' , 'KJTT6' , 'KJTT5' , 'KJTT4' , 'KJTT3' , 'KJTT2' ,
      'KTT98' , 'KTT97' , 'KTT96' , 'KTT95' , 'KTT94' , 'KTT93' , 'KTT92' ,
      'KTT87' , 'KTT86' , 'KTT85' , 'KTT84' , 'KTT83' , 'KTT82' , 'KTT76' ,
      'KTT75' , 'KTT74' , 'KTT73' , 'KTT72' , 'KTT65' , 'KTT64' , 'KTT63' ,
      'KTT62' , 'KTT54' , 'KTT53' , 'KTT52' , 'KTT43' , 'KTT42' , 'KTT32' ,
      'QJTT9' , 'QJTT8' , 'QJTT7' , 'QJTT6' , 'QJTT5' , 'QJTT4' , 'QJTT3' ,
      'QJTT2' , 'QTT98' , 'QTT97' , 'QTT96' , 'QTT95' , 'QTT94' , 'QTT93' ,
      'QTT92' , 'QTT87' , 'QTT86' , 'QTT85' , 'QTT84' , 'QTT83' , 'QTT82' ,
      'QTT76' , 'QTT75' , 'QTT74' , 'QTT73' , 'QTT72' , 'QTT65' , 'QTT64' ,
      'QTT63' , 'QTT62' , 'QTT54' , 'QTT53' , 'QTT52' , 'QTT43' , 'QTT42' ,
      'QTT32' , 'JTT98' , 'JTT97' , 'JTT96' , 'JTT95' , 'JTT94' , 'JTT93' ,
      'JTT92' , 'JTT87' , 'JTT86' , 'JTT85' , 'JTT84' , 'JTT83' , 'JTT82' ,
      'JTT76' , 'JTT75' , 'JTT74' , 'JTT73' , 'JTT72' , 'JTT65' , 'JTT64' ,
      'JTT63' , 'JTT62' , 'JTT54' , 'JTT53' , 'JTT52' , 'JTT43' , 'JTT42' ,
      'JTT32' , 'TT987' , 'TT986' , 'TT985' , 'TT984' , 'TT983' , 'TT982' ,
      'TT976' , 'TT975' , 'TT974' , 'TT973' , 'TT972' , 'TT965' , 'TT964' ,
      'TT963' , 'TT962' , 'TT954' , 'TT953' , 'TT952' , 'TT943' , 'TT942' ,
      'TT932' , 'TT876' , 'TT875' , 'TT874' , 'TT873' , 'TT872' , 'TT865' ,
      'TT864' , 'TT863' , 'TT862' , 'TT854' , 'TT853' , 'TT852' , 'TT843' ,
      'TT842' , 'TT832' , 'TT765' , 'TT764' , 'TT763' , 'TT762' , 'TT754' ,
      'TT753' , 'TT752' , 'TT743' , 'TT742' , 'TT732' , 'TT654' , 'TT653' ,
      'TT652' , 'TT643' , 'TT642' , 'TT632' , 'TT543' , 'TT542' , 'TT532' ,
      'TT432' , 'AKQ99' , 'AKJ99' , 'AKT99' , 'AK998' , 'AK997' , 'AK996' ,
      'AK995' , 'AK994' , 'AK993' , 'AK992' , 'AQJ99' , 'AQT99' , 'AQ998' ,
      'AQ997' , 'AQ996' , 'AQ995' , 'AQ994' , 'AQ993' , 'AQ992' , 'AJT99' ,
      'AJ998' , 'AJ997' , 'AJ996' , 'AJ995' , 'AJ994' , 'AJ993' , 'AJ992' ,
      'AT998' , 'AT997' , 'AT996' , 'AT995' , 'AT994' , 'AT993' , 'AT992' ,
      'A9987' , 'A9986' , 'A9985' , 'A9984' , 'A9983' , 'A9982' , 'A9976' ,
      'A9975' , 'A9974' , 'A9973' , 'A9972' , 'A9965' , 'A9964' , 'A9963' ,
      'A9962' , 'A9954' , 'A9953' , 'A9952' , 'A9943' , 'A9942' , 'A9932' ,
      'KQJ99' , 'KQT99' , 'KQ998' , 'KQ997' , 'KQ996' , 'KQ995' , 'KQ994' ,
      'KQ993' , 'KQ992' , 'KJT99' , 'KJ998' , 'KJ997' , 'KJ996' , 'KJ995' ,
      'KJ994' , 'KJ993' , 'KJ992' , 'KT998' , 'KT997' , 'KT996' , 'KT995' ,
      'KT994' , 'KT993' , 'KT992' , 'K9987' , 'K9986' , 'K9985' , 'K9984' ,
      'K9983' , 'K9982' , 'K9976' , 'K9975' , 'K9974' , 'K9973' , 'K9972' ,
      'K9965' , 'K9964' , 'K9963' , 'K9962' , 'K9954' , 'K9953' , 'K9952' ,
      'K9943' , 'K9942' , 'K9932' , 'QJT99' , 'QJ998' , 'QJ997' , 'QJ996' ,
      'QJ995' , 'QJ994' , 'QJ993' , 'QJ992' , 'QT998' , 'QT997' , 'QT996' ,
      'QT995' , 'QT994' , 'QT993' , 'QT992' , 'Q9987' , 'Q9986' , 'Q9985' ,
      'Q9984' , 'Q9983' , 'Q9982' , 'Q9976' , 'Q9975' , 'Q9974' , 'Q9973' ,
      'Q9972' , 'Q9965' , 'Q9964' , 'Q9963' , 'Q9962' , 'Q9954' , 'Q9953' ,
      'Q9952' , 'Q9943' , 'Q9942' , 'Q9932' , 'JT998' , 'JT997' , 'JT996' ,
      'JT995' , 'JT994' , 'JT993' , 'JT992' , 'J9987' , 'J9986' , 'J9985' ,
      'J9984' , 'J9983' , 'J9982' , 'J9976' , 'J9975' , 'J9974' , 'J9973' ,
      'J9972' , 'J9965' , 'J9964' , 'J9963' , 'J9962' , 'J9954' , 'J9953' ,
      'J9952' , 'J9943' , 'J9942' , 'J9932' , 'T9987' , 'T9986' , 'T9985' ,
      'T9984' , 'T9983' , 'T9982' , 'T9976' , 'T9975' , 'T9974' , 'T9973' ,
      'T9972' , 'T9965' , 'T9964' , 'T9963' , 'T9962' , 'T9954' , 'T9953' ,
      'T9952' , 'T9943' , 'T9942' , 'T9932' , '99876' , '99875' , '99874' ,
      '99873' , '99872' , '99865' , '99864' , '99863' , '99862' , '99854' ,
      '99853' , '99852' , '99843' , '99842' , '99832' , '99765' , '99764' ,
      '99763' , '99762' , '99754' , '99753' , '99752' , '99743' , '99742' ,
      '99732' , '99654' , '99653' , '99652' , '99643' , '99642' , '99632' ,
      '99543' , '99542' , '99532' , '99432' , 'AKQ88' , 'AKJ88' , 'AKT88' ,
      'AK988' , 'AK887' , 'AK886' , 'AK885' , 'AK884' , 'AK883' , 'AK882' ,
      'AQJ88' , 'AQT88' , 'AQ988' , 'AQ887' , 'AQ886' , 'AQ885' , 'AQ884' ,
      'AQ883' , 'AQ882' , 'AJT88' , 'AJ988' , 'AJ887' , 'AJ886' , 'AJ885' ,
      'AJ884' , 'AJ883' , 'AJ882' , 'AT988' , 'AT887' , 'AT886' , 'AT885' ,
      'AT884' , 'AT883' , 'AT882' , 'A9887' , 'A9886' , 'A9885' , 'A9884' ,
      'A9883' , 'A9882' , 'A8876' , 'A8875' , 'A8874' , 'A8873' , 'A8872' ,
      'A8865' , 'A8864' , 'A8863' , 'A8862' , 'A8854' , 'A8853' , 'A8852' ,
      'A8843' , 'A8842' , 'A8832' , 'KQJ88' , 'KQT88' , 'KQ988' , 'KQ887' ,
      'KQ886' , 'KQ885' , 'KQ884' , 'KQ883' , 'KQ882' , 'KJT88' , 'KJ988' ,
      'KJ887' , 'KJ886' , 'KJ885' , 'KJ884' , 'KJ883' , 'KJ882' , 'KT988' ,
      'KT887' , 'KT886' , 'KT885' , 'KT884' , 'KT883' , 'KT882' , 'K9887' ,
      'K9886' , 'K9885' , 'K9884' , 'K9883' , 'K9882' , 'K8876' , 'K8875' ,
      'K8874' , 'K8873' , 'K8872' , 'K8865' , 'K8864' , 'K8863' , 'K8862' ,
      'K8854' , 'K8853' , 'K8852' , 'K8843' , 'K8842' , 'K8832' , 'QJT88' ,
      'QJ988' , 'QJ887' , 'QJ886' , 'QJ885' , 'QJ884' , 'QJ883' , 'QJ882' ,
      'QT988' , 'QT887' , 'QT886' , 'QT885' , 'QT884' , 'QT883' , 'QT882' ,
      'Q9887' , 'Q9886' , 'Q9885' , 'Q9884' , 'Q9883' , 'Q9882' , 'Q8876' ,
      'Q8875' , 'Q8874' , 'Q8873' , 'Q8872' , 'Q8865' , 'Q8864' , 'Q8863' ,
      'Q8862' , 'Q8854' , 'Q8853' , 'Q8852' , 'Q8843' , 'Q8842' , 'Q8832' ,
      'JT988' , 'JT887' , 'JT886' , 'JT885' , 'JT884' , 'JT883' , 'JT882' ,
      'J9887' , 'J9886' , 'J9885' , 'J9884' , 'J9883' , 'J9882' , 'J8876' ,
      'J8875' , 'J8874' , 'J8873' , 'J8872' , 'J8865' , 'J8864' , 'J8863' ,
      'J8862' , 'J8854' , 'J8853' , 'J8852' , 'J8843' , 'J8842' , 'J8832' ,
      'T9887' , 'T9886' , 'T9885' , 'T9884' , 'T9883' , 'T9882' , 'T8876' ,
      'T8875' , 'T8874' , 'T8873' , 'T8872' , 'T8865' , 'T8864' , 'T8863' ,
      'T8862' , 'T8854' , 'T8853' , 'T8852' , 'T8843' , 'T8842' , 'T8832' ,
      '98876' , '98875' , '98874' , '98873' , '98872' , '98865' , '98864' ,
      '98863' , '98862' , '98854' , '98853' , '98852' , '98843' , '98842' ,
      '98832' , '88765' , '88764' , '88763' , '88762' , '88754' , '88753' ,
      '88752' , '88743' , '88742' , '88732' , '88654' , '88653' , '88652' ,
      '88643' , '88642' , '88632' , '88543' , '88542' , '88532' , '88432' ,
      'AKQ77' , 'AKJ77' , 'AKT77' , 'AK977' , 'AK877' , 'AK776' , 'AK775' ,
      'AK774' , 'AK773' , 'AK772' , 'AQJ77' , 'AQT77' , 'AQ977' , 'AQ877' ,
      'AQ776' , 'AQ775' , 'AQ774' , 'AQ773' , 'AQ772' , 'AJT77' , 'AJ977' ,
      'AJ877' , 'AJ776' , 'AJ775' , 'AJ774' , 'AJ773' , 'AJ772' , 'AT977' ,
      'AT877' , 'AT776' , 'AT775' , 'AT774' , 'AT773' , 'AT772' , 'A9877' ,
      'A9776' , 'A9775' , 'A9774' , 'A9773' , 'A9772' , 'A8776' , 'A8775' ,
      'A8774' , 'A8773' , 'A8772' , 'A7765' , 'A7764' , 'A7763' , 'A7762' ,
      'A7754' , 'A7753' , 'A7752' , 'A7743' , 'A7742' , 'A7732' , 'KQJ77' ,
      'KQT77' , 'KQ977' , 'KQ877' , 'KQ776' , 'KQ775' , 'KQ774' , 'KQ773' ,
      'KQ772' , 'KJT77' , 'KJ977' , 'KJ877' , 'KJ776' , 'KJ775' , 'KJ774' ,
      'KJ773' , 'KJ772' , 'KT977' , 'KT877' , 'KT776' , 'KT775' , 'KT774' ,
      'KT773' , 'KT772' , 'K9877' , 'K9776' , 'K9775' , 'K9774' , 'K9773' ,
      'K9772' , 'K8776' , 'K8775' , 'K8774' , 'K8773' , 'K8772' , 'K7765' ,
      'K7764' , 'K7763' , 'K7762' , 'K7754' , 'K7753' , 'K7752' , 'K7743' ,
      'K7742' , 'K7732' , 'QJT77' , 'QJ977' , 'QJ877' , 'QJ776' , 'QJ775' ,
      'QJ774' , 'QJ773' , 'QJ772' , 'QT977' , 'QT877' , 'QT776' , 'QT775' ,
      'QT774' , 'QT773' , 'QT772' , 'Q9877' , 'Q9776' , 'Q9775' , 'Q9774' ,
      'Q9773' , 'Q9772' , 'Q8776' , 'Q8775' , 'Q8774' , 'Q8773' , 'Q8772' ,
      'Q7765' , 'Q7764' , 'Q7763' , 'Q7762' , 'Q7754' , 'Q7753' , 'Q7752' ,
      'Q7743' , 'Q7742' , 'Q7732' , 'JT977' , 'JT877' , 'JT776' , 'JT775' ,
      'JT774' , 'JT773' , 'JT772' , 'J9877' , 'J9776' , 'J9775' , 'J9774' ,
      'J9773' , 'J9772' , 'J8776' , 'J8775' , 'J8774' , 'J8773' , 'J8772' ,
      'J7765' , 'J7764' , 'J7763' , 'J7762' , 'J7754' , 'J7753' , 'J7752' ,
      'J7743' , 'J7742' , 'J7732' , 'T9877' , 'T9776' , 'T9775' , 'T9774' ,
      'T9773' , 'T9772' , 'T8776' , 'T8775' , 'T8774' , 'T8773' , 'T8772' ,
      'T7765' , 'T7764' , 'T7763' , 'T7762' , 'T7754' , 'T7753' , 'T7752' ,
      'T7743' , 'T7742' , 'T7732' , '98776' , '98775' , '98774' , '98773' ,
      '98772' , '97765' , '97764' , '97763' , '97762' , '97754' , '97753' ,
      '97752' , '97743' , '97742' , '97732' , '87765' , '87764' , '87763' ,
      '87762' , '87754' , '87753' , '87752' , '87743' , '87742' , '87732' ,
      '77654' , '77653' , '77652' , '77643' , '77642' , '77632' , '77543' ,
      '77542' , '77532' , '77432' , 'AKQ66' , 'AKJ66' , 'AKT66' , 'AK966' ,
      'AK866' , 'AK766' , 'AK665' , 'AK664' , 'AK663' , 'AK662' , 'AQJ66' ,
      'AQT66' , 'AQ966' , 'AQ866' , 'AQ766' , 'AQ665' , 'AQ664' , 'AQ663' ,
      'AQ662' , 'AJT66' , 'AJ966' , 'AJ866' , 'AJ766' , 'AJ665' , 'AJ664' ,
      'AJ663' , 'AJ662' , 'AT966' , 'AT866' , 'AT766' , 'AT665' , 'AT664' ,
      'AT663' , 'AT662' , 'A9866' , 'A9766' , 'A9665' , 'A9664' , 'A9663' ,
      'A9662' , 'A8766' , 'A8665' , 'A8664' , 'A8663' , 'A8662' , 'A7665' ,
      'A7664' , 'A7663' , 'A7662' , 'A6654' , 'A6653' , 'A6652' , 'A6643' ,
      'A6642' , 'A6632' , 'KQJ66' , 'KQT66' , 'KQ966' , 'KQ866' , 'KQ766' ,
      'KQ665' , 'KQ664' , 'KQ663' , 'KQ662' , 'KJT66' , 'KJ966' , 'KJ866' ,
      'KJ766' , 'KJ665' , 'KJ664' , 'KJ663' , 'KJ662' , 'KT966' , 'KT866' ,
      'KT766' , 'KT665' , 'KT664' , 'KT663' , 'KT662' , 'K9866' , 'K9766' ,
      'K9665' , 'K9664' , 'K9663' , 'K9662' , 'K8766' , 'K8665' , 'K8664' ,
      'K8663' , 'K8662' , 'K7665' , 'K7664' , 'K7663' , 'K7662' , 'K6654' ,
      'K6653' , 'K6652' , 'K6643' , 'K6642' , 'K6632' , 'QJT66' , 'QJ966' ,
      'QJ866' , 'QJ766' , 'QJ665' , 'QJ664' , 'QJ663' , 'QJ662' , 'QT966' ,
      'QT866' , 'QT766' , 'QT665' , 'QT664' , 'QT663' , 'QT662' , 'Q9866' ,
      'Q9766' , 'Q9665' , 'Q9664' , 'Q9663' , 'Q9662' , 'Q8766' , 'Q8665' ,
      'Q8664' , 'Q8663' , 'Q8662' , 'Q7665' , 'Q7664' , 'Q7663' , 'Q7662' ,
      'Q6654' , 'Q6653' , 'Q6652' , 'Q6643' , 'Q6642' , 'Q6632' , 'JT966' ,
      'JT866' , 'JT766' , 'JT665' , 'JT664' , 'JT663' , 'JT662' , 'J9866' ,
      'J9766' , 'J9665' , 'J9664' , 'J9663' , 'J9662' , 'J8766' , 'J8665' ,
      'J8664' , 'J8663' , 'J8662' , 'J7665' , 'J7664' , 'J7663' , 'J7662' ,
      'J6654' , 'J6653' , 'J6652' , 'J6643' , 'J6642' , 'J6632' , 'T9866' ,
      'T9766' , 'T9665' , 'T9664' , 'T9663' , 'T9662' , 'T8766' , 'T8665' ,
      'T8664' , 'T8663' , 'T8662' , 'T7665' , 'T7664' , 'T7663' , 'T7662' ,
      'T6654' , 'T6653' , 'T6652' , 'T6643' , 'T6642' , 'T6632' , '98766' ,
      '98665' , '98664' , '98663' , '98662' , '97665' , '97664' , '97663' ,
      '97662' , '96654' , '96653' , '96652' , '96643' , '96642' , '96632' ,
      '87665' , '87664' , '87663' , '87662' , '86654' , '86653' , '86652' ,
      '86643' , '86642' , '86632' , '76654' , '76653' , '76652' , '76643' ,
      '76642' , '76632' , '66543' , '66542' , '66532' , '66432' , 'AKQ55' ,
      'AKJ55' , 'AKT55' , 'AK955' , 'AK855' , 'AK755' , 'AK655' , 'AK554' ,
      'AK553' , 'AK552' , 'AQJ55' , 'AQT55' , 'AQ955' , 'AQ855' , 'AQ755' ,
      'AQ655' , 'AQ554' , 'AQ553' , 'AQ552' , 'AJT55' , 'AJ955' , 'AJ855' ,
      'AJ755' , 'AJ655' , 'AJ554' , 'AJ553' , 'AJ552' , 'AT955' , 'AT855' ,
      'AT755' , 'AT655' , 'AT554' , 'AT553' , 'AT552' , 'A9855' , 'A9755' ,
      'A9655' , 'A9554' , 'A9553' , 'A9552' , 'A8755' , 'A8655' , 'A8554' ,
      'A8553' , 'A8552' , 'A7655' , 'A7554' , 'A7553' , 'A7552' , 'A6554' ,
      'A6553' , 'A6552' , 'A5543' , 'A5542' , 'A5532' , 'KQJ55' , 'KQT55' ,
      'KQ955' , 'KQ855' , 'KQ755' , 'KQ655' , 'KQ554' , 'KQ553' , 'KQ552' ,
      'KJT55' , 'KJ955' , 'KJ855' , 'KJ755' , 'KJ655' , 'KJ554' , 'KJ553' ,
      'KJ552' , 'KT955' , 'KT855' , 'KT755' , 'KT655' , 'KT554' , 'KT553' ,
      'KT552' , 'K9855' , 'K9755' , 'K9655' , 'K9554' , 'K9553' , 'K9552' ,
      'K8755' , 'K8655' , 'K8554' , 'K8553' , 'K8552' , 'K7655' , 'K7554' ,
      'K7553' , 'K7552' , 'K6554' , 'K6553' , 'K6552' , 'K5543' , 'K5542' ,
      'K5532' , 'QJT55' , 'QJ955' , 'QJ855' , 'QJ755' , 'QJ655' , 'QJ554' ,
      'QJ553' , 'QJ552' , 'QT955' , 'QT855' , 'QT755' , 'QT655' , 'QT554' ,
      'QT553' , 'QT552' , 'Q9855' , 'Q9755' , 'Q9655' , 'Q9554' , 'Q9553' ,
      'Q9552' , 'Q8755' , 'Q8655' , 'Q8554' , 'Q8553' , 'Q8552' , 'Q7655' ,
      'Q7554' , 'Q7553' , 'Q7552' , 'Q6554' , 'Q6553' , 'Q6552' , 'Q5543' ,
      'Q5542' , 'Q5532' , 'JT955' , 'JT855' , 'JT755' , 'JT655' , 'JT554' ,
      'JT553' , 'JT552' , 'J9855' , 'J9755' , 'J9655' , 'J9554' , 'J9553' ,
      'J9552' , 'J8755' , 'J8655' , 'J8554' , 'J8553' , 'J8552' , 'J7655' ,
      'J7554' , 'J7553' , 'J7552' , 'J6554' , 'J6553' , 'J6552' , 'J5543' ,
      'J5542' , 'J5532' , 'T9855' , 'T9755' , 'T9655' , 'T9554' , 'T9553' ,
      'T9552' , 'T8755' , 'T8655' , 'T8554' , 'T8553' , 'T8552' , 'T7655' ,
      'T7554' , 'T7553' , 'T7552' , 'T6554' , 'T6553' , 'T6552' , 'T5543' ,
      'T5542' , 'T5532' , '98755' , '98655' , '98554' , '98553' , '98552' ,
      '97655' , '97554' , '97553' , '97552' , '96554' , '96553' , '96552' ,
      '95543' , '95542' , '95532' , '87655' , '87554' , '87553' , '87552' ,
      '86554' , '86553' , '86552' , '85543' , '85542' , '85532' , '76554' ,
      '76553' , '76552' , '75543' , '75542' , '75532' , '65543' , '65542' ,
      '65532' , '55432' , 'AKQ44' , 'AKJ44' , 'AKT44' , 'AK944' , 'AK844' ,
      'AK744' , 'AK644' , 'AK544' , 'AK443' , 'AK442' , 'AQJ44' , 'AQT44' ,
      'AQ944' , 'AQ844' , 'AQ744' , 'AQ644' , 'AQ544' , 'AQ443' , 'AQ442' ,
      'AJT44' , 'AJ944' , 'AJ844' , 'AJ744' , 'AJ644' , 'AJ544' , 'AJ443' ,
      'AJ442' , 'AT944' , 'AT844' , 'AT744' , 'AT644' , 'AT544' , 'AT443' ,
      'AT442' , 'A9844' , 'A9744' , 'A9644' , 'A9544' , 'A9443' , 'A9442' ,
      'A8744' , 'A8644' , 'A8544' , 'A8443' , 'A8442' , 'A7644' , 'A7544' ,
      'A7443' , 'A7442' , 'A6544' , 'A6443' , 'A6442' , 'A5443' , 'A5442' ,
      'A4432' , 'KQJ44' , 'KQT44' , 'KQ944' , 'KQ844' , 'KQ744' , 'KQ644' ,
      'KQ544' , 'KQ443' , 'KQ442' , 'KJT44' , 'KJ944' , 'KJ844' , 'KJ744' ,
      'KJ644' , 'KJ544' , 'KJ443' , 'KJ442' , 'KT944' , 'KT844' , 'KT744' ,
      'KT644' , 'KT544' , 'KT443' , 'KT442' , 'K9844' , 'K9744' , 'K9644' ,
      'K9544' , 'K9443' , 'K9442' , 'K8744' , 'K8644' , 'K8544' , 'K8443' ,
      'K8442' , 'K7644' , 'K7544' , 'K7443' , 'K7442' , 'K6544' , 'K6443' ,
      'K6442' , 'K5443' , 'K5442' , 'K4432' , 'QJT44' , 'QJ944' , 'QJ844' ,
      'QJ744' , 'QJ644' , 'QJ544' , 'QJ443' , 'QJ442' , 'QT944' , 'QT844' ,
      'QT744' , 'QT644' , 'QT544' , 'QT443' , 'QT442' , 'Q9844' , 'Q9744' ,
      'Q9644' , 'Q9544' , 'Q9443' , 'Q9442' , 'Q8744' , 'Q8644' , 'Q8544' ,
      'Q8443' , 'Q8442' , 'Q7644' , 'Q7544' , 'Q7443' , 'Q7442' , 'Q6544' ,
      'Q6443' , 'Q6442' , 'Q5443' , 'Q5442' , 'Q4432' , 'JT944' , 'JT844' ,
      'JT744' , 'JT644' , 'JT544' , 'JT443' , 'JT442' , 'J9844' , 'J9744' ,
      'J9644' , 'J9544' , 'J9443' , 'J9442' , 'J8744' , 'J8644' , 'J8544' ,
      'J8443' , 'J8442' , 'J7644' , 'J7544' , 'J7443' , 'J7442' , 'J6544' ,
      'J6443' , 'J6442' , 'J5443' , 'J5442' , 'J4432' , 'T9844' , 'T9744' ,
      'T9644' , 'T9544' , 'T9443' , 'T9442' , 'T8744' , 'T8644' , 'T8544' ,
      'T8443' , 'T8442' , 'T7644' , 'T7544' , 'T7443' , 'T7442' , 'T6544' ,
      'T6443' , 'T6442' , 'T5443' , 'T5442' , 'T4432' , '98744' , '98644' ,
      '98544' , '98443' , '98442' , '97644' , '97544' , '97443' , '97442' ,
      '96544' , '96443' , '96442' , '95443' , '95442' , '94432' , '87644' ,
      '87544' , '87443' , '87442' , '86544' , '86443' , '86442' , '85443' ,
      '85442' , '84432' , '76544' , '76443' , '76442' , '75443' , '75442' ,
      '74432' , '65443' , '65442' , '64432' , '54432' , 'AKQ33' , 'AKJ33' ,
      'AKT33' , 'AK933' , 'AK833' , 'AK733' , 'AK633' , 'AK533' , 'AK433' ,
      'AK332' , 'AQJ33' , 'AQT33' , 'AQ933' , 'AQ833' , 'AQ733' , 'AQ633' ,
      'AQ533' , 'AQ433' , 'AQ332' , 'AJT33' , 'AJ933' , 'AJ833' , 'AJ733' ,
      'AJ633' , 'AJ533' , 'AJ433' , 'AJ332' , 'AT933' , 'AT833' , 'AT733' ,
      'AT633' , 'AT533' , 'AT433' , 'AT332' , 'A9833' , 'A9733' , 'A9633' ,
      'A9533' , 'A9433' , 'A9332' , 'A8733' , 'A8633' , 'A8533' , 'A8433' ,
      'A8332' , 'A7633' , 'A7533' , 'A7433' , 'A7332' , 'A6533' , 'A6433' ,
      'A6332' , 'A5433' , 'A5332' , 'A4332' , 'KQJ33' , 'KQT33' , 'KQ933' ,
      'KQ833' , 'KQ733' , 'KQ633' , 'KQ533' , 'KQ433' , 'KQ332' , 'KJT33' ,
      'KJ933' , 'KJ833' , 'KJ733' , 'KJ633' , 'KJ533' , 'KJ433' , 'KJ332' ,
      'KT933' , 'KT833' , 'KT733' , 'KT633' , 'KT533' , 'KT433' , 'KT332' ,
      'K9833' , 'K9733' , 'K9633' , 'K9533' , 'K9433' , 'K9332' , 'K8733' ,
      'K8633' , 'K8533' , 'K8433' , 'K8332' , 'K7633' , 'K7533' , 'K7433' ,
      'K7332' , 'K6533' , 'K6433' , 'K6332' , 'K5433' , 'K5332' , 'K4332' ,
      'QJT33' , 'QJ933' , 'QJ833' , 'QJ733' , 'QJ633' , 'QJ533' , 'QJ433' ,
      'QJ332' , 'QT933' , 'QT833' , 'QT733' , 'QT633' , 'QT533' , 'QT433' ,
      'QT332' , 'Q9833' , 'Q9733' , 'Q9633' , 'Q9533' , 'Q9433' , 'Q9332' ,
      'Q8733' , 'Q8633' , 'Q8533' , 'Q8433' , 'Q8332' , 'Q7633' , 'Q7533' ,
      'Q7433' , 'Q7332' , 'Q6533' , 'Q6433' , 'Q6332' , 'Q5433' , 'Q5332' ,
      'Q4332' , 'JT933' , 'JT833' , 'JT733' , 'JT633' , 'JT533' , 'JT433' ,
      'JT332' , 'J9833' , 'J9733' , 'J9633' , 'J9533' , 'J9433' , 'J9332' ,
      'J8733' , 'J8633' , 'J8533' , 'J8433' , 'J8332' , 'J7633' , 'J7533' ,
      'J7433' , 'J7332' , 'J6533' , 'J6433' , 'J6332' , 'J5433' , 'J5332' ,
      'J4332' , 'T9833' , 'T9733' , 'T9633' , 'T9533' , 'T9433' , 'T9332' ,
      'T8733' , 'T8633' , 'T8533' , 'T8433' , 'T8332' , 'T7633' , 'T7533' ,
      'T7433' , 'T7332' , 'T6533' , 'T6433' , 'T6332' , 'T5433' , 'T5332' ,
      'T4332' , '98733' , '98633' , '98533' , '98433' , '98332' , '97633' ,
      '97533' , '97433' , '97332' , '96533' , '96433' , '96332' , '95433' ,
      '95332' , '94332' , '87633' , '87533' , '87433' , '87332' , '86533' ,
      '86433' , '86332' , '85433' , '85332' , '84332' , '76533' , '76433' ,
      '76332' , '75433' , '75332' , '74332' , '65433' , '65332' , '64332' ,
      '54332' , 'AKQ22' , 'AKJ22' , 'AKT22' , 'AK922' , 'AK822' , 'AK722' ,
      'AK622' , 'AK522' , 'AK422' , 'AK322' , 'AQJ22' , 'AQT22' , 'AQ922' ,
      'AQ822' , 'AQ722' , 'AQ622' , 'AQ522' , 'AQ422' , 'AQ322' , 'AJT22' ,
      'AJ922' , 'AJ822' , 'AJ722' , 'AJ622' , 'AJ522' , 'AJ422' , 'AJ322' ,
      'AT922' , 'AT822' , 'AT722' , 'AT622' , 'AT522' , 'AT422' , 'AT322' ,
      'A9822' , 'A9722' , 'A9622' , 'A9522' , 'A9422' , 'A9322' , 'A8722' ,
      'A8622' , 'A8522' , 'A8422' , 'A8322' , 'A7622' , 'A7522' , 'A7422' ,
      'A7322' , 'A6522' , 'A6422' , 'A6322' , 'A5422' , 'A5322' , 'A4322' ,
      'KQJ22' , 'KQT22' , 'KQ922' , 'KQ822' , 'KQ722' , 'KQ622' , 'KQ522' ,
      'KQ422' , 'KQ322' , 'KJT22' , 'KJ922' , 'KJ822' , 'KJ722' , 'KJ622' ,
      'KJ522' , 'KJ422' , 'KJ322' , 'KT922' , 'KT822' , 'KT722' , 'KT622' ,
      'KT522' , 'KT422' , 'KT322' , 'K9822' , 'K9722' , 'K9622' , 'K9522' ,
      'K9422' , 'K9322' , 'K8722' , 'K8622' , 'K8522' , 'K8422' , 'K8322' ,
      'K7622' , 'K7522' , 'K7422' , 'K7322' , 'K6522' , 'K6422' , 'K6322' ,
      'K5422' , 'K5322' , 'K4322' , 'QJT22' , 'QJ922' , 'QJ822' , 'QJ722' ,
      'QJ622' , 'QJ522' , 'QJ422' , 'QJ322' , 'QT922' , 'QT822' , 'QT722' ,
      'QT622' , 'QT522' , 'QT422' , 'QT322' , 'Q9822' , 'Q9722' , 'Q9622' ,
      'Q9522' , 'Q9422' , 'Q9322' , 'Q8722' , 'Q8622' , 'Q8522' , 'Q8422' ,
      'Q8322' , 'Q7622' , 'Q7522' , 'Q7422' , 'Q7322' , 'Q6522' , 'Q6422' ,
      'Q6322' , 'Q5422' , 'Q5322' , 'Q4322' , 'JT922' , 'JT822' , 'JT722' ,
      'JT622' , 'JT522' , 'JT422' , 'JT322' , 'J9822' , 'J9722' , 'J9622' ,
      'J9522' , 'J9422' , 'J9322' , 'J8722' , 'J8622' , 'J8522' , 'J8422' ,
      'J8322' , 'J7622' , 'J7522' , 'J7422' , 'J7322' , 'J6522' , 'J6422' ,
      'J6322' , 'J5422' , 'J5322' , 'J4322' , 'T9822' , 'T9722' , 'T9622' ,
      'T9522' , 'T9422' , 'T9322' , 'T8722' , 'T8622' , 'T8522' , 'T8422' ,
      'T8322' , 'T7622' , 'T7522' , 'T7422' , 'T7322' , 'T6522' , 'T6422' ,
      'T6322' , 'T5422' , 'T5322' , 'T4322' , '98722' , '98622' , '98522' ,
      '98422' , '98322' , '97622' , '97522' , '97422' , '97322' , '96522' ,
      '96422' , '96322' , '95422' , '95322' , '94322' , '87622' , '87522' ,
      '87422' , '87322' , '86522' , '86422' , '86322' , '85422' , '85322' ,
      '84322' , '76522' , '76422' , '76322' , '75422' , '75322' , '74322' ,
      '65422' , '65322' , '64322' , '54322' , 'AKQJ9' , 'AKQJ8' , 'AKQJ7' ,
      'AKQJ6' , 'AKQJ5' , 'AKQJ4' , 'AKQJ3' , 'AKQJ2' , 'AKQT9' , 'AKQT8' ,
      'AKQT7' , 'AKQT6' , 'AKQT5' , 'AKQT4' , 'AKQT3' , 'AKQT2' , 'AKQ98' ,
      'AKQ97' , 'AKQ96' , 'AKQ95' , 'AKQ94' , 'AKQ93' , 'AKQ92' , 'AKQ87' ,
      'AKQ86' , 'AKQ85' , 'AKQ84' , 'AKQ83' , 'AKQ82' , 'AKQ76' , 'AKQ75' ,
      'AKQ74' , 'AKQ73' , 'AKQ72' , 'AKQ65' , 'AKQ64' , 'AKQ63' , 'AKQ62' ,
      'AKQ54' , 'AKQ53' , 'AKQ52' , 'AKQ43' , 'AKQ42' , 'AKQ32' , 'AKJT9' ,
      'AKJT8' , 'AKJT7' , 'AKJT6' , 'AKJT5' , 'AKJT4' , 'AKJT3' , 'AKJT2' ,
      'AKJ98' , 'AKJ97' , 'AKJ96' , 'AKJ95' , 'AKJ94' , 'AKJ93' , 'AKJ92' ,
      'AKJ87' , 'AKJ86' , 'AKJ85' , 'AKJ84' , 'AKJ83' , 'AKJ82' , 'AKJ76' ,
      'AKJ75' , 'AKJ74' , 'AKJ73' , 'AKJ72' , 'AKJ65' , 'AKJ64' , 'AKJ63' ,
      'AKJ62' , 'AKJ54' , 'AKJ53' , 'AKJ52' , 'AKJ43' , 'AKJ42' , 'AKJ32' ,
      'AKT98' , 'AKT97' , 'AKT96' , 'AKT95' , 'AKT94' , 'AKT93' , 'AKT92' ,
      'AKT87' , 'AKT86' , 'AKT85' , 'AKT84' , 'AKT83' , 'AKT82' , 'AKT76' ,
      'AKT75' , 'AKT74' , 'AKT73' , 'AKT72' , 'AKT65' , 'AKT64' , 'AKT63' ,
      'AKT62' , 'AKT54' , 'AKT53' , 'AKT52' , 'AKT43' , 'AKT42' , 'AKT32' ,
      'AK987' , 'AK986' , 'AK985' , 'AK984' , 'AK983' , 'AK982' , 'AK976' ,
      'AK975' , 'AK974' , 'AK973' , 'AK972' , 'AK965' , 'AK964' , 'AK963' ,
      'AK962' , 'AK954' , 'AK953' , 'AK952' , 'AK943' , 'AK942' , 'AK932' ,
      'AK876' , 'AK875' , 'AK874' , 'AK873' , 'AK872' , 'AK865' , 'AK864' ,
      'AK863' , 'AK862' , 'AK854' , 'AK853' , 'AK852' , 'AK843' , 'AK842' ,
      'AK832' , 'AK765' , 'AK764' , 'AK763' , 'AK762' , 'AK754' , 'AK753' ,
      'AK752' , 'AK743' , 'AK742' , 'AK732' , 'AK654' , 'AK653' , 'AK652' ,
      'AK643' , 'AK642' , 'AK632' , 'AK543' , 'AK542' , 'AK532' , 'AK432' ,
      'AQJT9' , 'AQJT8' , 'AQJT7' , 'AQJT6' , 'AQJT5' , 'AQJT4' , 'AQJT3' ,
      'AQJT2' , 'AQJ98' , 'AQJ97' , 'AQJ96' , 'AQJ95' , 'AQJ94' , 'AQJ93' ,
      'AQJ92' , 'AQJ87' , 'AQJ86' , 'AQJ85' , 'AQJ84' , 'AQJ83' , 'AQJ82' ,
      'AQJ76' , 'AQJ75' , 'AQJ74' , 'AQJ73' , 'AQJ72' , 'AQJ65' , 'AQJ64' ,
      'AQJ63' , 'AQJ62' , 'AQJ54' , 'AQJ53' , 'AQJ52' , 'AQJ43' , 'AQJ42' ,
      'AQJ32' , 'AQT98' , 'AQT97' , 'AQT96' , 'AQT95' , 'AQT94' , 'AQT93' ,
      'AQT92' , 'AQT87' , 'AQT86' , 'AQT85' , 'AQT84' , 'AQT83' , 'AQT82' ,
      'AQT76' , 'AQT75' , 'AQT74' , 'AQT73' , 'AQT72' , 'AQT65' , 'AQT64' ,
      'AQT63' , 'AQT62' , 'AQT54' , 'AQT53' , 'AQT52' , 'AQT43' , 'AQT42' ,
      'AQT32' , 'AQ987' , 'AQ986' , 'AQ985' , 'AQ984' , 'AQ983' , 'AQ982' ,
      'AQ976' , 'AQ975' , 'AQ974' , 'AQ973' , 'AQ972' , 'AQ965' , 'AQ964' ,
      'AQ963' , 'AQ962' , 'AQ954' , 'AQ953' , 'AQ952' , 'AQ943' , 'AQ942' ,
      'AQ932' , 'AQ876' , 'AQ875' , 'AQ874' , 'AQ873' , 'AQ872' , 'AQ865' ,
      'AQ864' , 'AQ863' , 'AQ862' , 'AQ854' , 'AQ853' , 'AQ852' , 'AQ843' ,
      'AQ842' , 'AQ832' , 'AQ765' , 'AQ764' , 'AQ763' , 'AQ762' , 'AQ754' ,
      'AQ753' , 'AQ752' , 'AQ743' , 'AQ742' , 'AQ732' , 'AQ654' , 'AQ653' ,
      'AQ652' , 'AQ643' , 'AQ642' , 'AQ632' , 'AQ543' , 'AQ542' , 'AQ532' ,
      'AQ432' , 'AJT98' , 'AJT97' , 'AJT96' , 'AJT95' , 'AJT94' , 'AJT93' ,
      'AJT92' , 'AJT87' , 'AJT86' , 'AJT85' , 'AJT84' , 'AJT83' , 'AJT82' ,
      'AJT76' , 'AJT75' , 'AJT74' , 'AJT73' , 'AJT72' , 'AJT65' , 'AJT64' ,
      'AJT63' , 'AJT62' , 'AJT54' , 'AJT53' , 'AJT52' , 'AJT43' , 'AJT42' ,
      'AJT32' , 'AJ987' , 'AJ986' , 'AJ985' , 'AJ984' , 'AJ983' , 'AJ982' ,
      'AJ976' , 'AJ975' , 'AJ974' , 'AJ973' , 'AJ972' , 'AJ965' , 'AJ964' ,
      'AJ963' , 'AJ962' , 'AJ954' , 'AJ953' , 'AJ952' , 'AJ943' , 'AJ942' ,
      'AJ932' , 'AJ876' , 'AJ875' , 'AJ874' , 'AJ873' , 'AJ872' , 'AJ865' ,
      'AJ864' , 'AJ863' , 'AJ862' , 'AJ854' , 'AJ853' , 'AJ852' , 'AJ843' ,
      'AJ842' , 'AJ832' , 'AJ765' , 'AJ764' , 'AJ763' , 'AJ762' , 'AJ754' ,
      'AJ753' , 'AJ752' , 'AJ743' , 'AJ742' , 'AJ732' , 'AJ654' , 'AJ653' ,
      'AJ652' , 'AJ643' , 'AJ642' , 'AJ632' , 'AJ543' , 'AJ542' , 'AJ532' ,
      'AJ432' , 'AT987' , 'AT986' , 'AT985' , 'AT984' , 'AT983' , 'AT982' ,
      'AT976' , 'AT975' , 'AT974' , 'AT973' , 'AT972' , 'AT965' , 'AT964' ,
      'AT963' , 'AT962' , 'AT954' , 'AT953' , 'AT952' , 'AT943' , 'AT942' ,
      'AT932' , 'AT876' , 'AT875' , 'AT874' , 'AT873' , 'AT872' , 'AT865' ,
      'AT864' , 'AT863' , 'AT862' , 'AT854' , 'AT853' , 'AT852' , 'AT843' ,
      'AT842' , 'AT832' , 'AT765' , 'AT764' , 'AT763' , 'AT762' , 'AT754' ,
      'AT753' , 'AT752' , 'AT743' , 'AT742' , 'AT732' , 'AT654' , 'AT653' ,
      'AT652' , 'AT643' , 'AT642' , 'AT632' , 'AT543' , 'AT542' , 'AT532' ,
      'AT432' , 'A9876' , 'A9875' , 'A9874' , 'A9873' , 'A9872' , 'A9865' ,
      'A9864' , 'A9863' , 'A9862' , 'A9854' , 'A9853' , 'A9852' , 'A9843' ,
      'A9842' , 'A9832' , 'A9765' , 'A9764' , 'A9763' , 'A9762' , 'A9754' ,
      'A9753' , 'A9752' , 'A9743' , 'A9742' , 'A9732' , 'A9654' , 'A9653' ,
      'A9652' , 'A9643' , 'A9642' , 'A9632' , 'A9543' , 'A9542' , 'A9532' ,
      'A9432' , 'A8765' , 'A8764' , 'A8763' , 'A8762' , 'A8754' , 'A8753' ,
      'A8752' , 'A8743' , 'A8742' , 'A8732' , 'A8654' , 'A8653' , 'A8652' ,
      'A8643' , 'A8642' , 'A8632' , 'A8543' , 'A8542' , 'A8532' , 'A8432' ,
      'A7654' , 'A7653' , 'A7652' , 'A7643' , 'A7642' , 'A7632' , 'A7543' ,
      'A7542' , 'A7532' , 'A7432' , 'A6543' , 'A6542' , 'A6532' , 'A6432' ,
      'KQJT8' , 'KQJT7' , 'KQJT6' , 'KQJT5' , 'KQJT4' , 'KQJT3' , 'KQJT2' ,
      'KQJ98' , 'KQJ97' , 'KQJ96' , 'KQJ95' , 'KQJ94' , 'KQJ93' , 'KQJ92' ,
      'KQJ87' , 'KQJ86' , 'KQJ85' , 'KQJ84' , 'KQJ83' , 'KQJ82' , 'KQJ76' ,
      'KQJ75' , 'KQJ74' , 'KQJ73' , 'KQJ72' , 'KQJ65' , 'KQJ64' , 'KQJ63' ,
      'KQJ62' , 'KQJ54' , 'KQJ53' , 'KQJ52' , 'KQJ43' , 'KQJ42' , 'KQJ32' ,
      'KQT98' , 'KQT97' , 'KQT96' , 'KQT95' , 'KQT94' , 'KQT93' , 'KQT92' ,
      'KQT87' , 'KQT86' , 'KQT85' , 'KQT84' , 'KQT83' , 'KQT82' , 'KQT76' ,
      'KQT75' , 'KQT74' , 'KQT73' , 'KQT72' , 'KQT65' , 'KQT64' , 'KQT63' ,
      'KQT62' , 'KQT54' , 'KQT53' , 'KQT52' , 'KQT43' , 'KQT42' , 'KQT32' ,
      'KQ987' , 'KQ986' , 'KQ985' , 'KQ984' , 'KQ983' , 'KQ982' , 'KQ976' ,
      'KQ975' , 'KQ974' , 'KQ973' , 'KQ972' , 'KQ965' , 'KQ964' , 'KQ963' ,
      'KQ962' , 'KQ954' , 'KQ953' , 'KQ952' , 'KQ943' , 'KQ942' , 'KQ932' ,
      'KQ876' , 'KQ875' , 'KQ874' , 'KQ873' , 'KQ872' , 'KQ865' , 'KQ864' ,
      'KQ863' , 'KQ862' , 'KQ854' , 'KQ853' , 'KQ852' , 'KQ843' , 'KQ842' ,
      'KQ832' , 'KQ765' , 'KQ764' , 'KQ763' , 'KQ762' , 'KQ754' , 'KQ753' ,
      'KQ752' , 'KQ743' , 'KQ742' , 'KQ732' , 'KQ654' , 'KQ653' , 'KQ652' ,
      'KQ643' , 'KQ642' , 'KQ632' , 'KQ543' , 'KQ542' , 'KQ532' , 'KQ432' ,
      'KJT98' , 'KJT97' , 'KJT96' , 'KJT95' , 'KJT94' , 'KJT93' , 'KJT92' ,
      'KJT87' , 'KJT86' , 'KJT85' , 'KJT84' , 'KJT83' , 'KJT82' , 'KJT76' ,
      'KJT75' , 'KJT74' , 'KJT73' , 'KJT72' , 'KJT65' , 'KJT64' , 'KJT63' ,
      'KJT62' , 'KJT54' , 'KJT53' , 'KJT52' , 'KJT43' , 'KJT42' , 'KJT32' ,
      'KJ987' , 'KJ986' , 'KJ985' , 'KJ984' , 'KJ983' , 'KJ982' , 'KJ976' ,
      'KJ975' , 'KJ974' , 'KJ973' , 'KJ972' , 'KJ965' , 'KJ964' , 'KJ963' ,
      'KJ962' , 'KJ954' , 'KJ953' , 'KJ952' , 'KJ943' , 'KJ942' , 'KJ932' ,
      'KJ876' , 'KJ875' , 'KJ874' , 'KJ873' , 'KJ872' , 'KJ865' , 'KJ864' ,
      'KJ863' , 'KJ862' , 'KJ854' , 'KJ853' , 'KJ852' , 'KJ843' , 'KJ842' ,
      'KJ832' , 'KJ765' , 'KJ764' , 'KJ763' , 'KJ762' , 'KJ754' , 'KJ753' ,
      'KJ752' , 'KJ743' , 'KJ742' , 'KJ732' , 'KJ654' , 'KJ653' , 'KJ652' ,
      'KJ643' , 'KJ642' , 'KJ632' , 'KJ543' , 'KJ542' , 'KJ532' , 'KJ432' ,
      'KT987' , 'KT986' , 'KT985' , 'KT984' , 'KT983' , 'KT982' , 'KT976' ,
      'KT975' , 'KT974' , 'KT973' , 'KT972' , 'KT965' , 'KT964' , 'KT963' ,
      'KT962' , 'KT954' , 'KT953' , 'KT952' , 'KT943' , 'KT942' , 'KT932' ,
      'KT876' , 'KT875' , 'KT874' , 'KT873' , 'KT872' , 'KT865' , 'KT864' ,
      'KT863' , 'KT862' , 'KT854' , 'KT853' , 'KT852' , 'KT843' , 'KT842' ,
      'KT832' , 'KT765' , 'KT764' , 'KT763' , 'KT762' , 'KT754' , 'KT753' ,
      'KT752' , 'KT743' , 'KT742' , 'KT732' , 'KT654' , 'KT653' , 'KT652' ,
      'KT643' , 'KT642' , 'KT632' , 'KT543' , 'KT542' , 'KT532' , 'KT432' ,
      'K9876' , 'K9875' , 'K9874' , 'K9873' , 'K9872' , 'K9865' , 'K9864' ,
      'K9863' , 'K9862' , 'K9854' , 'K9853' , 'K9852' , 'K9843' , 'K9842' ,
      'K9832' , 'K9765' , 'K9764' , 'K9763' , 'K9762' , 'K9754' , 'K9753' ,
      'K9752' , 'K9743' , 'K9742' , 'K9732' , 'K9654' , 'K9653' , 'K9652' ,
      'K9643' , 'K9642' , 'K9632' , 'K9543' , 'K9542' , 'K9532' , 'K9432' ,
      'K8765' , 'K8764' , 'K8763' , 'K8762' , 'K8754' , 'K8753' , 'K8752' ,
      'K8743' , 'K8742' , 'K8732' , 'K8654' , 'K8653' , 'K8652' , 'K8643' ,
      'K8642' , 'K8632' , 'K8543' , 'K8542' , 'K8532' , 'K8432' , 'K7654' ,
      'K7653' , 'K7652' , 'K7643' , 'K7642' , 'K7632' , 'K7543' , 'K7542' ,
      'K7532' , 'K7432' , 'K6543' , 'K6542' , 'K6532' , 'K6432' , 'K5432' ,
      'QJT97' , 'QJT96' , 'QJT95' , 'QJT94' , 'QJT93' , 'QJT92' , 'QJT87' ,
      'QJT86' , 'QJT85' , 'QJT84' , 'QJT83' , 'QJT82' , 'QJT76' , 'QJT75' ,
      'QJT74' , 'QJT73' , 'QJT72' , 'QJT65' , 'QJT64' , 'QJT63' , 'QJT62' ,
      'QJT54' , 'QJT53' , 'QJT52' , 'QJT43' , 'QJT42' , 'QJT32' , 'QJ987' ,
      'QJ986' , 'QJ985' , 'QJ984' , 'QJ983' , 'QJ982' , 'QJ976' , 'QJ975' ,
      'QJ974' , 'QJ973' , 'QJ972' , 'QJ965' , 'QJ964' , 'QJ963' , 'QJ962' ,
      'QJ954' , 'QJ953' , 'QJ952' , 'QJ943' , 'QJ942' , 'QJ932' , 'QJ876' ,
      'QJ875' , 'QJ874' , 'QJ873' , 'QJ872' , 'QJ865' , 'QJ864' , 'QJ863' ,
      'QJ862' , 'QJ854' , 'QJ853' , 'QJ852' , 'QJ843' , 'QJ842' , 'QJ832' ,
      'QJ765' , 'QJ764' , 'QJ763' , 'QJ762' , 'QJ754' , 'QJ753' , 'QJ752' ,
      'QJ743' , 'QJ742' , 'QJ732' , 'QJ654' , 'QJ653' , 'QJ652' , 'QJ643' ,
      'QJ642' , 'QJ632' , 'QJ543' , 'QJ542' , 'QJ532' , 'QJ432' , 'QT987' ,
      'QT986' , 'QT985' , 'QT984' , 'QT983' , 'QT982' , 'QT976' , 'QT975' ,
      'QT974' , 'QT973' , 'QT972' , 'QT965' , 'QT964' , 'QT963' , 'QT962' ,
      'QT954' , 'QT953' , 'QT952' , 'QT943' , 'QT942' , 'QT932' , 'QT876' ,
      'QT875' , 'QT874' , 'QT873' , 'QT872' , 'QT865' , 'QT864' , 'QT863' ,
      'QT862' , 'QT854' , 'QT853' , 'QT852' , 'QT843' , 'QT842' , 'QT832' ,
      'QT765' , 'QT764' , 'QT763' , 'QT762' , 'QT754' , 'QT753' , 'QT752' ,
      'QT743' , 'QT742' , 'QT732' , 'QT654' , 'QT653' , 'QT652' , 'QT643' ,
      'QT642' , 'QT632' , 'QT543' , 'QT542' , 'QT532' , 'QT432' , 'Q9876' ,
      'Q9875' , 'Q9874' , 'Q9873' , 'Q9872' , 'Q9865' , 'Q9864' , 'Q9863' ,
      'Q9862' , 'Q9854' , 'Q9853' , 'Q9852' , 'Q9843' , 'Q9842' , 'Q9832' ,
      'Q9765' , 'Q9764' , 'Q9763' , 'Q9762' , 'Q9754' , 'Q9753' , 'Q9752' ,
      'Q9743' , 'Q9742' , 'Q9732' , 'Q9654' , 'Q9653' , 'Q9652' , 'Q9643' ,
      'Q9642' , 'Q9632' , 'Q9543' , 'Q9542' , 'Q9532' , 'Q9432' , 'Q8765' ,
      'Q8764' , 'Q8763' , 'Q8762' , 'Q8754' , 'Q8753' , 'Q8752' , 'Q8743' ,
      'Q8742' , 'Q8732' , 'Q8654' , 'Q8653' , 'Q8652' , 'Q8643' , 'Q8642' ,
      'Q8632' , 'Q8543' , 'Q8542' , 'Q8532' , 'Q8432' , 'Q7654' , 'Q7653' ,
      'Q7652' , 'Q7643' , 'Q7642' , 'Q7632' , 'Q7543' , 'Q7542' , 'Q7532' ,
      'Q7432' , 'Q6543' , 'Q6542' , 'Q6532' , 'Q6432' , 'Q5432' , 'JT986' ,
      'JT985' , 'JT984' , 'JT983' , 'JT982' , 'JT976' , 'JT975' , 'JT974' ,
      'JT973' , 'JT972' , 'JT965' , 'JT964' , 'JT963' , 'JT962' , 'JT954' ,
      'JT953' , 'JT952' , 'JT943' , 'JT942' , 'JT932' , 'JT876' , 'JT875' ,
      'JT874' , 'JT873' , 'JT872' , 'JT865' , 'JT864' , 'JT863' , 'JT862' ,
      'JT854' , 'JT853' , 'JT852' , 'JT843' , 'JT842' , 'JT832' , 'JT765' ,
      'JT764' , 'JT763' , 'JT762' , 'JT754' , 'JT753' , 'JT752' , 'JT743' ,
      'JT742' , 'JT732' , 'JT654' , 'JT653' , 'JT652' , 'JT643' , 'JT642' ,
      'JT632' , 'JT543' , 'JT542' , 'JT532' , 'JT432' , 'J9876' , 'J9875' ,
      'J9874' , 'J9873' , 'J9872' , 'J9865' , 'J9864' , 'J9863' , 'J9862' ,
      'J9854' , 'J9853' , 'J9852' , 'J9843' , 'J9842' , 'J9832' , 'J9765' ,
      'J9764' , 'J9763' , 'J9762' , 'J9754' , 'J9753' , 'J9752' , 'J9743' ,
      'J9742' , 'J9732' , 'J9654' , 'J9653' , 'J9652' , 'J9643' , 'J9642' ,
      'J9632' , 'J9543' , 'J9542' , 'J9532' , 'J9432' , 'J8765' , 'J8764' ,
      'J8763' , 'J8762' , 'J8754' , 'J8753' , 'J8752' , 'J8743' , 'J8742' ,
      'J8732' , 'J8654' , 'J8653' , 'J8652' , 'J8643' , 'J8642' , 'J8632' ,
      'J8543' , 'J8542' , 'J8532' , 'J8432' , 'J7654' , 'J7653' , 'J7652' ,
      'J7643' , 'J7642' , 'J7632' , 'J7543' , 'J7542' , 'J7532' , 'J7432' ,
      'J6543' , 'J6542' , 'J6532' , 'J6432' , 'J5432' , 'T9875' , 'T9874' ,
      'T9873' , 'T9872' , 'T9865' , 'T9864' , 'T9863' , 'T9862' , 'T9854' ,
      'T9853' , 'T9852' , 'T9843' , 'T9842' , 'T9832' , 'T9765' , 'T9764' ,
      'T9763' , 'T9762' , 'T9754' , 'T9753' , 'T9752' , 'T9743' , 'T9742' ,
      'T9732' , 'T9654' , 'T9653' , 'T9652' , 'T9643' , 'T9642' , 'T9632' ,
      'T9543' , 'T9542' , 'T9532' , 'T9432' , 'T8765' , 'T8764' , 'T8763' ,
      'T8762' , 'T8754' , 'T8753' , 'T8752' , 'T8743' , 'T8742' , 'T8732' ,
      'T8654' , 'T8653' , 'T8652' , 'T8643' , 'T8642' , 'T8632' , 'T8543' ,
      'T8542' , 'T8532' , 'T8432' , 'T7654' , 'T7653' , 'T7652' , 'T7643' ,
      'T7642' , 'T7632' , 'T7543' , 'T7542' , 'T7532' , 'T7432' , 'T6543' ,
      'T6542' , 'T6532' , 'T6432' , 'T5432' , '98764' , '98763' , '98762' ,
      '98754' , '98753' , '98752' , '98743' , '98742' , '98732' , '98654' ,
      '98653' , '98652' , '98643' , '98642' , '98632' , '98543' , '98542' ,
      '98532' , '98432' , '97654' , '97653' , '97652' , '97643' , '97642' ,
      '97632' , '97543' , '97542' , '97532' , '97432' , '96543' , '96542' ,
      '96532' , '96432' , '95432' , '87653' , '87652' , '87643' , '87642' ,
      '87632' , '87543' , '87542' , '87532' , '87432' , '86543' , '86542' ,
      '86532' , '86432' , '85432' , '76542' , '76532' , '76432' , '75432' ,
    );
  }
  return($hndz[$scor]);
}

sub ScoreHand { # returns the score of the passed in @hand or ShortHand
  my @hand = @_; return(7462) unless(@hand == 1 || @hand == 5); my $shrt;
  my $aflg = 0; $aflg = 1 if(ref($hand[0]) eq 'ARRAY'); my $aref = 0;
  if($aflg) { $aref =  $hand[0]; }
  else      { $aref = \@hand;    }
  if(@{$aref} == 1) { $shrt = $aref->[0];       }
  else              { $shrt = ShortHand($aref); }
  unless(@hndz) { HandScore(); } # mk sure ShortHand array is initialized
  unless(%scrh) { # define hash only the first time ScoreHand() is called
    for(my $indx = 0; $indx < @hndz; $indx++) { $scrh{$hndz[$indx]} = $indx; }
  } # generate hash backwards from ShortHands
  if($slow) { return(SlowScoreHand($shrt)); }
  else      { return(        $scrh{$shrt}); }
}

sub UseSlow { # toggles the use of SlowScoreHand() instead of ScoreHand()
  if(@_) { $slow  = shift(); } # $slow given as param
  else   { $slow ^= 1;       } # no param so just toggle
  return(  $slow  );
}

sub CardName { # takes an abbreviated card (eg. 'As') && returns full name
  my $card = shift() || return(0); my $name; my %data;
  if(length($card) == 1) { # +10 b64 abbrev
    $card = b10($card) - 10;
    my @deck = Deck();
    $card = $deck[$card];
  }
  ($data{'rank'}, $data{'suit'}) = split(//, $card);
  $name = $rnam[$rprv{$data{'rank'}}] . ' of ';
  foreach(@snam) { $name .= $_ if(/^$data{'suit'}/i); }
  return($name);
}

sub NameCard { # takes a full card name (eg. 'Ace of Spades') && returns abbrev
  my $name = shift() || return(0); my $b64f = shift() || 0; my $card;
  $name =~ s/\s+of\s+//gi; $name =~ s/\s+//g; 
  foreach my $indx (0..$#rnam) {
    if($name =~ s/$rnam[$indx]//i) { $card = $rprg[$indx]; last; }
  }
  foreach(@snam) {
    if($name =~ s/$_//i) { $card .= lc(substr($_, 0, 1)); last; }
  }
  if($b64f) { # b64 abbrev flag
    my @deck = Deck();
    foreach my $indx (0..$#deck) {
      if($card eq $deck[$indx]) { $card = $indx; last; }
    }
    $card += 10;
    $card = b64($card);
  }
  return($card);
}

sub HandName { # takes a @handref, @hand, ShortHand, or score && returns name
  my @hand = @_; return(0) unless(@hand == 1 || @hand == 5); my $shrt; 
  my $aflg = 0; $aflg = 1 if(ref($hand[0]) eq 'ARRAY'); my $aref = 0;
  my %namz = (
       '0' => 'Royal Flush',     #  Royal    Flush     0           1
       '9' => 'Straight Flush',  #  Straight Flush     1..   9     9
     '165' => 'Four-of-a-Kind',  #  Four-of-a-Kind    10.. 165   156
     '321' => 'Full House',      #  Full House       166.. 321   156
    '1598' => 'Flush',           #           Flush   322..1598  1277
    '1608' => 'Straight',        #  Straight        1599..1608    10
    '2466' => 'Three-of-a-Kind', #  Three-of-a-Kind 1609..2466   858
    '3324' => 'Two Pair',        #  Two Pair        2467..3324   858
    '6184' => 'One Pair',        #  One Pair        3325..6184  2860
    '7461' => 'High Card',       #  High Card       6185..7461  1277
  );
  if($aflg) { $aref =  $hand[0]; }
  else      { $aref = \@hand;    }
  if(@{$aref} == 1) { $shrt = $aref->[0];       }
  else              { $shrt = ShortHand($aref); }
  unless(@hndz) { HandScore(); } # mk sure ShortHand array is initialized
  unless(%scrh) { ScoreHand(); } # mk sure   scores  hash  is initialized
  unless($shrt =~ /^\d+$/) { $shrt = $scrh{$shrt}; }
  foreach(sort { $a <=> $b } keys(%namz)) {
    return($namz{$_}) if($shrt <= $_);
  }
}

127;
