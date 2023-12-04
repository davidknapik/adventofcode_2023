#!/usr/bin/perl

# my $input_file = 'test_input.txt' ;
my $input_file = 'input.txt' ;

my $total_winnings = 0 ;

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
    printf("win: '%s'\n",$win_str);
    printf("draw: '%s'\n",$draw_str);

    
    my $card_num = (split(/\s+/, $card_str))[1];
    my @win_arr = split(/\s+/, $win_str);
    my @draw_arr = split(/\s+/, $draw_str);


    my $num_win = &num_win(\@win_arr, \@draw_arr);
    my $card_value = &calculate_value($num_win) ; 

    printf("Winning: %s Value: %s\n", $num_win, $card_value);
    printf("\n");

    $total_winnings+=$card_value ;

}

printf("Total Winnings: %s\n",$total_winnings);

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
                printf("Found Winning Number: %s\n", $w_num);
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