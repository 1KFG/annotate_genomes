#PBS -j oe
module load maker/2.31.6

D=`dirname \`pwd\``
SPECIES=`basename $D`

map_fasta_ids $SPECIES.mapids $SPECIES.all.maker.proteins.fasta
map_fasta_ids $SPECIES.mapids $SPECIES.all.maker.transcripts.fasta
map_gff_ids $SPECIES.mapids $SPECIES.all.gff 
