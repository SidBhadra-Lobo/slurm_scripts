#!/bin/bash -l

#### Use samtools view to see unmapped reads.
########

#SBATCH -D /group/jrigrp5/ECL298/alignments/reseq_indica_bams/Sorted
#SBATCH -J sort_unmapped
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/%A_%a.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u

samtools view -c -F 4 ERS467753.sorted.bam > sort_mapped.txt 

samtools view -c -F 4 /group/jrigrp5/ECL298/alignments/reseq_indica_bams/check.ERS467753.bam > presort_mapped.txt