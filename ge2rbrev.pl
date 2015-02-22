#!/usr/bin/perl

use utf8;
use strict;
use warnings;

use Encode;
use YAML::Any;

use constant { FIXED => 0, SELECTABLE => 1 }; 

my ($name, $cur, $column, $mode, @dat, $temp);

while(<>) {
	s/[\r\n]+//;
	$_ = Encode::decode('utf8', $_);
	if(m|\*\*\s+(\S+)|) {
		$name = $1;
		if(defined $cur && $name ne $cur) {
			push @dat, $temp;
		}
		$cur = $name;
		$temp = { $name => [[],[]] };
	} elsif(/\|BGCOLOR\([^)]*\):選択外スキル\|/) {
		$mode = FIXED;
	} elsif(/\|BGCOLOR\([^)]*\):選択可能スキル\|/) {
		$mode = SELECTABLE;
	} elsif($_ !~ m@\|h$|^/+$|^$@) {
		next unless defined $name;
		my @t = split /\|/;
		my $offset = ($column == 6 ? 0 : 1);
		# 6 colmuns without rarity, 1:name,2:skills,3:GAP,4:AP,5:condition
		# 7 columns with    rarity, 1:rarity,2:name,3:skills,4:GAP,5:AP,6:condition
		$t[2+$offset] ||= '';
		my @skill = split(/&br;/, $t[2+$offset]);
		$t[5+$offset] ||= '';
		my @condition = split(/&br;/, $t[5+$offset]);
		@t[3+$offset,4+$offset] = map { s/^BGCOLOR\([^)]*\)://; $_ =~ /^[0-9]+$/ ? 0+$_ : $_ } @t[3+$offset,4+$offset];
		my $rarity = '';
		if($column == 7) {
			if($t[1] =~ /#0c0/)      { $rarity = 'green';
			} elsif($t[1] =~ /#c0c/) { $rarity = 'purple';
			} elsif($t[1] =~ /#88f/) { $rarity = 'blue';
			} elsif($t[1] =~ /#fc0/) { $rarity = 'orange';
			}
		}
		push $temp->{$name}->[$mode], [ $t[1+$offset], $rarity, (1==@skill?$skill[0]:\@skill), $t[3+$offset], $t[4+$offset], (0==@condition?'':1==@condition?$condition[0]:\@condition) ];
	} elsif($column = ($_ =~ s/\|/|/g)) {
	}

}
push @dat, $temp;

print YAML::Any::Dump(\@dat);
