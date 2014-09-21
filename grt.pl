#!/usr/local/bin/perl 
use strict;
use warnings;

my $stop_path = 'data/stop_times.txt';
my $trip_path = 'data/trips.txt';
my $season = '14FALL';
#cmd inputs - 

my $stopid;
my $day;
my $timeregex = '\d\d:\d\d:\d\d';
my %trips;
my @out;
&GetInput();
&GetTrips();

my $period = "$season-All-$day";

#Read trips file into a hash for easy reference later on
open (my $TRIPS, '<', $trip_path)
		or die "ERROR Can't open file, $!";
	while (my $line = <$TRIPS>) {
		chomp($line);
		if($line =~ /,$period-\d+,(\d+)$/){
			#print "$1 , $line \n";
			$trips{$1} = [ split(/,/, $line) ];  #HoA from perldoc
		}
	}
close $TRIPS;
	
my %out;
	
print "Selected stop is $stopid \n";

#Get the trip ids for given stop
open(my $STOPS, '<', $stop_path) 
	or die "ERROR Can't open file, $!";
while (my $line = <$STOPS>){
	
#Find all trips at that stop, and check if trip is a valid (date/type, etc)
	if ($line =~ /^(\d+),$timeregex,($timeregex),($stopid),/){
		if (exists($trips{$1})){
			#print "$2 $1 $3 $trips{$1}[3] $trips{$1}[5]\n";			
			my $str = "$2 $1 $3 $trips{$1}[3]\n";
			push(@out, $str);
			#print $out[0];
		}
	}
	
	
	#my @stopdata = split(/,/, $_);
	#if ($stopdata[3] == $stopid){
	#	}
	

}

my @sortedout = sort(@out);
foreach (@sortedout){
	print "$_";
}
close ($STOPS);


sub GetTrips{
	
}

sub GetInput{ 
	if ($ARGV[0] && $ARGV[1] && $ARGV[0] =~ /\d\d\d\d/ && $ARGV[1] =~ /(Weekday|Saturday|Sunday)/){
		
	#if ($ARGV[0] && $ARGV[0] =~ /\d\d\d\d/) $stopid = $ARGV[0];
	#if (!$stopid){
	#	print "Please enter stop number\n";
		
		$stopid = $ARGV[0];
	#if ($ARGV[0] && $ARGV[1])
		#$stopid = ($ARGV[0])? $ARGV[0] : chomp(<STDIN>);
		$day = $ARGV[1];
	} else {
		print "Need parameters - STOPID(xxxx) DAYOFWEEK(Weekday|Saturday|Sunday)\n";
		exit;
	}
}
	
	
