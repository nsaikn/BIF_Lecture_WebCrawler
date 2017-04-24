=Header
	Creating a program that will find all my lecture pages from my professor's home page and download the information. Program will grep through the listed options on the home page and searches for all pages pertaining to BIF712 or BIF724. Then create a new text file for each individual page. 
=cut

use strict;
use warnings;
use CGI;
use LWP::Simple;

sub getPages($$);
sub downloadPages($$);
sub cleanUpPage($);
my @pages712; # array containing paths to 712 course
my @pages724; # array containing paths to 724 course

###### Get a list of target pages to download ######
getPages(\@pages712, \@pages724);

downloadPages(\@pages712, \@pages724);


# get pages will get all the pages related to BIF712 and 724 and store them in the @page array. 
# https://scs.senecac.on.ca/~danny.abesdris/tree_items.js contains the paths to all the pages. 

sub getPages($$){
	my $pages712Ref = shift;
	my $pages724Ref = shift;
	my $homepage = get "https://scs.senecac.on.ca/~danny.abesdris/tree_items.js";

	while( $homepage =~ /([^\n]+)\n?/g ){
		# using grep will saave the match in $1. 
		if( $1 =~ /(\'bif712.153.+\')/ ){

			push @$pages712Ref, substr($1, 1,-1);
		}
		if( $1 =~ /(\'bif724.171.+\')/ ){
			push @$pages724Ref, substr($1, 1,-1);
		}
	}

}

sub downloadPages($$){
	my $pages712Ref = shift;
	my $pages724Ref = shift;
	my $page;
	foreach my $each (@$pages712Ref){
		my ($name) = $each =~/([\w\.]*)(.html)/;
		$page = get "https://scs.senecac.on.ca/~danny.abesdris/$each";
		cleanUpPage($page);

		open (my fh, ">>", "$name.txt") or die $!;
		print $fh cleanUpPage($page)
		close $fh;

	}
	foreach my $each (@$pages724Ref){
		my ($name) = $each =~/([\w\.]*)(.html)/;
		$page = get "https://scs.senecac.on.ca/~danny.abesdris/$each";
		cleanUpPage($page);

		open (my fh, ">>", "$name.txt") or die $!;
		print $fh cleanUpPage($page)
		close $fh;
	}
}

sub cleanUpPage($){

}


