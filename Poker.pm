# 43KNlxM - Games::Cards::Poker.pm created by Pip Stuart <Pip@CPAN.Org> to provide
#   Poker functions (&& maybe later objects) using only Perl.

=head1 NAME

Games::Cards::Poker - Perl Poker functions

=head1 VERSION

This documentation refers to version 1.0.44F2Q8F of 
Games::Cards::Poker, which was released on Thu Apr 15 02:26:08:15 2004.

=head1 SYNOPSIS

  use Games::Cards::Poker;

  # Deal 4 players hands && score them...
  my $players   = 4; # number of players to get hands dealt
  my $hand_size = 5; # number of cards to deal to each player
  my @hands     = ();# player hand data
  my @deck      = Shuffle(Deck()); # Deck returns array of ('As'..'2c')
  #print "Deck:@deck\n";       # print out shuffled deck
  for(my $pndx = 0; $pndx < $players; $pndx++) {
    for(my $hndx = 0; $hndx < $hand_size; $hndx++) {
      push(@{$hands[$pndx]}, pop(@deck)); # $hands[$pndx][$hndx] = pop
    }
    printf("Player%d score:%4d hand:@{$hands[$pndx]}\n", 
      $pndx, ScoreHand(@{$hands[$pndx]}));
  }

=head1 DESCRIPTION

Poker provides a few simple functions for creating 
decks of cards && manipulating them for simple Poker games 
or simulations.

=head1 2DO

=over 2

=item - mk HandScore to take score && return proper hand

=item - mk ScoreHand take optional arrayref param like others

=item - mk up data file format

=item - better error checking

=item -    What else does Poker need?

=back

=head1 USAGE

=head2 Deck()

Returns a new array of scalars with the abbreviated Poker names of
cards (eg. As == Ace of Spades, Td == Ten of Diamonds, 2c == Two of 
Clubs, etc.).

=head2 Shuffle(@cards)

Shuffles the passed in @cards array in one quick pass.  Shuffle() 
returns a shuffled copy of the @cards array.

Shuffle() can also take an arrayref parameter instead of an explicit
@cards array in which case, the passed in arrayref will be shuffled
in place && the return value need not be reassigned.

=head2 SortCards(@cards)

Sorts the passed in @cards array.  SortCards() 
returns a sorted copy of the @cards array.

SortCards() can also take an arrayref parameter instead of an explicit
@cards array in which case, the passed in arrayref will be sorted
in place && the return value need not be reassigned.

=head2 ShortHand(@hand)

Returns a scalar string containing the abbreviated Poker description
of @hand (eg. AKQJTs == Royal Flush, QQ993 == Two Pair, etc.).

=head2 ScoreHand(@hand)

Returns an integer score (where lower is better) for the passed in 
Poker @hand.  This means 0 (zero) is returned for a Royal Flush && 
the worst possible score is 7460 awarded to 7, 5, 4, 3, 2 unsuited.

If you want higher scores to mean higher hands, just subtract the 
return value from 7460.

All suits are considered to have equal value in this scoring function.
It should be easy to use ScoreHand() as a first pass where ties can
be resolved by another suit-comparison function if you want such 
behavior.

=head1 NOTES

Games::Poker::* wouldn't compile correctly for me so I thought it 
  shouldn't take too long to write my own. =)

Suits are: s,h,d,c (Spade,Heart,Diamond,Club) like bridge (alphabetical)
  although they are sorted && appear in this order, suits are ignored for
  scoring by default (but can be optionally reordered && scored later)

B64 notes: Cards map perfectly into A..Z,a..z so += 10 for only letter rep

 B64 Cards: 0.As 4.Ks 8.Qs C.Js G.Ts K.9s O.8s S.7s W.6s a.5s e.4s i.3s m.2s
            1.Ah 5.Kh 9.Qh D.Jh H.Th L.9h P.8h T.7h X.6h b.5h f.4h j.3h n.2h
            2.Ad 6.Kd A.Qd E.Jd I.Td M.9d Q.8d U.7d Y.6d c.5d g.4d k.3d o.2d
            3.Ac 7.Kc B.Qc F.Jc J.Tc N.9c R.8c V.7c Z.6c d.5c h.4c l.3c p.2c
    Values:   0    1    2    3    4    5    6    7    8    9    A    B    C 
 B64 Cards: 0.As   1.Ah   2.Ad   3.Ac       Values: 0
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
Copyright: (c) 2003, Pip Stuart.  All rights reserved.
Copyleft :  I license this software under the GNU General Public 
  License (version 2).  Please consult the Free Software Foundation 
  (http://www.fsf.org) for important information about your freedom.

=head1 AUTHOR

Pip Stuart <Pip@CPAN.Org>

=cut

package Games::Cards::Poker;
require    Exporter;
require              Games::Cards;
use strict;
use base qw(Exporter Games::Cards);
use Math::BaseCnv  qw(:all);

our @EXPORT      = qw(Shuffle Deck SortCards ShortHand ScoreHand);
our $VERSION     = '1.0.44F2Q8F'; # major . minor . PipTimeStamp
our $PTVR        = $VERSION; $PTVR =~ s/^\d+\.\d+\.//; # strip major and minor
# See http://Ax9.Org/pt?$PTVR and `perldoc Time::PT`

# value progression, suit progression
my @vprg = ('A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2');
my @sprg = ('s', 'h', 'd', 'c'); # Spade, Heart, Diamond, Club  (Club, Diam)?
my %vprv; for(my $indx=0; $indx<@vprg; $indx++) { $vprv{$vprg[$indx]} = $indx;}

sub Deck { # return an array of cards as a whole new deck in clean new order
  my @deck = ();
  foreach my $valu (@vprg) {
    foreach my $suit (@sprg) {
      push(@deck, "$valu$suit");
    }
  }
  return(@deck);
}

sub Shuffle { # takes an arrayref or list of items to shuffle
  return unless(@_); # must have at least one parameter
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
  return unless(@_); # must have at least one parameter
  my $aflg = 0; $aflg = 1 if(ref($_[0]) eq 'ARRAY');
  my $aref = 0; my @data = @_;
  if($aflg) { $aref = $_[0];  }
  else      { $aref = \@data; }
  @{$aref} = sort {
    my $suba = substr($a, 0, 1);
    my $subb = substr($b, 0, 1);
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
      $suba = substr($a, 1, 1);
      $subb = substr($b, 1, 1);
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
      else                                { return($b cmp $a); }
    } else                              { return($b cmp $a); }
  } @{$aref};
  if($aflg) { return($aref); }
  else      { return(@data); }
}

sub ShortHand { # takes an arrayref or list of cards to abbreviate
  return unless(@_); # must have at least one parameter
  my $aflg = 0; $aflg = 1 if(ref($_[0]) eq 'ARRAY');
  my $aref = 0; my @data = @_; my $shrt = ''; my $suit = 1;
  if($aflg) { $aref = $_[0];  }
  else      { $aref = \@data; }
  foreach(@{$aref}) { 
    $shrt .=      substr($_, 0, 1); 
    $suit  = 0 if(substr($_, 1, 1) ne substr($aref->[0], 1, 1));
  }
  $shrt .= 's' if($suit);
  return($shrt);
}

sub ScoreHand { # takes a list of 5 cards && return the poker hand score
  my @hand = @_; return(0) unless(@hand == 5);
  my $scor = 7463; my @data = (); my $flsh = 0; my $strt = 0;
  my ($set0, $set1);                      # temp values for matched sets
  my ($xtr0, $xtr1, $xtr2, $xtr3, $xtr4); # temp values for extra cards
  SortCards(\@hand);
  for(my $indx=0; $indx<@hand; $indx++) {
    ($data[$indx]{'valu'}, $data[$indx]{'suit'}) = split(//, $hand[$indx]);
  }
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
#  One Pair        3325..6183  2859  (13 choose 4) * 4
#  High Card       6184..7460  1277  (13 choose 5) - 9

#  general straight test
  if     (@vprg            >         ( $vprv{$data[1]{'valu'}} + 1 )   &&
          $data[2]{'valu'} eq $vprg[ ( $vprv{$data[1]{'valu'}} + 1 ) ] &&
          @vprg            >         ( $vprv{$data[1]{'valu'}} + 2 )   &&
          $data[3]{'valu'} eq $vprg[ ( $vprv{$data[1]{'valu'}} + 2 ) ] &&
          @vprg            >         ( $vprv{$data[1]{'valu'}} + 3 )   &&
          $data[4]{'valu'} eq $vprg[ ( $vprv{$data[1]{'valu'}} + 3 ) ] &&
        ((                             $vprv{$data[1]{'valu'}}         &&
          $data[0]{'valu'} eq $vprg[ ( $vprv{$data[1]{'valu'}} - 1 ) ] ) ||
         ($data[0]{'valu'} eq 'A' && $data[1]{'valu'} eq '5'))) { $strt = 1; }
#  general flush    test
  if     ($data[0]{'suit'} eq $data[1]{'suit'} &&
          $data[0]{'suit'} eq $data[2]{'suit'} &&
          $data[0]{'suit'} eq $data[3]{'suit'} &&
          $data[0]{'suit'} eq $data[4]{'suit'})                 { $flsh = 1; }
#  Royal    Flush     0           1  only one
  if     ($data[1]{'valu'} eq'K' && $strt && $flsh) {
    $scor = 0;
#  Straight Flush     1..   9     9  King High through 5 High
  } elsif($strt && $flsh) {
    $scor =       $vprv{$data[0]{'valu'}};
    $scor =  9 if(      $data[0]{'valu'} eq 'A' &&
                        $data[1]{'valu'} eq '5');
#  Four-of-a-Kind    10.. 165   156  (13 choose 2) * 2
  } elsif($data[1]{'valu'} eq $data[2]{'valu'} &&
          $data[1]{'valu'} eq $data[3]{'valu'} &&
         ($data[1]{'valu'} eq $data[4]{'valu'} ||
          $data[1]{'valu'} eq $data[0]{'valu'})) {
    if($data[1]{'valu'} eq $data[0]{'valu'}) { # xxxx y
      $set0 = $vprv{$data[0]{'valu'}};
      $xtr0 = $vprv{$data[4]{'valu'}} - 1;
    } else {                                   # x yyyy
      $set0 = $vprv{$data[4]{'valu'}};
      $xtr0 = $vprv{$data[0]{'valu'}};
    }
    $scor = (10 + ($set0 * 12) + $xtr0);
#  Full House       166.. 321   156  (13 choose 2) * 2
  } elsif($data[0]{'valu'} eq $data[1]{'valu'} &&
          $data[3]{'valu'} eq $data[4]{'valu'} &&
         ($data[0]{'valu'} eq $data[2]{'valu'} ||
          $data[3]{'valu'} eq $data[2]{'valu'})) {
    if($data[0]{'valu'} eq $data[2]{'valu'}) { # xxx yy
      $set0 = $vprv{$data[0]{'valu'}};
      $set1 = $vprv{$data[4]{'valu'}} - 1;
    } else {                                   # xx yyy
      $set0 = $vprv{$data[4]{'valu'}};
      $set1 = $vprv{$data[0]{'valu'}};
    }
    $scor = (166 + ($set0 * 12) + $set1);
#           Flush   322..1598  1277  (13 choose 5) - 9
  } elsif($flsh) {
    $xtr0 = $vprv{$data[0]{'valu'}};
    $xtr1 = $vprv{$data[1]{'valu'}};
    $xtr2 = $vprv{$data[2]{'valu'}};
    $xtr3 = $vprv{$data[3]{'valu'}};
    $xtr4 = $vprv{$data[4]{'valu'}} - $xtr3;
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
    $scor = (1599 +  $vprv{$data[0]{'valu'}});
    $scor =  1608 if(      $data[0]{'valu'} eq 'A' &&
                           $data[1]{'valu'} eq '5');
#  Three-of-a-Kind 1609..2466   858  (13 choose 3) * 3
  } elsif(($data[0]{'valu'} eq $data[1]{'valu'} &&
           $data[0]{'valu'} eq $data[2]{'valu'}) || # xxx y z
          ($data[1]{'valu'} eq $data[2]{'valu'} &&
           $data[2]{'valu'} eq $data[3]{'valu'}) || # x yyy z
          ($data[2]{'valu'} eq $data[3]{'valu'} &&
           $data[3]{'valu'} eq $data[4]{'valu'})) { # x y zzz
    if     ($data[0]{'valu'} eq $data[2]{'valu'}) { # xxx y z
      $set0 = $vprv{$data[0]{'valu'}};
      $xtr0 = $vprv{$data[3]{'valu'}} - 1;
      $xtr1 = $vprv{$data[4]{'valu'}} - 2;
    } elsif($data[1]{'valu'} eq $data[3]{'valu'}) { # x yyy z
      $xtr0 = $vprv{$data[0]{'valu'}};
      $set0 = $vprv{$data[1]{'valu'}};
      $xtr1 = $vprv{$data[4]{'valu'}} - 2;
    } else {                                        # x y zzz
      $xtr0 = $vprv{$data[0]{'valu'}};
      $xtr1 = $vprv{$data[1]{'valu'}} - 1;
      $set0 = $vprv{$data[2]{'valu'}};
    }
    $scor = (1609 +
             (      $set0  * summ(  11 )) +
             ((12 * $xtr0) - summ($xtr0)) +
             (      $xtr1  -      $xtr0 ));
#  Two Pair        2467..3324   858  (13 choose 3) * 3
  } elsif(($data[0]{'valu'} eq $data[1]{'valu'} &&
           $data[2]{'valu'} eq $data[3]{'valu'}) || # xx yy z
          ($data[0]{'valu'} eq $data[1]{'valu'} &&
           $data[3]{'valu'} eq $data[4]{'valu'}) || # xx y zz
          ($data[1]{'valu'} eq $data[2]{'valu'} &&
           $data[3]{'valu'} eq $data[4]{'valu'})) { # x yy zz
    if($data[0]{'valu'} eq $data[1]{'valu'}) {      # xx
      if($data[2]{'valu'} eq $data[3]{'valu'}) {    #    yy z
        $set0 = $vprv{$data[0]{'valu'}};
        $set1 = $vprv{$data[2]{'valu'}} - 1;
        $xtr0 = $vprv{$data[4]{'valu'}} - 2;
      } else {                                      #    y zz
        $set0 = $vprv{$data[0]{'valu'}};
        $xtr0 = $vprv{$data[2]{'valu'}} - 1;
        $set1 = $vprv{$data[3]{'valu'}} - 1;
      }
    } else {                                        # x yy zz
      $xtr0 = $vprv{$data[0]{'valu'}};
      $set0 = $vprv{$data[1]{'valu'}};
      $set1 = $vprv{$data[3]{'valu'}} - 1;
    }
    $scor = (2467 +
             (((13*$set0) - summ($set0)) * 11) +
             ( 11 *($set1 - $set0)           ) +
                    $xtr0                     );
#  One Pair        3325..6183  2859  (13 choose 4) * 4
  } elsif($data[0]{'valu'} eq $data[1]{'valu'} ||   # ww x y z
          $data[1]{'valu'} eq $data[2]{'valu'} ||   # w xx y z
          $data[2]{'valu'} eq $data[3]{'valu'} ||   # w x yy z
          $data[3]{'valu'} eq $data[4]{'valu'}) {   # w x y zz
    if     ($data[0]{'valu'} eq $data[1]{'valu'}) { # ww
      $set0 = $vprv{$data[0]{'valu'}};
      $xtr0 = $vprv{$data[2]{'valu'}} - 1;
      $xtr1 = $vprv{$data[3]{'valu'}} - 1;
      $xtr2 = $vprv{$data[4]{'valu'}} - 1;
    } elsif($data[1]{'valu'} eq $data[2]{'valu'}) { #   xx
      $xtr0 = $vprv{$data[0]{'valu'}};
      $set0 = $vprv{$data[1]{'valu'}};
      $xtr1 = $vprv{$data[3]{'valu'}} - 1;
      $xtr2 = $vprv{$data[4]{'valu'}} - 1;
    } elsif($data[2]{'valu'} eq $data[3]{'valu'}) { #     yy
      $xtr0 = $vprv{$data[0]{'valu'}};
      $xtr1 = $vprv{$data[1]{'valu'}};
      $set0 = $vprv{$data[2]{'valu'}};
      $xtr2 = $vprv{$data[4]{'valu'}} - 1;
    } else {                                        #       zz
      $xtr0 = $vprv{$data[0]{'valu'}};
      $xtr1 = $vprv{$data[1]{'valu'}};
      $xtr2 = $vprv{$data[2]{'valu'}};
      $set0 = $vprv{$data[3]{'valu'}};
    }
    $scor  = 3325;
    $scor += ($set0 * choo(12, 3));
    $xtr2 -= ($xtr1 + 1);
    $scor++ if($set0 < $xtr0 && $xtr0 == 9);
    while($xtr0-- > 0) { $scor +=  choo((10 - $xtr0), 2)     ; }
    while($xtr1-- > 1) { $scor += (     (12 - $xtr1)     - 1); }
                         $scor +=             $xtr2          ;
#  High Card       6184..7460  1277  (13 choose 5) - 9
  } else {
    $xtr0 = $vprv{$data[0]{'valu'}};
    $xtr1 = $vprv{$data[1]{'valu'}};
    $xtr2 = $vprv{$data[2]{'valu'}};
    $xtr3 = $vprv{$data[3]{'valu'}};
    $xtr4 = $vprv{$data[4]{'valu'}} - $xtr3;
    $scor = 6184;
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

127;
