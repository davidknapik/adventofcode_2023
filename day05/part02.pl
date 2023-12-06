#!/usr/bin/perl 

# my $input_file = 'test_input.txt' ;
# my $input_file = 'test_input2.txt' ;
# my $input_file = 'input2.txt' ;
my $input_file = 'input.txt' ;
# my $input_file = 'input_a.txt' ;
# my $input_file = 'input_b.txt' ;
# my $input_file = 'input_c.txt' ;



my $start_time = time;

my @seeds ;
my @seed_to_soil ;
my @soil_to_fertilizer ;
my @fertilizer_to_water ;
my @water_to_light ;
my @light_to_temperature ;
my @temperature_to_humidity ;
my @humidity_to_location ;

my $lowest_location = '';


# populate seeds into @seeds array
&get_seeds(\@seeds);
&get_seeds_to_soil(\@seeds_to_soil);
&get_soil_to_fertilizer(\@soil_to_fertilizer);
&get_fertilizer_to_water(\@fertilizer_to_water);
&get_water_to_light(\@water_to_light);
&get_light_to_temperature(\@light_to_temperature);
&get_temperature_to_humidity(\@temperature_to_humidity);
&get_humidity_to_location(\@humidity_to_location);

foreach $row (@seeds){
    printf("Seed: %s Length: %s\n",$row->[0], $row->[1]);

    $seed_i = $row->[0];
    $seed_max = $seed_i + $row->[1];

    for ( $seed_i = $row->[0]; $seed_i <= $seed_max; $seed_i++) {

        if ($seed_i % 1000000 == 0) {
            printf("Seed: %s %s (s)\n", $seed_i, time - $start_time);
            $start_time = time ;
        }

        my $location = &map_it(&map_it(&map_it(&map_it(&map_it(&map_it(&map_it($seed_i, \@seeds_to_soil), \@soil_to_fertilizer), \@fertilizer_to_water), \@water_to_light), \@light_to_temperature), \@temperature_to_humidity), \@humidity_to_location) ;

        # my $soil = &map_it($seed_i, \@seeds_to_soil) ;
        # my $fertilizer = &map_it($soil, \@soil_to_fertilizer) ;
        # my $water = &map_it($fertilizer, \@fertilizer_to_water) ;
        # my $light = &map_it($water, \@water_to_light) ;
        # my $temperature = &map_it($light, \@light_to_temperature) ;
        # my $humidity = &map_it($temperature, \@temperature_to_humidity) ;
        # my $location = &map_it($humidity, \@humidity_to_location) ;

        # printf("Seed: %s Soil: %s Fertilizer: %s Water: %s Light: %s Temperature: %s Humidity: %s Location: %s\n",
        #     $seed_i, $soil, $fertilizer, $water, $light, $temperature, $humidity, $location);
        
        if ($location < $lowest_loc or $lowest_loc == '') {
            $lowest_loc = $location ;
        }
    } 
    printf("Lowest Location: %s\n\n", $lowest_loc);
}

printf("Lowest Location: %s\n", $lowest_loc);



exit;


#===============================================================================
# Subs
#===============================================================================

sub get_seeds(\@) {
    my ($seeds_ref) = @_;

    my $seed_index = 0;

    # read input file
    open(FH, '<', $input_file)
        or die $! ;

    # loop through all entries
    while(<FH>){

        chomp(my $input_line = $_) ;
        # printf("%s\n", $input_line );

        if ($input_line =~ m/^seeds/ ) {
            ($seed_str) = (split(/:/,$input_line))[1];
            $seed_str =~ s/^\s+|\s+$//;
            # printf("seedstr: %s\n",$seed_str);

            while( $seed_str =~ /(\d+\s\d+)/g){
                ($seed_start, $seed_length) = split(/ /, $1) ;
                ${$seeds_ref}[$seed_index][0] = $seed_start ;
                ${$seeds_ref}[$seed_index][1] = $seed_length ;
                $seed_index++; 
            }

            # add seeds to array            
            # @{$seeds_ref} = split(/\s+/, $seed_str);

        }
    }

    close(FH);

}

sub get_seeds_to_soil(\@) {
    my ($seeds_to_soil_ref) = @_;
    my $array_index = 0 ;

    # read input file
    open(FH, '<', $input_file)
        or die $! ;

    my $read_flag = 0 ;

    # loop through all entries
    while(<FH>){
        chomp(my $input_line = $_) ;

        if ($input_line =~ m/^$/ ) {
            # printf("Detected New line\n");
            $read_flag = 0 ;
        }

        if ($read_flag) {
            # printf("Using Line: %s\n", $input_line);
            ($dst, $src, $len) = split(/ /,$input_line);

            ${$seeds_to_soil_ref}[$array_index][0] = $dst;
            ${$seeds_to_soil_ref}[$array_index][1] = $src;
            ${$seeds_to_soil_ref}[$array_index][2] = $len;
            $array_index++;
        }

        # read each line until the line matches 'seed-to-soil map:'
        if ($input_line =~ m/^seed-to-soil/) {
            $read_flag = 1 ;
        }

    }
    close(FH) ;
}

sub get_soil_to_fertilizer(\@) {
    my ($soil_to_fertilizer_ref) = @_;
    my $array_index = 0 ;

    # read input file
    open(FH, '<', $input_file)
        or die $! ;

    my $read_flag = 0 ;

    # loop through all entries
    while(<FH>){
        chomp(my $input_line = $_) ;

        if ($input_line =~ m/^$/ ) {
            # printf("Detected New line\n");
            $read_flag = 0 ;
        }

        if ($read_flag) {
            # printf("Using Line: %s\n", $input_line);
            ($dst, $src, $len) = split(/ /,$input_line);

            ${$soil_to_fertilizer_ref}[$array_index][0] = $dst;
            ${$soil_to_fertilizer_ref}[$array_index][1] = $src;
            ${$soil_to_fertilizer_ref}[$array_index][2] = $len;
            $array_index++;
        }

        # read each line until the line matches 'seed-to-soil map:'
        if ($input_line =~ m/^soil-to-fertilizer/) {
            $read_flag = 1 ;
        }

    }
    close(FH) ;
}

sub get_fertilizer_to_water(\@) {
    my ($fertilizer_to_water_ref) = @_;
    my $array_index = 0 ;

    # read input file
    open(FH, '<', $input_file)
        or die $! ;

    my $read_flag = 0 ;

    # loop through all entries
    while(<FH>){
        chomp(my $input_line = $_) ;

        if ($input_line =~ m/^$/ ) {
            # printf("Detected New line\n");
            $read_flag = 0 ;
        }

        if ($read_flag) {
            # printf("Using Line: %s\n", $input_line);
            ($dst, $src, $len) = split(/ /,$input_line);

            ${$fertilizer_to_water_ref}[$array_index][0] = $dst;
            ${$fertilizer_to_water_ref}[$array_index][1] = $src;
            ${$fertilizer_to_water_ref}[$array_index][2] = $len;
            $array_index++;
        }

        # read each line until the line matches 'seed-to-soil map:'
        if ($input_line =~ m/^fertilizer-to-water/) {
            $read_flag = 1 ;
        }

    }
    close(FH) ;
}


sub get_water_to_light(\@) {
    my ($water_to_light_ref) = @_;
    my $array_index = 0 ;

    # read input file
    open(FH, '<', $input_file)
        or die $! ;

    my $read_flag = 0 ;

    # loop through all entries
    while(<FH>){
        chomp(my $input_line = $_) ;

        if ($input_line =~ m/^$/ ) {
            # printf("Detected New line\n");
            $read_flag = 0 ;
        }

        if ($read_flag) {
            # printf("Using Line: %s\n", $input_line);
            ($dst, $src, $len) = split(/ /,$input_line);

            ${$water_to_light_ref}[$array_index][0] = $dst;
            ${$water_to_light_ref}[$array_index][1] = $src;
            ${$water_to_light_ref}[$array_index][2] = $len;
            $array_index++;
        }

        # read each line until the line matches 'seed-to-soil map:'
        if ($input_line =~ m/^water-to-light/) {
            $read_flag = 1 ;
        }

    }
    close(FH) ;
}


sub get_light_to_temperature(\@) {
    my ($light_to_temperature_ref) = @_;
    my $array_index = 0 ;

    # read input file
    open(FH, '<', $input_file)
        or die $! ;

    my $read_flag = 0 ;

    # loop through all entries
    while(<FH>){
        chomp(my $input_line = $_) ;

        if ($input_line =~ m/^$/ ) {
            # printf("Detected New line\n");
            $read_flag = 0 ;
        }

        if ($read_flag) {
            # printf("Using Line: %s\n", $input_line);
            ($dst, $src, $len) = split(/ /,$input_line);

            ${$light_to_temperature_ref}[$array_index][0] = $dst;
            ${$light_to_temperature_ref}[$array_index][1] = $src;
            ${$light_to_temperature_ref}[$array_index][2] = $len;
            $array_index++;
        }

        # read each line until the line matches 'seed-to-soil map:'
        if ($input_line =~ m/^light-to-temperature/) {
            $read_flag = 1 ;
        }

    }
    close(FH) ;
}


sub get_temperature_to_humidity(\@) {
    my ($temperature_to_humidity_ref) = @_;
    my $array_index = 0 ;

    # read input file
    open(FH, '<', $input_file)
        or die $! ;

    my $read_flag = 0 ;

    # loop through all entries
    while(<FH>){
        chomp(my $input_line = $_) ;

        if ($input_line =~ m/^$/ ) {
            # printf("Detected New line\n");
            $read_flag = 0 ;
        }

        if ($read_flag) {
            # printf("Using Line: %s\n", $input_line);
            ($dst, $src, $len) = split(/ /,$input_line);

            ${$temperature_to_humidity_ref}[$array_index][0] = $dst;
            ${$temperature_to_humidity_ref}[$array_index][1] = $src;
            ${$temperature_to_humidity_ref}[$array_index][2] = $len;
            $array_index++;
        }

        # read each line until the line matches 'seed-to-soil map:'
        if ($input_line =~ m/^temperature-to-humidity/) {
            $read_flag = 1 ;
        }

    }
    close(FH) ;
}


sub get_humidity_to_location(\@) {
    my ($humidity_to_location_ref) = @_;
    my $array_index = 0 ;

    # read input file
    open(FH, '<', $input_file)
        or die $! ;

    my $read_flag = 0 ;

    # loop through all entries
    while(<FH>){
        chomp(my $input_line = $_) ;

        if ($input_line =~ m/^$/ ) {
            # printf("Detected New line\n");
            $read_flag = 0 ;
        }

        if ($read_flag) {
            # printf("Using Line: %s\n", $input_line);
            ($dst, $src, $len) = split(/ /,$input_line);

            ${$humidity_to_location_ref}[$array_index][0] = $dst;
            ${$humidity_to_location_ref}[$array_index][1] = $src;
            ${$humidity_to_location_ref}[$array_index][2] = $len;
            $array_index++;
        }

        # read each line until the line matches 'seed-to-soil map:'
        if ($input_line =~ m/^humidity-to-location/) {
            $read_flag = 1 ;
        }

    }
    close(FH) ;
}


sub map_it($\@) {

    my ($x, $array_ref) = @_;
    my $ret_val = $x ;

    foreach $row (@{$array_ref}){
        $dst = $row->[0];
        $src = $row->[1];
        $len = $row->[2];

        # printf("x: %s src: %s - %s dst: %s - %s len: %s\n", $x2, $src, $src+$len, $dst, $dst+$len, $len);

        if ($x >= $src and $x <= $src+$len-1) {
            $ret_val = $dst + ($x - $src) ;
            return $ret_val ;
        }
    }

    return $ret_val ;

}
