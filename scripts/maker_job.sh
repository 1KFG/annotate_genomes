#!/bin/bash
#PBS -l nodes=1:ppn=2,walltime=96:00:00,mem=4gb -q batch
#PBS -N MAKER -j oe

module load lp_solve
module unload perl
module load maker/2.31.8
module load RepeatMasker
module load ncbi-blast

maker 
