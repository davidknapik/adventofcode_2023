#!/usr/bin/perl 

# my $input_file = 'test_input.txt' ;
my $input_file = 'input.txt' ;
my $start_time = time;
my @time_array ;
my @dst_array ;
my $total_wins = '' ;


# populate seeds into @seeds array
&load_input(\@time_array, \@dst_array);


#
# loop through the entries
#
foreach $i (0 .. $#time_array) {

    my $wins = &calc_wins($time_array[$i], $dst_array[$i]) ;

    printf("Index: %s time: %s distance: %s wins: %s\n\n", $i, $time_array[$i], $dst_array[$i], $wins );
    
    if ($total_wins == '') {
        $total_wins = $wins ;
    } else {
        $total_wins = $total_wins * $wins ;
    }

}

printf("Total Wins: %s\n",$total_wins) ;

$end_time = time ;

printf("Duration: %s(s)\n", $end_time - $start_time ) ;


exit ;




#===============================================================================
# Subs
#===============================================================================

sub load_input(\@\@) {
    my ($time_ref, $dst_ref) = @_;

    # read input file
    open(FH, '<', $input_file)
        or die $! ;

    # loop through all entries
    while(<FH>){    
        chomp(my $input_line = $_) ;

        $time_index = 0 ;
        $dst_index = 0 ;
        if ( $input_line =~ m/^Time/ ) {
            ($time_str) = (split(/:/,$input_line))[1];
            $time_str =~ s/^\s+|\s+$// ;
            $time_str =~ s/\s+//g ;

            # printf("TimeStr: %s\n",$time_str) ;
            @{$time_ref} = split(/\s+/, $time_str) ;


        }

        if ( $input_line =~ m/^Distance/ ) {
            ($dst_str) = (split(/:/,$input_line))[1] ;
            $dst_str =~ s/^\s+|\s+$// ;
            $dst_str =~ s/\s+//g ;

            # printf("DstStr: %s\n",$dst_str) ;
            @{$dst_ref} = split(/\s+/, $dst_str) ;
        }

    }

    close(FH);

}

sub calc_wins($$) {
    my ($total_time, $dist) = @_;

    $return_value = 0 ; 


# t=7s d=9m
# speed = rate = hold_time
# travel_time = (total_time - hold_time)s
# rate = hold _time
# rate * travel_time = distance
# 0s hold = 7 seconds of travel at 0m/s =  0m
# 1s hold = 6 seconds of travel at 1m/s =  6m
# 2s hold = 5 seconds of travel at 2m/s = 10m
# 3s hold = (t-h)


    # dist = rate * time
    for ($rate = 0 ; $rate <= $total_time; $rate++) {

        $travel_time = $total_time - $rate ; 
        $distance = $rate * $travel_time ;

        if ($distance > $dist ) {
            $return_value++;

            if ($rate % 10000000 == 0) {
                printf("Distance: %s = rate: %s * time: %s | Duration: %s\n", $distance, $rate, $travel_time, time - $start_time ) ;
            }

        }

    }

    return $return_value ;

}
