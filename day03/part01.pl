#!/usr/bin/perl

# my $input_file = 'test_input2.txt' ;
my $input_file = 'input.txt' ;
my $line_no = 0 ;
my $total_lines = &get_file_lines(); 
printf("$input_file has $total_lines lines\n");
my $total = 0 ; 

# read input file
open(FH, '<', $input_file)
	or die $! ;

# loop through all entries
while(<FH>){
	chomp($input_line = $_) ;
    my $input_length = length($input_line) - 1 ;
    $line_no++ ;
    my $before_str ;
    my $after_str ;


    printf("\nLine: %s \n", $line_no);

    if ($line_no > 1) {
        $before_str = get_input_line($line_no - 1) ;
        printf("AStr: %s\n", $before_str);
    }

    printf("LStr: %s\n", $input_line);

    if ($line_no < $total_lines) {
        $after_str = get_input_line($line_no + 1) ;
        printf("BStr: %s\n", $after_str);
    }
    printf("\n");

    # printf("\nInput Line: %s\n%s\n%s\n", $line_no, $input_line, length($input_line));

    # find numbers in the line
    while( $input_line =~ /(\d+)/g){
        my $str_found = $1 ;
        my $str_pos = $-[0] ;
        my $str_length = length($1) ;
        my $valid = 0 ;

        # printf("Line: %s : %s start: %s end: %s\n", $., $1, @-, length($1) );
        printf("Found: %s start: %s length: %s\n", $str_found, $str_pos, $str_length );

        # $my_regex = '[@*#+$\/\\&%=-]';

        # check if string is at beginnging of line
        if ($str_pos == 0) {
            $start_pos = 0 ;
            $end_pos = $str_pos + $str_length + 1 ;
        } elsif ($str_pos + $str_length - 1 == $input_length) {
            # check if string is at end of line
            $start_pos = $str_pos - 1 ;
            $end_pos = $str_pos + $str_length - 1 ;
        } else {
            $start_pos = $str_pos - 1 ;
            $end_pos = $str_pos + $str_length;
        }

        # 
        # check left of str_pos for symbol
        # if str_pos == 0 , there is no symbol before
        #
        printf("Checking left: %s length %s\n", $str_pos - 1, 1);
        if ($str_pos == 0) {
                printf("\tNo characters to the left of string\n") ;
        } else {
            if ( substr($input_line, $str_pos - 1, 1) !~ m/[\.]/g ) {
                $valid = 1 ;
                printf("\tFound valid symbol left of string\n") ;
            }
        }

        #
        # check right (after) of str_pos + str_length for symbol
        # if str_pos+str_length at the end of line there is no symbol after
        #
        printf("Checking right: %s length %s\n", $str_pos + $str_length, 1);
        if ( ($str_pos + $str_length) > $input_length ) {
            printf("\tNo characters to the right of string\n") ;
        } else {
            if ( substr($input_line, $str_pos + $str_length, 1) !~ m/[\.]/g ) {
                $valid = 1 ;
                printf("\tFound valid symbol right of string\n") ;
            }
        }

        #
        # check line above for symbol
        # if line_no == 1, there is no line above
        #
        printf("Checking above: %s to %s\n", $start_pos, $end_pos );
        if ($line_no == 1) {
            printf("\tNo lines above this one\n");
        } else {
            if ( substr($before_str, $start_pos, $end_pos - $start_pos + 1) =~ m/[^\d\.]/ ) {
                printf("\tFound valid symbol above string: %s\n", substr($before_str, $start_pos, $end_pos - $start_pos + 1)) ;
                $valid = 1 ;
            }
        }

        #
        # check line below for symbol
        # if last line, there is no line below
        #
        printf("Checking below: %s to %s\n", $start_pos, $end_pos);
        if ($line_no < $total_lines) {
            if ( substr($after_str, $start_pos, $end_pos - $start_pos + 1) =~ m/[^\d\.]/ ) {
                printf("\tFound valid symbol below string: %s\n", substr($after_str, $start_pos, $end_pos - $start_pos + 1)) ;
                $valid = 1 ;
            }
        } else {
            printf("\tNo lines below this one\n");
        }
        
        if ($valid == 1){
            printf("Valid\n");
            $total+=$str_found;
        } else {
            printf("Not Valid\n");
        
        }

        printf("\n");

    }
    printf("\n");

}

close(FH);

printf("Total: %s\n",$total) ;



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

sub get_file_lines() {
    my $count ;
    open(FILE, "< $input_file") or die "can't open $input_file: $!";
    $count++ while <FILE>;

    close(FILE) ;
    return $count ;
}