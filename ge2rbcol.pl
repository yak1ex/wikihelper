#!/usr/bin/perl

use utf8;
use strict;
use warnings;

use Encode;
use YAML::Any;

use constant { FIXED => 0, SELECTABLE => 1 };

my (%dat, %out);

while(my $file = shift) {
	my $dat = YAML::Any::LoadFile($file);
	foreach my $person (@$dat) {
		my ($key) = keys %$person;
		for my $entry (@{$person->{$key}[1]}) {
			$dat{$entry->[0]}{GAP}{$entry->[3]} ||= 0;
			$dat{$entry->[0]}{GAP}{$entry->[3]}++;
			$dat{$entry->[0]} {AP}{$entry->[4]} ||= 0;
			$dat{$entry->[0]} {AP}{$entry->[4]}++;
		}
	}
}

print YAML::Any::Dump(\%dat);
foreach my $key (keys %dat) {
	my ($gap_cnt, $gap_val, $ap_cnt, $ap_val) = (0, 0, 0, 0);
	foreach my $gap (keys %{$dat{$key}{GAP}}) {
		if($gap_cnt < $dat{$key}{GAP}{$gap} || $gap_cnt == $dat{$key}{GAP}{$gap} && $gap_val < $gap) {
			$gap_cnt = $dat{$key}{GAP}{$gap};
			$gap_val = 0+$gap if $gap ne '';
		}
	}
	foreach my  $ap (keys %{$dat{$key} {AP}}) {
		if( $ap_cnt < $dat{$key} {AP} {$ap} ||  $ap_cnt == $dat{$key} {AP} {$ap} &&  $ap_val <  $ap) {
			 $ap_cnt = $dat{$key} {AP} {$ap};
			 $ap_val = 0+ $ap if  $ap ne '';
		}
	}
	$out{$key}{GAP} = $gap_val;
	$out{$key} {AP} =  $ap_val;
}
print YAML::Any::Dump(\%out);
