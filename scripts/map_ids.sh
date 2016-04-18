#PBS -j oe
module unload perl/5.22.0
module load perl/5.20.2
module load maker

D=`dirname \`pwd\``
SPECIES=`basename $D`
echo $SPECIES
map_fasta_ids $SPECIES.mapids $SPECIES.all.maker.proteins.fasta
map_fasta_ids $SPECIES.mapids $SPECIES.all.maker.transcripts.fasta
map_gff_ids $SPECIES.mapids $SPECIES.all.gff 
