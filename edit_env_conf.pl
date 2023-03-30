#!/bin/env perl

use strict;
use warnings;


die "Need input file and argument parameters" if scalar $#ARGV < 1;

my $inputFile = $ARGV[0];

my %vals;

foreach my $i (1..$#ARGV) {
    my ($k, $v) = split(m/=/, $ARGV[$i]);
    $vals{$k} = $v;
}

my $outputFile = "$inputFile.new";

open my $in, "<", $inputFile or die "Unable to read input file $inputFile: $!";
open my $out, ">", $outputFile or die "Unable to write output file $outputFile: $!";

while (my $line = <$in>) {
    chomp($line);
    if ($line =~ m/^export +(\S+?)=$/) {
        if ($vals{$1}) {
            print $out "export $1=$vals{$1}\n";
        } else {
            print $out $line, "\n";
        }
    } else {
        print $out $line, "\n";
    }
}

close $out;
close $in;

rename($outputFile, $inputFile) or die "Unable to rename $outputFile to $inputFile: $!";


