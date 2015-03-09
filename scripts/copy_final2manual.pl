#!env perl
use strict;
use warnings;
use Bio::SeqIO;

my $debug = 1;
my $debug_one = 0;
my $force = 0;
my %type2ext = ( 'proteins' => 'aa',
		 'transcripts' => 'CDS',
    );
my $dest = shift || "../private_genomes/download";
my $dir = shift || "genomes";

opendir(DIR, $dir) || die $!;
for my $f ( readdir(DIR) ) {
    next if $f =~ /^\./;
    if( ! -d "$dir/$f" ) {
 	warn("not a dir ($dir/$f)\n");
	next;
    }
    mkdir("$dest/$f") unless -d "$dest/$f";
    opendir(FAM,"$dir/$f") || die $!;
    for my $sp ( readdir(FAM) ) {
	next if $sp =~ /^\./;
	warn("infile read $sp\n");
	next if ( ! -d "$dir/$f/$sp");
	if( -f "$dir/$f/$sp/$sp.fasta" ) {
	    warn("Genome fasta is $sp\n");
	    my $prefix = &make_prefix($sp);
	    next if( -f "$dest/$f/$sp/$sp.assembly.fasta.gz" && ! $force );
	    my $in = Bio::SeqIO->new(-format => 'fasta',
				     -file   => "$dir/$f/$sp/$sp.fasta");
	    
	    open(my $fh => "| gzip -c > $dest/$f/$sp/$sp.assembly.fasta.gz") || die $!;
	    my $out = Bio::SeqIO->new(-format => 'fasta',
				      -fh   => $fh);
	    
	    while( my $s = $in->next_seq ) {
		$s->display_id(sprintf("%s|%s",$prefix,$s->display_id));
		$out->write_seq($s);
	    }
	}
#	warn("sp is $dir/$f/$sp\n") if $debug;

	unless ( -d "$dir/$f/$sp/MAKER") {
	    warn("no MAKER result dir for dir $dir/$f/$sp -expecting-> MAKER");
	    next;
	} 
	mkdir("$dest/$f/$sp") unless -d "$dest/$f/$sp";
	opendir(M,"$dir/$f/$sp/MAKER") || die "$dir/$f/$sp/MAKER $!";	
	for my $file ( readdir(M) ) {
	    if( $file =~ /(\S+)\.all\.functional.gff$/ ) {
		my $stem = $1;
		warn("$stem for $file\n");
		open(GFF, "< $dir/$f/$sp/MAKER/$file") || die "cannot open GFF file: $dir/$f/$sp/MAKER/$file";
		next if( -f "$dest/$f/$sp/$sp.gff3.gz" && ! $force );
		open(OUTGFF, "| gzip -c > $dest/$f/$sp/$sp.gff3.gz") || die "Cannot open $dest/$f/$sp/$sp.gff3";
		while(<GFF>) {
		    last if /^\#FASTA/;
		    if( /^\##gff-version/ ) {
			print OUTGFF $_;
		    }
		    my @row = split(/\t/,$_);			
		    next if @row == 1;

		    if( $row[1] eq 'maker' ) {
			print OUTGFF $_;
		    }
		}
	    } elsif( $file =~ /(\S+)\.all\.maker\.(proteins|transcripts)\.functional\.fasta/ ) {
		my $stem = $1;		
		my $type = $type2ext{$2};
		warn("$stem for $file\n");
		if( ! defined $type ) {
		    die("unknown type $2 in $file");
		}
		my $prefix = &make_prefix($stem);
		next if( -f "$dest/$f/$sp/$sp.$type.fasta.gz" && ! $force );
		my $in = Bio::SeqIO->new(-format => 'fasta',
					 -file   => "$dir/$f/$sp/MAKER/$file");

		open(my $fh => "| gzip -c > $dest/$f/$sp/$sp.$type.fasta.gz") || die $!;
		my $out = Bio::SeqIO->new(-format => 'fasta',
					  -fh   => $fh);

		while( my $s = $in->next_seq ) {
		    $s->display_id(sprintf("%s|%s",$prefix,$s->display_id));
		    $out->write_seq($s);
		}
	    }
	}
    }
}

sub make_prefix {
    my $stem = shift @_;
    $stem =~ s/\.([_.])/$1/g;
    my @parts = split(/\./,$stem);
    my ($genus,$species) = split(/_/,$parts[0]);
    my $pref;
    if( @parts > 1 ) {
        $pref = $parts[1];
    } else {
        $pref = substr($genus,0,1).substr($species,0,3);
    }
    $pref;
}
