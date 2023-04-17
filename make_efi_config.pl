#!/bin/env perl

use strict;
use warnings;

use Getopt::Long;


my ($outputFile, $dbName, $dbi);
my $output = GetOptions(
    "output=s"          => \$outputFile,
    "db-name=s"         => \$dbName,
    "db-interface=s"    => \$dbi,
);

die "Need --output output file" if not $outputFile;

$dbName = "" if not $dbName;
$dbi = "" if not $dbi;


open my $fh, ">", $outputFile or die "Unable to write to $outputFile: $!";

$fh->print(<<CONFIG);
[database]
user=
password=
;host=
;port=
;ip_range=
;database=$dbName
dbi=$dbi

[idmapping]
remote_url=ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/idmapping/idmapping.dat.gz
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

[taxonomy]
remote_url=ftp://ftp.ebi.ac.uk/pub/databases/ena/taxonomy/taxonomy.xml.gz

[database-build]
uniprot_url=ftp://ftp.uniprot.org/pub/databases/uniprot/current_release
interpro_url=ftp://ftp.ebi.ac.uk/pub/databases/interpro/current
pfam_info_url=ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.clans.tsv.gz
clan_info_url=ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-C.gz

CONFIG
;

close $fh;



