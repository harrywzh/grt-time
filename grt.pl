#!/usr/local/bin/perl 

#Harry Zihui Wang
#harrywzh
#GRT Stop Combined Schedule Script

use strict;
use warnings;

my $stop_path = 'data/stop_times.txt';
my $trip_path = 'data/trips.txt';
my $season = '14FALL';

my $stopid;
my $day;
my $timeregex = '\d\d:\d\d:\d\d';
my %trips;
my @out;
&GetInput();

#Build string for getting season
my $period = "$season-All-$day";

#Read trips file into a hash for easy reference later on as each bus-time must look up
open (my $TRIPS, '<', $trip_path)
		or die "ERROR Can't open file, $!";
	while (my $line = <$TRIPS>) {
		chomp($line);
		if($line =~ /,$period-\d\d-*(\d*),(\d+)$/){
			#print "$1 , $line \n";\
			$trips{$2} = [ split(/,/, $line) ];  #HoA from perldoc
			$trips{$2}[3] .= &DayException($1) if $1;
		}
	}
close $TRIPS;	
	
print "Selected stop is $stopid for $day\n";

#Get the trip ids for given stop
#trip ids assumed to be unique

open(my $STOPS, '<', $stop_path) 
	or die "ERROR Can't open file, $!";
while (my $line = <$STOPS>){
	
#Find all trips at that stop, and check if trip is a valid (date/type, etc)
#Extract all data using regex
	if ($line =~ /^(\d+),$timeregex,($timeregex),($stopid),/){
		if (exists($trips{$1})){
			my $str = "$2 $3 $trips{$1}[3]";
			#$str .= $1
			push(@out, $str);
			#print $out[0];
		}
	}
}


#Sort output by time
#Timestamp respects ASCII order, since GTFS defines times past midnight as time+24hr
my @sortedout = sort(@out);
foreach (@sortedout){
	print "$_\n";
}
close ($STOPS);



#Adds exceptions for trips only on certain days
sub DayException{ 
	#1 Parameter - the exception string code
	my $str = $_[0];
	return " [HF]" if ($str eq '0001100');
	return " [F]" if ($str eq '0000100');
	return " [MTWH]" if ($str eq '1111000');
	return "";
}

#Get and check command line arguments
sub GetInput{ 
	if ($ARGV[0] && $ARGV[1] && $ARGV[1] =~ /\d\d\d\d/ && $ARGV[0] =~ /(Weekday|Saturday|Sunday)/){
		
	#if ($ARGV[0] && $ARGV[0] =~ /\d\d\d\d/) $stopid = $ARGV[0];
	#if (!$stopid){
	#	print "Please enter stop number\n";
		$day = $ARGV[0];
		$stopid = $ARGV[1];
	} else {
		print "Need parameters - DAYOFWEEK(Weekday|Saturday|Sunday) STOPID(xxxx) \n";
		exit;
	}
}

#TODO
#-Dynamic column header search to account for different source data order
#-Better formatting/printable output
#-Search by time range