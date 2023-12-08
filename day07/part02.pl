#!/usr/bin/perl 

# my $input_file = 'test_input.txt' ;
my $input_file = 'input.txt' ;
my $start_time = time;

my %game = () ; 
my $total_winnings = 0 ;

open(FH, '<', $input_file)
    or die $! ;

# loop through all entries
while(<FH>){    
    chomp(my $input_line = $_) ;
    ($hand, $bid) = split(/ /,$input_line) ;

    $type = &get_type($hand) ;
    $hexnum = &hand_to_hex($hand) ;

    # populate hash with values
    $game{$hexnum}{'type'} = $type ;
    $game{$hexnum}{'hexnum'} = $hexnum ;
    $game{$hexnum}{'hand'} = $hand ; 
    $game{$hexnum}{'besthand'} = $hand ; 
    $game{$hexnum}{'bid'} = $bid ;
    $game{$hexnum}{'rank'} = 0 ; 

    # if there are (j)okers
    if ($hand =~ m/J/) {
        $best = &best_hand($hand) ;
        $type = &get_type($best);

        $game{$hexnum}{'besthand'} = $best ; 
        $game{$hexnum}{'type'} = $type ; 
    }


    # printf("Hand: %s Hex: %s Bid: %s Type: %s\n", $hand, $hexnum, $bid, $type);

    # printf("\n");

}


# spin through hash and rank the numbers
$rank = 1 ;

for $i (1..7) {

    foreach $key (sort { hex $a <=> hex $b } keys %game ) {

        if ($game{$key}{'type'} == $i ) {

            $game{$key}{'rank'} = $rank ;
            printf("Hexsort: %5x  Hand: %5s  Best: %5s  Bid: %4d  Type: %1d  Rank: %4d\n", hex $key, $game{$key}{'hand'}, $game{$key}{'besthand'}, $game{$key}{'bid'}, $game{$key}{'type'}, $game{$key}{'rank'});

            $total_winnings = $total_winnings + $game{$key}{'bid'} * $game{$key}{'rank'} ;
            $rank++;
        }
    }
}

printf("\n");

close(FH);

printf("Total Winnings: %d\n", $total_winnings) ;

printf("Duration: %02d:%02d:%02d\n", (gmtime(time - $start_time))[2,1,0]) ;

exit; 


sub hand_to_hex($) {
    my $hand = shift;

    # T(ten)   = a
    # J(jack)  = b
    # Q(queen) = c
    # K(king)  = d
    # A(ace)   = e

    $hand =~ s/T/a/g;
    $hand =~ s/J/1/g;
    $hand =~ s/Q/c/g;
    $hand =~ s/K/d/g;
    $hand =~ s/A/e/g;

    $hand = sprintf("0x%s", $hand);

    return $hand ; 

}


sub get_type($) {
    my $hand = shift;
    my %count ;

    my $return_value = 0 ;
    # printf("Hand: %s Type: %s\n", $hand, $return_value);

    # 7: Five of a Kind (AAAAA)
    # 6: Four of a Kind (AA8AA)
    # 5: Full House (23332)
    # 4: Three of a kind (TTT98)
    # 3: Two Pair (23432)
    # 2: One Pair (A23A4)
    # 1: High Card (23456)
    # 0: Unknown

    for(split(//, $hand)) {
        $count{$_}++;
    }

    $size = keys %count ;

    # printf("Size: %s\n",$size);

    foreach $key (sort { $count{$b} <=> $count{$a} } keys %count) {
        # printf("Card: %s - %s\n", $key, $count{$key}) ;

        # check for five of a kind (cc: 1)
        if ($size == 1) {
            $return_value = 7 ;
        }
        if ($size == 2) {
            # check for four of a kind (cc: 4 & cc: 1)
            if ( $count{$key} == 4) {
                $return_value = 6 ;
            } elsif ($return_value == 0) {
                # full house (cc: 3 & cc: 2)
                $return_value = 5 ;
            }

        }
        
        if ($size == 3) {
            # check for three of a kind (cc: 3 & cc: 1 & cc: 1)
            if ( $count{$key} == 3 ) {
                $return_value = 4 ;
            } elsif ($return_value == 0 ) {
                # two pair (cc: 2 & cc: 2 & cc:1)
                $return_value = 3 ;
            }
        }

        if ($size == 4) {
            # check for one pair (cc: 2 & cc: 1 & cc: 1 & cc: 1)
            if ( $count{$key} == 2 ) {
                $return_value = 2 ;
            }
        }
        if ($size == 5) {
            # check for high card (cc: 1 & cc: 1 & cc: 1 & cc: 1 & cc: 1)
            if ( $count{$key} == 1 ) {
                $return_value = 1 ;
            }
        }

    }


    return $return_value ;

}



sub best_hand($) {
    my $hand = shift;

    my $best_rank = 0 ;
    my $best_hand = $hand ;
    my $try_hand = $hand ;
    my @numbers = (A,K,Q,T,9,8,7,6,5,4,3,2);

    foreach my $i ( @numbers ) {
        $try_hand = $hand ;
        $try_hand =~ s/J/$i/g;

        $try_rank = get_type($try_hand);
        if ($try_rank > $best_rank) {
            $best_rank = $try_rank ;
            $best_hand = $try_hand ;
        }

    }

    # printf("Hand: %s Best: %s Rank: %s\n", $hand, $best_hand, $best_rank) ;
    return $best_hand ;

}