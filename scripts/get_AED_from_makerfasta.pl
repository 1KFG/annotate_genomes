
use strict;
use warnings;

# either pass file in on cmdline or 
# via stdin

# perl get_AED_from_makerfasta.pl < proteins.fasta > AED.dat
# or
# perl get_AED_from_makerfasta.pl proteins.fasta > AED.dat
# or
# zcat proteins.fasta.gz | perl get_AED_from_makerfasta.pl > AED.dat

print join("\t", qw(GENE AED eAED)),"\n";
while ( <> ) {
    next unless (/^>(\S+).+AED:(\S+).+eAED:(\S+)/ );
    print join("\t", $1,$2,$3),"\n";
}
