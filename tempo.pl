#!/usr/bin/perl

my $weather_url = 'http://metroclima.procempa.com.br/dados_json.php';
my @weather_results;

print "=> Downloading weather information...\n";
open CURL, "curl -# $weather_url |";
my @resp = <CURL>;
close CURL;

for (@resp) {
     next unless (/.+/);

     while (/
\[?
  \{
     ([^\}\}]+)
  \}
\]?/gx) {
        push @weather_results, $1;
    }
}

print "=> Displaying weather information:\n";
for (@weather_results) {
    while (/\"([^\"]+)\":"([^\"]+)\"/g) {
        next if $1 =~ /ID|LATITUDE|LONGITUDE/;

        my $key = $1;
        my $value = $2;
	if ($key =~ /ESTACAO/) {
            print "#####################\n$value\n";
            next;
	}

        print "$key: $value\n";
    }
}
