#!/usr/bin/perl 

# my $input_file = 'test_input01.txt' ; # 4
# my $input_file = 'test_input02.txt' ; # 8
my $input_file = 'input.txt' ;

my @map ;
my $count = 0 ;

# load in array
open(FH, '<', $input_file)
    or die $! ;

# read in file to @map array
my $line_idx = 0 ; 
while(my $input_line = <FH>){
    chomp($input_line) ;
    for (my $char_idx = 0; $char_idx <= length($input_line)-1; $char_idx++){
        $char = substr($input_line, $char_idx,1) ; 
        $map[$line_idx][$char_idx] =  $char ;
        # printf("map[%d, %d] = %s\n", $line_idx, $char_idx, $char );
        
        if($char =~ /S/) {
            $player_x_orig = $char_idx ;
            $player_y_orig = $line_idx ;
            printf("Found player at: %d x %d\n", $player_x_orig, $player_y_orig);
        }
    }
    $line_idx++;
}

close(FH);


# dump array to verify
printf("Array size: %d %d\n", scalar(@map), scalar(@{$map[1]}));
for ($y_idx = 0 ; $y_idx <= scalar(@map)-1; $y_idx++ ) {
    for ($x_idx = 0; $x_idx <= scalar(@{$map[1]})-1; $x_idx++){
        printf("%s",$map[$y_idx][$x_idx]);
    }
    printf("\n");
}

# figure out which way can go from 'S'

$player_x = $player_x_orig;
$player_y = $player_y_orig;

# printf("Up: %s\n", $map[$player_y-1][$player_x]);
# printf("Down: %s\n", $map[$player_y+1][$player_x]);
# printf("Left: %s\n", $map[$player_y][$player_x-1]);
# printf("Right: %s\n", $map[$player_y][$player_x+1]);

if ( $map[$player_y-1][$player_x] =~ m/[\|7F]/ ) {
    # check 'up'
    $player_y = $player_y - 1 ;
    $last_dir = "up" ;
    $count++;
    printf("Moving Up (%3d, %3d) (%s)\n", $player_x, $player_y, $last_dir) ;
} elsif ( $map[$player_y+1][$player_x] =~ m/[\|JL]/) {
    # check 'down'
    $player_y = $player_y + 1 ;
    $last_dir = "down" ;
    $count++;
    printf("Moving Down (%3d, %3d) (%s)\n", $player_x, $player_y, $last_dir) ;
} elsif ( $map[$player_y][$player_x-1] =~ m/[FL\-]/ ) {
    # check 'left'
    $player_x = $player_x-1 ;
    $last_dir = "left" ;
    $count++;
    printf("Moving Left (%3d, %3d) (%s)\n", $player_x, $player_y, $last_dir) ;
} elsif ( $map[$player_y][$player_x+1] =~ m/[7J\-]/ ) {
    # check 'right'
    $player_x = $player_x+1 ;
    $last_dir = "right" ;
    $count++;
    printf("Moving Right (%3d, %3d) (%s)\n", $player_x, $player_y, $last_dir) ;
}


while ($map[$player_y][$player_x] !~ m/[S]/) {
    # get current character
    $current_char = $map[$player_y][$player_x] ;
    # printf("Current Char: %s\n", $current_char);

    # if current characer = | 
    #   if last_dir = up 1
    #       go up
    #   if last_dir = down 2 
    #       go down
    if ( $current_char =~ m/[|]/) {
        if ($last_dir eq "up") {
            # try to move up
            if ( $map[$player_y-1][$player_x] =~ m/[\|7FS]/ ) {
                # check 'up'
                $player_y = $player_y - 1 ;
                $last_dir = "up" ;
                printf("Moving Up (%3d, %3d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            } else {
                printf("Something bad happend trying to move up (%d, %d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            }
        } elsif ($last_dir eq "down") {
            if ( $map[$player_y+1][$player_x] =~ m/[\|JLS]/) {
                # check 'down'
                $player_y = $player_y + 1 ;
                $last_dir = "down" ;
                printf("Moving Down (%3d, %3d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            } else {
                printf("Something bad happend trying to move down (%d, %d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            }
        } else {
            printf("Something bad happend trying to move\n");
        }
    }

    # if current characer = L 
    #   if last_dir = down 2
    #       go right
    #   if last_dir = left 3
    #       go up
    if ( $current_char =~ m/[L]/) {
        if ($last_dir eq "down") {
            if ( $map[$player_y][$player_x+1] =~ m/[7J\-S]/ ) {
                # check 'right'
                $player_x = $player_x+1 ;
                $last_dir = "right" ;
                printf("Moving Right (%3d, %3d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            } else {
                printf("Something bad happend trying to move right (%d, %d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            }
        } elsif ($last_dir eq "left") {
            # try to move up
            if ( $map[$player_y-1][$player_x] =~ m/[\|7FS]/ ) {
                # check 'up'
                $player_y = $player_y - 1 ;
                $last_dir = "up" ;
                printf("Moving Up (%3d, %3d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            } else {
                printf("Something bad happend trying to move up (%d, %d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            }
        } else {
            printf("Something bad happend trying to move\n");
        }
    }

    # if current characer = - 
    #   if last_dir = right 4
    #       go right
    #   if last_dir = left 3 
    #       go left
    if ( $current_char =~ m/[-]/) {
        if ($last_dir eq "right") {
            if ( $map[$player_y][$player_x+1] =~ m/[7J\-S]/ ) {
                # check 'right'
                $player_x = $player_x+1 ;
                $last_dir = "right" ;
                printf("Moving Right (%3d, %3d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            } else {
                printf("Something bad happend trying to move right (%d, %d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            }
        } elsif ($last_dir eq "left") {
            if ( $map[$player_y][$player_x-1] =~ m/[FL\-S]/ ) {
                # check 'left'
                $player_x = $player_x-1 ;
                $last_dir = "left" ;
                printf("Moving Left (%3d, %3d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            } else {
                printf("Something bad happend trying to move left (%d, %d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            }
        } else {
            printf("Something bad happend trying to move\n");
        }
    }

    # if current characer = J
    #   if last_dir = down 2
    #       go left
    #   if last_dir = right 4
    #       go up
    if ( $current_char =~ m/[J]/) {
        if ($last_dir eq "down") {
            if ( $map[$player_y][$player_x-1] =~ m/[FL\-S]/ ) {
                # check 'left'
                $player_x = $player_x-1 ;
                $last_dir = "left" ;
                printf("Moving Left (%3d, %3d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            } else {
                printf("Something bad happend trying to move left (%d, %d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            }
        } elsif ($last_dir eq "right") {
            # try to move up
            if ( $map[$player_y-1][$player_x] =~ m/[\|7FS]/ ) {
                # check 'up'
                $player_y = $player_y - 1 ;
                $last_dir = "up" ;
                printf("Moving Up (%3d, %3d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            } else {
                printf("Something bad happend trying to move up (%d, %d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            }
        } else {
            printf("Something bad happend trying to move\n");
        }
    }

    # if current characer = 7
    #   if last_dir = up 1
    #       go left
    #   if last_dir = right 4
    #       go down
    if ( $current_char =~ m/[7]/) {
        if ($last_dir eq "up") {
            if ( $map[$player_y][$player_x-1] =~ m/[FL\-S]/ ) {
                # check 'left'
                $player_x = $player_x-1 ;
                $last_dir = "left" ;
                printf("Moving Left (%3d, %3d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            } else {
                printf("Something bad happend trying to move left (%d, %d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            }
        } elsif ($last_dir eq "right") {
            if ( $map[$player_y+1][$player_x] =~ m/[\|JLS]/) {
                # check 'down'
                $player_y = $player_y + 1 ;
                $last_dir = "down" ;
                printf("Moving Down (%3d, %3d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            } else {
                printf("Something bad happend trying to move down (%d, %d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            }
        } else {
            printf("Something bad happend trying to move\n");
        }
    }

    # if current characer = F
    #   if last_dir = up
    #       go right
    #   if last_dir = left 
    #       go down
    if ( $current_char =~ m/[F]/) {
        if ($last_dir eq "up") {
            if ( $map[$player_y][$player_x+1] =~ m/[7J\-S]/ ) {
                # check 'right'
                $player_x = $player_x+1 ;
                $last_dir = "right" ;
                printf("Moving Right (%3d, %3d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            } else {
                printf("Something bad happend trying to move right (%d, %d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            }
        } elsif ($last_dir eq "left") {
            if ( $map[$player_y+1][$player_x] =~ m/[\|JLS]/) {
                # check 'down'
                $player_y = $player_y + 1 ;
                $last_dir = "down" ;
                printf("Moving Down (%3d, %3d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            } else {
                printf("Something bad happend trying to move down (%d, %d) (%s) (%s)\n", $player_x, $player_y, $current_char, $last_dir) ;
            }
        } else {
            printf("Something bad happend trying to move\n");
        }
    }

    $count++;


}

printf("Count = %d Furthest: %d\n", $count, $count/2);

exit ;
