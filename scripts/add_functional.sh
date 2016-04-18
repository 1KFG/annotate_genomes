#PBS -j oe -N addfunctional -l walltime=12:00:00 -l nodes=1:ppn=1
module load maker
DB=/bigdata/stajichlab/shared/db/uniprot/uniprot_sprot.fasta
D=`dirname \`pwd\``
SPECIES=`basename $D`
maker_functional_fasta $DB $SPECIES.all.maker.swissprot.BLASTP $SPECIES.all.maker.transcripts.fasta > $SPECIES.all.maker.transcripts.functional.fasta
maker_functional_fasta $DB $SPECIES.all.maker.swissprot.BLASTP $SPECIES.all.maker.proteins.fasta > $SPECIES.all.maker.proteins.functional.fasta

maker_functional_gff $DB $SPECIES.all.maker.swissprot.BLASTP $SPECIES.all.gff > $SPECIES.all.functional.gff
