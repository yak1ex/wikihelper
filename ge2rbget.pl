#!/usr/bin/perl

use utf8;
use strict;
use warnings;

use Encode;
use LWP::UserAgent;
use YAML::Any;

my $url = YAML::Any::LoadFile(shift);
my $ua = LWP::UserAgent->new(agent => '');

foreach my $key (keys %$url) {
	my $response = $ua->get($url->{$key});
	if($response->is_success) {
		my $content = $response->decoded_content;
		$content =~ s/.*<textarea[^>]*>//s;
		$content =~ s|</textarea>.*||s;
		$content =~ s/&lt;/</g;
		$content =~ s/&gt;/>/g;
		$content =~ s/&quot;/"/g;
		$content =~ s/&amp;/&/g;
		$content =~ s/&#8544;/Ⅰ/g;
		$content =~ s/&#8545;/Ⅱ/g;
		$content =~ s/&#8546;/Ⅲ/g;
		$content =~ s/&#8547;/Ⅳ/g;
		open my $fh, "| perl ge2rbrev.pl > ${key}#.yaml";
		print $fh Encode::encode('utf-8', $content);
		close $fh;
	} else {
		print "Error for $key\n";
	}
}
