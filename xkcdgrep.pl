#!/usr/bin/perl

use warnings;
use strict;

my @imglist;
my $last_comic = 'none';
my $option = 'none';
my $selected;

if (defined $ARGV[0]) {
    $option = $ARGV[0];
}

print "=> Downloading XKCD information...\n";
open CURL, "curl -# http://xkcd.com/ |";
while (<CURL>) {
    push(@imglist, "$1") while /<img.*src=[\"\']([a-z0-9\-\._~!\$&'\(\)\*+,;=:\/?@]+)[\"|\'].*\/>/gi;

    # <li><a rel="prev" href="/1432/" accesskey="p">&lt; Prev</a></li>
    if (/<a.*href=\"\/(\d+)\/\".*Prev<\/a>/gi) {
    	$last_comic = $1;
    }
}
close CURL;

$selected = $option;
if ($option =~ /ra?n?d?o?m?/i) {
    unless ($last_comic =~ /\d+/) {
       print "Failed to find which was the last comic\n";
       exit 1;
   }

   $last_comic++;
   $selected = int(rand($last_comic)) + 1;
}

if ($selected ne 'none') {
    print "=> Selected comic is: $selected\n";

    # Find new image URLs
    undef @imglist;
    open CURL, "curl -# http://xkcd.com/$selected/ |";
    while (<CURL>) {
        push(@imglist, "$1") while /<img.*src=[\"\']([a-z0-9\-\._~!\$&'\(\)\*+,;=:\/?@]+)[\"|\'].*\/>/gi;
    }
    close CURL;
}

foreach (@imglist) {
    if (/\/comics\//) {
	print "=> Downloading comic...\n";
	open FH, "curl -# -o comic.png $_ |";
	close FH;
    }
}

open FH, "impressive -c memory comic.png |";
close FH;
