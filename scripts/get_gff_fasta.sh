#PBS -l nodes=1:ppn=1 -j oe
module load maker

fasta_merge -d */*"_master_datastore_index.log"
gff3_merge -d */*"_master_datastore_index.log"
