#!/usr/bin/perl

# my $input_file = 'test_input.txt' ;
my $input_file = 'input.txt' ;

my $total_winnings = 0 ;
my $card_total = 0 ;
my @match_count ;
my @card_count ;

# read input file
open(FH, '<', $input_file)
	or die $! ;

# loop through all entries
while(<FH>){

    chomp(my $input_line = $_) ;

    my ( $card_str, $win_str, $draw_str ) = split(/[:,|]/,$input_line) ;

    $win_str =~ s/^\s+|\s+$//;
    $draw_str =~ s/^\s+|\s+$//;
    
    printf("%s\n",$card_str);
    # printf("win: '%s'\n",$win_str);
    # printf("draw: '%s'\n",$draw_str);

    
    my $card_num = (split(/\s+/, $card_str))[1];
    my @win_arr = split(/\s+/, $win_str);
    my @draw_arr = split(/\s+/, $draw_str);


    my $num_win = &num_win(\@win_arr, \@draw_arr);
    my $card_value = &calculate_value($num_win) ; 

    # number of cards won (match_count), card_count at this point is the original card
    $match_count[$card_num] = $num_win ;
    $card_count[$card_num] = 1 ;

    # printf("MatchCount: %s\n", $match_count[$card_num]);

    printf("Winning: %s Value: %s\n", $num_win, $card_value);
    printf("\n");

    $total_winnings+=$card_value ;
}

printf("=========================================================\n");

# do something with @match_count & @card_count
$card_total = &card_winnings(\@match_count, \@card_count);



printf("Total Winnings: %s card total: %s\n",$total_winnings, $card_total);

# 0 0
# 1 1
# 2 1,2
# 3 1,2,4
# 4 1,2,4,8
# 5 1,2,4,8,16
# 6 1,2,4,8,16,32



sub num_win(\@\@) {
    my ($win_ref, $draw_ref) = @_;
    my $ret_num = 0 ;

    foreach $w_num (@{$win_ref}) {
        # printf("x: %s\n",$w_num);
        foreach $d_num (@{$draw_ref}) {
            if ($w_num == $d_num ) {
                # printf("Found Winning Number: %s\n", $w_num);
                $ret_num++;
            }
        }
    }

    return $ret_num ;
}


sub calculate_value($) {
    chomp(my ($win_count) = @_) ; 
    my $calc_value = 0;

    if ($win_count == 0) {
        $calc_value = 0 ;
    } else {
        $calc_value = 2**($win_count-1) ;
    }

    return $calc_value ;
}

sub card_winnings(\@\@) {
    # match_ref is how many matching numbers each card has
    # card_ref is the total number of each card after calculating the matching numbers
    my ($match_ref, $card_ref) = @_;
    my $card_total = 0 ;
    my $card_no = 0 ; 

    # starting at card 1,
    # get the number of matching numbers for that card (card 1 matching numbers is 10)
    # get the card count for that card (card 1 card count is 1)
    # increment the next 10 cards by +1 
    # go to next card
    foreach $match_num (@{$match_ref}) {

        printf("Card %s: Card Count: %s Match Value: %s\n", $card_no, ${$card_ref}[$card_no], $match_num);

        for ( $i = ($card_no + 1); $i < ($card_no + 1 + $match_num); $i++){
            ${$card_ref}[$i]+=${$card_ref}[$card_no];
            printf("Card: %s Count: %s\n",$i, ${$card_ref}[$i]);

        }
        printf("\n");

        $card_no++ ;

    }


    # sum up all of the cards in card_count and return that value
    foreach $j (@{$card_ref}) {
        $card_total += $j;
    }

    return $card_total ;

}