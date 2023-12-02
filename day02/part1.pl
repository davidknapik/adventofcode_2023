#!/usr/bin/perl

my $input_file = 'test_input.txt' ;
my $input_file = 'input.txt' ;


#
# number of cubes loaded into the sack
my $r_loaded = 12 ;
my $g_loaded = 13 ;
my $b_loaded = 14 ;
my $valid_game = 1 ;
my $game_total = 0 ;

# read input file
open(FH, '<', $input_file)
	or die $! ;


while(<FH>){
	chomp($input_line = $_) ;
    $valid_game = 1 ;

#    printf("%s\n",$input_line);
    ($game_id, $game_data) = split(/:/,$input_line ) ;
    ($game_id) = (split(/ /, $game_id))[1] ;

    printf("GameID: %s\t %s\n", $game_id,$game_data);

    # check blues
    while( $game_data =~ /(\d+) blue/g){
        # printf("GameID: %s blue: %s\n",$game_id, $1);
        if($1 > $b_loaded) {
            $valid_game = 0 ;
        }
    }

    # check reds
    while( $game_data =~ /(\d+) red/g){
        # printf("GameID: %s red: %s\n",$game_id, $1);
        if($1 > $r_loaded) {
            $valid_game = 0 ;
        }
    }

    # check green
    while( $game_data =~ /(\d+) green/g){
        # printf("GameID: %s green: %s\n",$game_id, $1);
        if($1 > $g_loaded) {
            $valid_game = 0 ;
        }
    }

    printf("GameID: %s\tValid: %s\n\n", $game_id, $valid_game );
    
    if($valid_game == 1 ){
        $game_total = $game_total + $game_id ;
    }
}

printf("Game Total: %s\n", $game_total );

close(FH);

