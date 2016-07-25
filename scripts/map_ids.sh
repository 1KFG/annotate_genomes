#PBS -j oe
module load maker

D=`dirname \`pwd\``
SPECIES=`basename $D`
echo $SPECIES
map_fasta_ids $SPECIES.mapids $SPECIES.all.maker.proteins.fasta
map_fasta_ids $SPECIES.mapids $SPECIES.all.maker.transcripts.fasta
map_gff_ids $SPECIES.mapids $SPECIES.all.gff 
