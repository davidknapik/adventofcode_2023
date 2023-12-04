#!/usr/bin/perl 

my $input_file = 'test_input_2.txt' ;
# my $input_file = 'input_2.txt' ;

my $line_no = 0 ;
my $total_lines = &get_file_line_count(); 
printf("$input_file has $total_lines lines\n");


# read input file
open(FH, '<', $input_file)
	or die $! ;

# loop through all lines
while(<FH>){
	chomp($input_line = $_) ;
    $line_no++ ;

    printf("\nLine: %s \n", $line_no);

    if ($line_no > 1) {
        $above_line = &get_input_line($line_no - 1 );
        printf("AStr: %s\n", $above_line);
    }
    
    printf(" Str: %s\n", $input_line);

    if ($line_no < $total_lines) {
        $below_line = &get_input_line($line_no + 1 );
        printf("BStr: %s\n", $below_line);
    }
    printf("\n");

    # look for a gear on the line and record the position
    while ($input_line =~ m/\*/g) {
        my $gear_pos = $-[0] ;

        printf("Found * on line %s at pos %s\n",$line_no, $gear_pos) ;


        # check if number is adjacent and above the gear
        # read $line_no - 1 and capture all \d+
        while( $above_line =~ /(\d+)/g){
            my $str_found = $1 ;
            my $str_start = $-[0] ;
            my $str_length = length($1) ;
            my $str_end = $str_start + $str_length - 1 ;

            if (&is_adjacent($gear_pos, $str_start, $str_length)) {
                printf("Found: %s start: %s end: %s length: %s\n", $str_found, $str_start, $str_end, $str_length );

                # add number to array
            }

        }

        # # check if number is next to the gear (same line)
        # while( $input_line =~ /(\d+)/g){
        #     $str_found = $1 ;
        #     $str_start = $-[0] ;
        #     $str_length = length($1) ;
        #     $str_end = $str_start + $str_length - 1 ;

        #     if (&is_adjacent($gear_pos, $str_start, $str_length)) {
        #         printf("Found: %s start: %s end: %s length: %s\n", $str_found, $str_start, $str_end, $str_length );

        #         # add number to array
        #     }

        # }

        # check if number is below the gear


    }




}

close(FH);

printf("Total: %s\n",$total);


sub get_input_line($) {
    # returns string from file

    my ($line_no) = @_ ;
    my $line_cnt = 0 ;

    open(FH2, '<', $input_file)
        or die $! ;

    while(<FH2>){
        $line_cnt++; 

	    chomp(my $input_line2 = $_) ;

        if ( $line_cnt == $line_no ) {
            return $input_line2 ;
        }

    }
    close(FH2);

}

sub get_file_line_count() {
    my $count ;
    open(FILE, "< $input_file") or die "can't open $input_file: $!";
    $count++ while <FILE>;

    close(FILE) ;
    return $count ;
}

sub is_adjacent($$$) {

    my ($gear_pos, $str_pos, $str_len ) = @_ ;

    my $ret = 0 ;
    my $str_start = $str_pos ;
    my $str_end = $str_pos + $str_len ;
    
    # printf("Trying: start: %s end: %s length: %s\n", $str_start, $str_end, $str_length );

    if($str_start > 0 ) {
        if ( ($gear_pos >= ($str_start - 1)) and ($gear_pos <= $str_end + 1) ) {
            # printf("Found: %s start: %s end: %s length: %s\n", $str_found, $str_start, $str_end, $str_length );
            $ret = 1 ;
        }                
    } else {
        if ( ($gear_pos >= $str_start) and ($gear_pos <= $str_end + 1) ) {
            # printf("Found: %s start: %s end: %s length: %s\n", $str_found, $str_start, $str_end, $str_length );
            $ret = 1 ;
        }       
    }

    return $ret ;

}