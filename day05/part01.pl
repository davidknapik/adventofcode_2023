#!/usr/bin/perl 

# my $input_file = 'test_input.txt' ;
my $input_file = 'input.txt' ;

my @seeds ;
my $lowest_location = '';


# populate seeds into @seeds array
&get_seeds(\@seeds);

foreach $seed (@seeds) {

    my $soil = &seed_to_soil($seed) ;
    my $fertilizer = &soil_to_fertilizer($soil) ;
    my $water = &fertilizer_to_water($fertilizer) ;
    my $light = &water_to_light($water) ;
    my $temperature = &light_to_temperature($light);
    my $humidity = &temperature_to_humidity($temperature) ;
    my $location = &humidity_to_location($humidity);

    printf("Seed: %s Soil: %s Fertilizer: %s Water: %s Light: %s Temperature: %s Humidity: %s Location: %s\n",
        $seed, $soil, $fertilizer, $water, $light, $temperature, $humidity, $location);
    
    if ($location < $lowest_loc or $lowest_loc == '') {
        $lowest_loc = $location ;
    }

}

printf("Lowest Location: %s\n", $lowest_loc);



exit;


#===============================================================================
# Subs
#===============================================================================

sub get_seeds(\@) {
    my ($seeds_ref) = @_;

    # read input file
    open(FH, '<', $input_file)
        or die $! ;

    # loop through all entries
    while(<FH>){

        chomp(my $input_line = $_) ;
        # printf("%s\n", $input_line );

        if ($input_line =~ m/seeds/ ) {
            ($seed_str) = (split(/:/,$input_line))[1];
            $seed_str =~ s/^\s+|\s+$//;
            # printf("seedstr: %s\n",$seed_str);

            # add seeds to array            
            @{$seeds_ref} = split(/\s+/, $seed_str);

        }
    }

    close(FH);

}

sub seed_to_soil($){

    my ($x0) = @_;
    my $ret_val = $x0 ;

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

            if ($x0 >= $src and $x0 <= $src+$len-1) {
                $ret_val = $dst + ($x0 - $src) ;
            }
            
        }

        # read each line until the line matches 'seed-to-soil map:'
        if ($input_line =~ m/^seed-to-soil/) {
            $read_flag = 1 ;
        }

    }
    close(FH) ;

    return $ret_val ;

}



sub soil_to_fertilizer($){

    my ($x1) = @_;
    my $ret_val = $x1 ;

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

            if ($x1 >=$src and $x1 <= $src+$len-1) {
                $ret_val = $dst + ($x1 - $src) ;
            }
            
        }

        # read each line until the line matches 'seed-to-soil map:'
        if ($input_line =~ m/^soil-to-fertilizer/) {
            $read_flag = 1 ;
        }

    }
    close(FH) ;

    return $ret_val ;

}

sub fertilizer_to_water($) {

    my ($x2) = @_;
    my $ret_val = $x2 ;
    # printf("checking fertilizer value: %s\n", $x2);

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

            if ( $x2 >= $src and $x2 <= $src+$len-1) {
                # printf("x: %s src: %s - %s dst: %s - %s len: %s\n", $x2, $src, $src+$len, $dst, $dst+$len, $len);
                $ret_val = $dst + ($x2 - $src) ;
            }
        }

        # read each line until the line matches map
        if ($input_line =~ m/^fertilizer-to-water/) {
            $read_flag = 1 ;
        }

    }
    close(FH) ;

    return $ret_val ;

}


sub water_to_light($) {

    my ($x2) = @_;
    my $ret_val = $x2 ;
    # printf("checking fertilizer value: %s\n", $x2);

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

            if ( $x2 >= $src and $x2 <= $src+$len-1) {
                # printf("x: %s src: %s - %s dst: %s - %s len: %s\n", $x2, $src, $src+$len, $dst, $dst+$len, $len);
                $ret_val = $dst + ($x2 - $src) ;
            }
        }

        # read each line until the line matches map
        if ($input_line =~ m/^water-to-light/) {
            $read_flag = 1 ;
        }

    }
    close(FH) ;

    return $ret_val ;

}


sub light_to_temperature($) {

    my ($x2) = @_;
    my $ret_val = $x2 ;
    # printf("checking fertilizer value: %s\n", $x2);

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

            if ( $x2 >= $src and $x2 <= $src+$len-1) {
                # printf("x: %s src: %s - %s dst: %s - %s len: %s\n", $x2, $src, $src+$len, $dst, $dst+$len, $len);
                $ret_val = $dst + ($x2 - $src) ;
            }
        }

        # read each line until the line matches map
        if ($input_line =~ m/^light-to-temperature/) {
            $read_flag = 1 ;
        }

    }
    close(FH) ;

    return $ret_val ;

}



sub temperature_to_humidity($) {

    my ($x2) = @_;
    my $ret_val = $x2 ;
    # printf("checking fertilizer value: %s\n", $x2);

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

            if ( $x2 >= $src and $x2 <= $src+$len-1) {
                # printf("x: %s src: %s - %s dst: %s - %s len: %s\n", $x2, $src, $src+$len, $dst, $dst+$len, $len);
                $ret_val = $dst + ($x2 - $src) ;
            }
        }

        # read each line until the line matches map
        if ($input_line =~ m/^temperature-to-humidity/) {
            $read_flag = 1 ;
        }

    }
    close(FH) ;

    return $ret_val ;

}



sub humidity_to_location($) {

    my ($x2) = @_;
    my $ret_val = $x2 ;
    # printf("checking fertilizer value: %s\n", $x2);

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

            if ( $x2 >= $src and $x2 <= $src+$len-1) {
                # printf("x: %s src: %s - %s dst: %s - %s len: %s\n", $x2, $src, $src+$len, $dst, $dst+$len, $len);
                $ret_val = $dst + ($x2 - $src) ;
            }
        }

        # read each line until the line matches map
        if ($input_line =~ m/^humidity-to-location/) {
            $read_flag = 1 ;
        }

    }
    close(FH) ;

    return $ret_val ;

}

