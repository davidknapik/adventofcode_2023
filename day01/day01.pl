#!/usr/bin/perl

my $input_file = 'test_input.txt' ;
my $input_file = 'test_input2.txt' ;
my $input_file = 'input.txt' ;
my $sum = 0 ; 
my $input_line ;
my $fixed_line ;
my $final_line ;

# read input file
open(FH, '<', $input_file)
	or die $! ;

# loop through all entries
while(<FH>){
	chomp($input_line = $_) ;
	printf("Input: %s\n",$input_line);

	$fixed_line = &text2digit($input_line);
	printf("Fixed: %s\n",$fixed_line);

	$final_line = &first_last($fixed_line);
	printf("Final: %s\n\n",$final_line) ;

	$sum = $sum + $final_line ;


}
printf("Total: %s\n",$sum); 

close(FH);

sub text2digit($){
	chomp(my ($input) = @_) ;

	$input =~ s/one/one1one/g;
	$input =~ s/two/two2two/g;
	$input =~ s/three/three3three/g;
	$input =~ s/four/four4four/g;
	$input =~ s/five/five5five/g;
	$input =~ s/six/six6six/g;
	$input =~ s/seven/seven7seven/g;
	$input =~ s/eight/eight8eight/g;
	$input =~ s/nine/nine9nine/g;

	return $input ;
}

sub first_last($){

	chomp(my ($num) = @_) ;
	$num =~ s/[a-zA-Z]*//g;

	printf("INPUT %s LEN %s\n",$num, length($num));
	if (length($num) == 1) {
		#$num = $num * 11 ;
		$num = $num . $num ;
	} elsif (length($num) > 2) {
		$num = substr($num, 0, 1) . substr($num, -1, 1) ;
	}

	return $num ;
}
