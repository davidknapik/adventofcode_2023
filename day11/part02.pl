#!/usr/bin/perl 
use Data::Dumper;

my $input_file = 'test_input.txt' ; # 1030 (10) ; 8410 (100)
my $input_file = 'input.txt' ; # 9591768 (2) ; 746962097860 (10000000)

my @map ;
my @map_tmp ;

my %empty_col = ();
my $total_distance = 0 ;
my $distance_empty_space = 10000000 ;

# load in map
open(FH, '<', $input_file)
    or die $! ;

# read in map and adjust for empty rows
my $y_idx = 0 ; 
while(my $input_line = <FH>){
    chomp($input_line) ;

    # if row is empty (all '.'), then replace with 'x'
    if ($input_line !~ m/#/g) {
        printf("Found empty row: %d\n", $y_idx);
        $input_line =~ s/\./x/g; 
        # for (my $x_idx = 0; $x_idx <= length($input_line)-1; $x_idx++){
        #     my $char = substr($input_line, $x_idx, 1) ; 
        #     $map[$x_idx][$y_idx] =  '.' ;
        # }
        # $y_idx++;     
    }

    for (my $x_idx = 0; $x_idx <= length($input_line)-1; $x_idx++){
        my $char = substr($input_line, $x_idx, 1) ; 
        $map[$x_idx][$y_idx] =  $char ;
    }
    $y_idx++ ;
    $x_max = length($input_line);
    $y_max = $y_idx ;
}

# find empty columns and add to a list
for ($x_idx = 0 ; $x_idx < $x_max ; $x_idx++){
    my $found_gal = 0 ;
    for ( $y_idx = 0 ; $y_idx < $y_max ; $y_idx++) {
        if ($map[$x_idx][$y_idx] eq "#" ) {
            $found_gal = 1 ;
        }
    }
    if ($found_gal == 0){
        printf("Found empty column: %d\n", $x_idx);
        $empty_col{$x_idx} = $x_idx;
    }
}
$empty_size = keys %empty_col ;
printf("Empty Col: %d\n", $empty_size);

# Add additional columns
# loop through original array and add empty column based on %empty_col list
for ($y_idx = 0 ; $y_idx < $y_max; $y_idx++ ){
    for ($x_idx = 0 ; $x_idx < $x_max ; $x_idx++) {
        if (exists $empty_col{$x_idx} ) {
            printf("Row: %3d %3d\n", $y_idx, $x_idx);
            $map[$x_idx][$y_idx] =  "x"; 
        } 
    }
}

printf("Array Size %3d x %3d\n", $x_max, $y_max);

# dump array
for ( $y_idx = 0 ; $y_idx < $y_max ; $y_idx++) {
    printf("%3d: ",$y_idx);
    for ($x_idx = 0 ; $x_idx < $x_max ; $x_idx++){
    #    printf("(%3d,%3d) %s\n",$x_idx, $y_idx, $map[$x_idx][$y_idx]);
        printf("%s",$map[$x_idx][$y_idx]);
    }
    printf("\n");
}



# go through @map and find the coordinates of the #
my @gal_list ;
for ($y_idx = 0 ; $y_idx < $y_max; $y_idx++) {
    for ($x_idx = 0 ; $x_idx < $x_max; $x_idx++){
        if ($map[$x_idx][$y_idx] eq "#") {
            $gal_x = $x_idx+1;
            $gal_y = $y_idx+1;
            push(@gal_list, "$gal_x $gal_y");
        }
    }
}
$gal_size = scalar @gal_list;

# find distance between galaxy's
for ($gal_num = 0; $gal_num < $gal_size; $gal_num++){
    for ($gal_N = $gal_num+1; $gal_N < $gal_size; $gal_N++){

        my $dist_mul = 0 ;

        my ($gal_num_x, $gal_num_y) = split(/ /,$gal_list[$gal_num]) ;
        my ($gal_N_x, $gal_N_y) = split(/ /, $gal_list[$gal_N]) ;
        printf("Galaxy Pair: (%d %d) - (%d %d)\n", $gal_num_x-1, $gal_num_y-1,$gal_N_x-1, $gal_N_y-1 );

        # find number of 'x' between gal_num and gal_N
        for ($check_y = $gal_num_y; $check_y < $gal_N_y; $check_y++){
            # printf("(y) Checking %d %d\n", $gal_num_x-1, $check_y);
            if ($map[$gal_num_x-1][$check_y] eq "x") {
                # printf("Found x %d %d\n", $gal_num_x-1, $check_y);
                $dist_mul++ ;
            }
        }

        if ($gal_num_x > $gal_N_x) {
            for ($check_x = $gal_num_x-1; $check_x >= $gal_N_x; $check_x--){
                # printf("(x) Checking %d %d\n", $check_x, $gal_num_y-1);
                if ($map[$check_x][$gal_num_y-1] eq "x") {
                    # printf("Found x %d %d\n", $check_x, $gal_num_y-1);
                    $dist_mul++ ;
                }
            }
        } else {
            for ($check_x = $gal_num_x; $check_x < $gal_N_x; $check_x++){
                # printf("(x) Checking %d %d\n", $check_x, $gal_num_y-1);
                if ($map[$check_x][$gal_num_y-1] eq "x") {
                    # printf("Found x %d %d\n", $check_x, $gal_num_y-1);
                    $dist_mul++ ;
                }
            }
        }


        $dist = abs($gal_num_x - $gal_N_x) + abs($gal_num_y - $gal_N_y) - $dist_mul + $dist_mul * $distance_empty_space ;
        printf("Row: %d Gal: %s GalX: %s Dist: %d Dist_Mul: %d\n\n", $gal_num, $gal_list[$gal_num], $gal_list[$gal_N], $dist, $dist_mul) ;

        $total_distance+=$dist;

    }
}
# print out galaxy list
# print Dumper @gal_list;

printf("Total Distance: %d\n", $total_distance);