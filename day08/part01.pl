#!/usr/bin/perl 

# my $input_file = 'test_input1.txt' ;
# my $input_file = 'test_input2.txt' ;
my $input_file = 'input.txt' ;



%dirmap = () ;

# read input
# populate direction hash


open(FH, '<', $input_file)
    or die $! ;

my $line_idx = 1 ; 
while(<FH>){    
    chomp(my $input_line = $_) ;

    # first line contains the directions to follow
    if ($line_idx == 1) {
        $dir_str = $input_line ;
        # printf("directions: %s\n", $dir_str) ;
    }

    # lines with '=' have mappings
    if ($input_line =~ m/(\w+)\s=\s\((\w+),\s(\w+)\)/) {
        # found a map; add it to hash
        $dirmap{$1}{'NODE'} = $1 ;
        $dirmap{$1}{'L'} = $2 ;
        $dirmap{$1}{'R'} = $3 ;
    
        # printf("Node: %s L: %s R: %s\n", $1, $2, $3) ;
    }

    $line_idx++ ;

}

$current_node = 'AAA' ;
$str_idx = 0 ;
$step_count = 0 ;

until ($current_node eq "ZZZ") {
    printf("Current Node: %s Step: %d\n", $current_node, $step_count);

    if ($str_idx >= length($dir_str)) {
        $str_idx = 0 ;
    }

    $dir = substr($dir_str, $str_idx, 1) ;
    printf("Dir: %s\n",$dir);

    if( $dir eq "R" ) {
        $current_node = $dirmap{$current_node}{'R'} ;
    } else {
        $current_node = $dirmap{$current_node}{'L'} ;
    }

    $str_idx++ ;
    $step_count++;
}
printf("Current Node: %s Step: %d\n", $current_node, $step_count);

printf("\n");

printf("Step Count: %d\n", $step_count);
