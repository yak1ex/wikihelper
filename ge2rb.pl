#!/usr/bin/perl

use utf8;
use strict;
use warnings;

use Encode;
use YAML::Any;

use constant { FIXED => 0, SELECTABLE => 1 };

my %color = (
	green => '#0c0',
	purple => '#c0c',
	blue => '#88f',
	orange => '#fc0',
);

my $ability;

sub colorize_point
{
	my ($value, $key, $type) = @_;
	return '' if $value eq '';
	if($ability->{$key}{$type} < $value) { # greater
		return 'BGCOLOR(#fcc):'.$value;
	} elsif($ability->{$key}{$type} > $value) { # less
		return 'BGCOLOR(#ffb):'.$value;
	}
	return $value;
}

sub make_line
{
	my $entry = shift;
	my $rarity ='';
	if(defined $entry->[1] && $entry->[1] ne '') {
		$rarity = 'BGCOLOR('.$color{$entry->[1]}."):COLOR(#fff):''A''";
	}
	my ($skill, $condition) = map { ref $_ ? join('&br;', @$_) : $_; } @{$entry}[2,5];
	my $gap = colorize_point($entry->[3], $entry->[0], 'GAP');
	my  $ap = colorize_point($entry->[4], $entry->[0],  'AP');
	return '|'.join('|', $rarity, $entry->[0], $skill, $gap, $ap, $condition).'|';
}

$ability = YAML::Any::LoadFile(shift);

while(my $file = shift) {
	my $outfile = $file; $outfile =~ s/\.yaml/.wiki/;
	open my $out, '>', $outfile;
	print $out Encode::encode('utf8', <<EOF);
#contents

- 薄黄色セルは通常より習得GAP,APが小さいもの、薄赤色セルは通常より習得GAP,APが大きいもの

EOF
	my $dat = YAML::Any::LoadFile($file);
	foreach my $person (@$dat) {
		my ($key) = keys %$person;
		print $out Encode::encode('utf8', <<EOF);
** $key
///////////////////////////////////////////////////////////////////////////////
||名称|内容|習得GAP|習得AP|習得条件|h
|>|>|>|>|>|BGCOLOR(#ddf):選択外スキル|
EOF
		for my $entry (@{$person->{$key}[0]}) {
			print $out Encode::encode('utf8', make_line($entry)),"\n";
		}
		print $out Encode::encode('utf8', <<EOF);
|>|>|>|>|>|BGCOLOR(#ddf):選択可能スキル|
EOF
		for my $entry (@{$person->{$key}[1]}) {
			print $out Encode::encode('utf8', make_line($entry)),"\n";
		}
	}
}
