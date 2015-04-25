#!/usr/bin/perl

use utf8;
use strict;
use warnings;

use Encode;
use YAML::Any;

use constant { FIXED => 0, SELECTABLE => 1 };

my (%dat, %out);

while(my $file = shift) {
	print STDERR "Loading $file...\n";
	my $dat = YAML::Any::LoadFile($file);
	foreach my $person (@$dat) {
		my ($key) = keys %$person;
		next if @{$person->{$key}[0]} == 0 &&  @{$person->{$key}[1]} == 0;
		for my $entry (@{$person->{$key}[1]}) {
			if($entry->[3] ne '') {
				$dat{$entry->[0]}{GAP}{$entry->[3]} ||= 0;
				$dat{$entry->[0]}{GAP}{$entry->[3]}++;
			}
			if($entry->[4] ne '') {
				$dat{$entry->[0]} {AP}{$entry->[4]} ||= 0;
				$dat{$entry->[0]} {AP}{$entry->[4]}++;
			}
			if($entry->[1] ne '') {
				if(defined $out{$entry->[0]}{RARE} && $out{$entry->[0]}{RARE} ne '') {
					warn Encode::encode('utf8', "$entry->[0] $out{$entry->[0]}{RARE} vs $entry->[1]") if $out{$entry->[0]}{RARE} ne $entry->[1];
				}
				$out{$entry->[0]}{RARE} = $entry->[1];
			}
			if($entry->[2] ne '') {
				$out{$entry->[0]}{SKILL} = $entry->[2];
			}
		}
	}
}

#print YAML::Any::Dump(\%dat);
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
