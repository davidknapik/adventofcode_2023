#!/usr/bin/perl 

# my $input_file = 'test_input1.txt' ;
# my $input_file = 'test_input2.txt' ;
# my $input_file = 'test_input3.txt' ;
my $input_file = 'input.txt' ;
my $start_time = time;
my @current_nodes ;


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
        $node = $1 ;
        $left = $2 ;
        $right = $3 ;
        $dirmap{$node}{'NODE'} = $node ;
        $dirmap{$node}{'L'} = $left ;
        $dirmap{$node}{'R'} = $right ;
    
        # printf("Node: %s L: %s R: %s\n", $1, $2, $3) ;
        if ($node =~ m/\w\w[A]/) {
            push @current_nodes, $node ;
        }
    }

    $line_idx++ ;

}


# push @current_nodes, '11A' ;
# push @current_nodes, '22A' ;
# $current_node = 'AAA' ;
$str_idx = 0 ;
$step_count = 0 ;
$exit = 0 ;
$current_nodes_size = @current_nodes ;

until ($exit == 1) {

    $exit = 1 ;

    if ($step_count % 1000000 == 0) {
        $node_string = join(" ", map { sprintf "%3s", $_ } @current_nodes);
        printf("Current Nodes: %s Size: %d Step: %d\n", $node_string, $current_nodes_size, $step_count);
    }

    if ($str_idx >= length($dir_str)) {
        $str_idx = 0 ;
    }

    $dir = substr($dir_str, $str_idx, 1) ;
    # printf("Dir: %s\n",$dir);

    for ( $array_index = 0; $array_index <= $current_nodes_size-1; $array_index++ ) {

        $current_node = $current_nodes[$array_index] ;

        if( $dir eq "R" ) {
            $new_node = $dirmap{$current_node}{'R'} ;
        } else {
            $new_node = $dirmap{$current_node}{'L'} ;
        }
        # printf("Current node: %s New Node: %s Array index: %d Array Size: %d\n",$current_node, $new_node, $array_index, $current_nodes_size);
        $current_nodes[$array_index] = $new_node ;

    }
        # check all nodes to see if they end in Z

    $match = 0 ;
    for ( $array_index2 = 0; $array_index2 <= $current_nodes_size-1; $array_index2++ ) {

        if ($current_nodes[$array_index2] =~ m/\w\w[Z]/) {
            $match++ ;
        } else {
            $exit = 0 ;
        }
    }
    if ($match == $current_nodes_size){
        $exit = 1 ;
    }

    $step_count++;
    $str_idx++ ;
    # printf("\n");

}

$node_string = join(" ", map { sprintf "%3s", $_ } @current_nodes);
printf("Final Nodes: %s Step: %d\n", $node_string, $step_count);

printf("\n");

printf("Step Count: %d\n", $step_count);

printf("Duration: %02d:%02d:%02d\n", (gmtime(time - $start_time))[2,1,0]) ;
