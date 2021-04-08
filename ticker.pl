#!/usr/bin/perl
use strict;
use warnings;
no feature qw/indirect/;
use Term::ANSIColor;
use POSIX qw|strftime tzset|;
use LWP::UserAgent ();
use URI::Escape;
use JSON::XS;

my @symbols;

for (@ARGV) {
	/[^A-Z0-9-=^]+/ && next;
	push(@symbols, $_);
}

if(!scalar(@symbols)) {
	@symbols=qw{^GSPC ^IXIC ABTC-USD EURUSD=X AAPL TSLA GOOG FB AMZN};
	#@symbols=qw{WPM GOLD NEM GC=F SI=F SH AAPL TSLA GOOG FB AMZN};
}

my @fields=qw(symbol marketState regularMarketTime
	regularMarketPrice regularMarketChange regularMarketChangePercent
	preMarketPrice preMarketChange preMarketChangePercent);

my $ua=LWP::UserAgent->new(timeout=>5);
my $resp=$ua->get('http://query1.finance.yahoo.com/v7/finance/quote?'.
	join('&',
		qw|lang=en-US	region=US	corsDomain=finance.yahoo.com/|,
		'fields='.join(',',@fields),
		'symbols='.join(',', map {uri_escape($_)} @symbols)
	));
unless ($resp->is_success) {
	die $resp->status_line;
}

my $str=$resp->decoded_content;
my $co=decode_json($str);
ref($co) eq 'HASH' and exists( $co->{'quoteResponse'} ) or die('Wrong format');
$co = $co->{'quoteResponse'};
unless( ref($co) eq 'HASH' and exists($co->{'error'}) and exists($co->{'result'}) ) {
	die("Wrong format");
}
if (defined $co->{'error'}) {
	die("Error: ".$co->{'error'});
}
$co = $co->{'result'};
ref($co) eq 'ARRAY' or die("Wrong format");

# market time and timezone comes from the last ticker in the list
my $pre=0;
my $closed=0;
my $time;
my $tzname;
for my $h (@$co) {
	exists($h->{'symbol'}) or die("Wrong format");

	$tzname=$h->{exchangeTimezoneName};

	$pre =$h->{'marketState'} eq 'PRE'?1:0;
	$closed =$h->{'marketState'} eq 'CLOSED'?1:0;
	$time = $h->{regularMarketTime};

	my $prefix=$pre?'pre':'regular';
	my $price=$h->{"${prefix}MarketPrice"};
	my $change=$h->{"${prefix}MarketChange"};
	my $changep=$h->{"${prefix}MarketChangePercent"};
	my $inc=$change>=0?'green':'red';
	printf("%s%-10s%s%8.2f%s%10.2f %9s%s%s\n",
		color('bold'),$h->{'symbol'},color('reset'),
		$price,color($inc),$change,sprintf('(%.02f%%)',$changep),color('reset'),
		$pre?' *':'');
}
$ENV{'TZ'}=$tzname || 'America/New_York';
tzset();
printf "@ %s\n",strftime("%Y-%m-%d %H:%M:%S %Z",localtime($time));
if ($pre) {
	print "* means pre-market values\n";
} elsif($closed){
	print "market closed!\n";
}

