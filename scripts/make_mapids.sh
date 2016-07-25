#PBS -j oe
module load maker
INFILE=$1
D=`dirname \`pwd\``
SPECIES=`basename $D`
echo $SPECIES
PREF=`echo $SPECIES | perl -p -e 'my @n = split('_',$_); $_ = uc substr($n[0],0,1) . substr($n[1],0,3). "_"'`
echo $PREF
if [ ! $INFILE ]; then
INFILE=$SPECIES.all.gff
fi
maker_map_ids  --prefix $PREF --iterate 0 --justify 5 $INFILE > $SPECIES.mapids
