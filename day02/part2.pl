#!/usr/bin/perl

# my $input_file = 'test_input.txt' ;
my $input_file = 'input.txt' ;


#
# init some variables
my $game_total = 0 ;
my $b_min = 0 ;
my $r_min = 0 ;
my $g_min = 0 ;
my $sum_total = 0 ;

# read input file
open(FH, '<', $input_file)
	or die $! ;


while(<FH>){
	chomp($input_line = $_) ;
    $b_min = 0 ;
    $r_min = 0 ;
    $g_min = 0 ;

#    printf("%s\n",$input_line);
    ($game_id, $game_data) = split(/:/,$input_line ) ;
    ($game_id) = (split(/ /, $game_id))[1] ;

    printf("GameID: %s\t %s\n", $game_id,$game_data);

    # check reds
    while( $game_data =~ /(\d+) red/g){
        # printf("GameID: %s red: %s\n",$game_id, $1);
        if($1 > $r_min) {
            $r_min = $1 ;
        }
    }

    # check green
    while( $game_data =~ /(\d+) green/g){
        # printf("GameID: %s green: %s\n",$game_id, $1);
        if($1 > $g_min) {
            $g_min = $1 ;
        }
    }

    # check blues
    while( $game_data =~ /(\d+) blue/g){
        # printf("GameID: %s blue: %s\n",$game_id, $1);
        if($1 > $b_min) {
            $b_min = $1 ;
        }
    }

    $game_total = $r_min * $g_min * $b_min ;

    printf("GameID: %s\tR_min: %s\tB_min: %s\tG_min: %s\tTotal: %s\n\n", $game_id, $r_min, $g_min, $b_min, $game_total );

    $sum_total+=$game_total;

}

printf("Sum Total: %s\n", $sum_total );

close(FH);

