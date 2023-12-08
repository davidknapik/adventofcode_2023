#!/usr/bin/perl 


# my $input_file = 'test_input1.txt' ;
# my $input_file = 'test_input2.txt' ;
# my $input_file = 'test_input3.txt' ; # 6
my $input_file = 'input.txt' ;  # 12,315,788,159,977

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
            printf("Node_index: %d hit Z at step %d\n",$array_index2, $step_count );
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

#
# Found the frequency the patters for each repeates and then find LCM for the numbers
#
#       0	            1       		2       		3       		4       		5	
#       BXA             KBA     		VTA     		AAA     		HMA     		HLA	
#       13200	        22410	        18726	        18112		    16270		    20568	
# 13201	26401	22411	44821	18727	37453	18113	36225	16271	32541	20569	41137	
# 13201	39602	22411	67232	18727	56180	18113	54338	16271	48812	20569	61706	
# 13201	52803	22411	89643	18727	74907	18113	72451	16271	65083	20569	82275	
# 13201	66004	22411	112054	18727	93634	18113	90564	16271	81354	20569	102844	
# 13201	79205	22411	134465	18727	112361	18113	108677	16271	97625	20569	123413	
# 13201	92406	22411	156876	18727	131088	18113	126790	16271	113896	20569	143982	

#
#LCM( 13201, 22411, 18727, 18113, 16271, 20569 ) = 12,315,788,159,977