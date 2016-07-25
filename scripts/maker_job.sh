#!/bin/bash
#PBS -l nodes=1:ppn=2,walltime=96:00:00,mem=16gb
#PBS -N MAKER.Hw -j oe

module load lp_solve
module load maker/2.31.8
module load snap
module load augustus/3.1
module load RepeatMasker
module load ncbi-blast
module load tRNAscan
which augustus

maker 
