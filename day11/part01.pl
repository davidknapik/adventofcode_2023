#!/usr/bin/perl 
use Data::Dumper;

# my $input_file = 'test_input.txt' ; # 374
my $input_file = 'input.txt' ; # 9591768

my @map ;
my @map_tmp ;

my %empty_col = ();
my $total_distance = 0 ;

# load in map
open(FH, '<', $input_file)
    or die $! ;

# read in map and adjust for empty rows
my $y_idx = 0 ; 
while(my $input_line = <FH>){
    chomp($input_line) ;

    # if row is empty (all '.'), then add an additional row of all empty
    if ($input_line !~ m/#/g) {
        printf("Found empty row: %d\n", $y_idx);
        for (my $x_idx = 0; $x_idx <= length($input_line)-1; $x_idx++){
            my $char = substr($input_line, $x_idx, 1) ; 
            $map[$x_idx][$y_idx] =  '.' ;
        }
        $y_idx++;     
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
my $n=0 ;
for ($y_idx = 0 ; $y_idx < $y_max; $y_idx++ ){
    for ($x_idx = 0 ; $x_idx < $x_max + $empty_size ; $x_idx++) {
        if (exists $empty_col{$x_idx} ) {
            printf("Row: %3d adding col: %3d\n", $y_idx, $x_idx+$n);
            $map_tmp[$x_idx+$n][$y_idx] =  $map[$x_idx][$y_idx]; 
            $n++;
            $map_tmp[$x_idx+$n][$y_idx] =  "."; 
        } else {
            $map_tmp[$x_idx+$n][$y_idx] =  $map[$x_idx][$y_idx]; 
        }
    }
    $n = 0 ;
}
$x_max = $x_max + $empty_size ;

printf("Array Size %3d x %3d\n", $x_max, $y_max);

@map = @map_tmp ;

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

for ($gal_num = 0; $gal_num < $gal_size; $gal_num++){
    for ($gal_N = $gal_num+1; $gal_N < $gal_size; $gal_N++){

        ($gal_num_x, $gal_num_y) = split(/ /,$gal_list[$gal_num]) ;
        ($gal_N_x, $gal_N_y) = split(/ /, $gal_list[$gal_N]) ;
        $dist = abs($gal_num_x - $gal_N_x) + abs($gal_num_y - $gal_N_y);
        $total_distance+=$dist;
        printf("Row: %d Gal: %s GalX: %s Dist: %d\n", $gal_num, $gal_list[$gal_num], $gal_list[$gal_N], $dist);

    }
}
# print out galaxy list
# print Dumper @gal_list;

printf("Total Distance: %d\n", $total_distance);