#!/usr/bin/perl 

# my $input_file = 'test_input.txt' ; # 2
my $input_file = 'input.txt' ; # 1053
my $start_time = time;
my $grand_total = 0 ;


open(FH, '<', $input_file)
    or die $! ;

my $line_idx = 1 ; 
while(<FH>){    
    chomp(my $input_line = $_) ;
    my @line = split(/ /,$input_line) ;

    $node_string = join(" ", map { sprintf "%8d", $_ } @line);
    printf("Input Line: %s\n", $node_string) ;

    $get_diff = &get_diffs( \@line );
    $next_number = $line[0] - $get_diff ;


    printf("Previous Number in sequence: %d\n",$next_number);
    $grand_total+=$next_number ;
}


printf("Grand Total: %d\n",$grand_total);

printf("Duration: %02d:%02d:%02d\n", (gmtime(time - $start_time))[2,1,0]) ;
exit ;


sub get_diffs(\@) {
    my ($line_ref) = @_;
    my $line_size = @{$line_ref} ;

    my @diff_array ;
    my $diff = -1 ;

    for (my $i = 0 ; $i <= $line_size-2 ; $i++) {
        $cell_diff = @{$line_ref}[$i+1] - @{$line_ref}[$i]; 
        push(@diff_array, $cell_diff); 

        # printf("line[%d]: %d Diff: %d\n", $i, @{$line_ref}[$i], $cell_diff);

    }


    # test if all elements in @diff_array are the same
    if (@diff_array == grep { $_ eq $string } @diff_array) {
        # all equal
        $diff = @diff_array[0];
    } else {
        $get_diff = &get_diffs( \@diff_array );

        # add the $get_diff to first element of @diff_array and return that number
        $diff = $diff_array[0] - $get_diff ;
        unshift(@diff_array, $diff); 
    }

    return $diff ;


}