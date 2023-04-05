#!/bin/env perl

use strict;
use warnings;

use Getopt::Long;


my ($outputFile, $dbName);
my $output = GetOptions(
    "output=s"          => \$outputFile,
    "db-name=s"         => \$dbName,
);

die "Need --output output file" if not $outputFile or not -f $outputFile;

$dbName = "" if not $dbName;


open my $fh, ">", $outputFile or die "Unable to write to $outputFile: $!";

$fh->print(<<CONFIG);
[database]
user=
password=
;host=
;port=
;ip_range=
;database=$dbName

[idmapping]
table_name=idmapping
uniprot_id=uniprot_id

[idmapping.maps]
GI=enabled
EMBL-CDS=enabled
RefSeq=enabled
PDB=enabled

[cluster]
queue=
extra_path=

CONFIG
;

close $fh;



