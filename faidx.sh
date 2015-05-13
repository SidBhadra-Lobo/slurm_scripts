#!/bin/bash -l

#### Use samtools index reference fasta.
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/ref_gens/
#SBATCH -J faidx
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/faidx_%J.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/faidx_%J.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u

samtools faidx Oryza_sativa.IRGSP-1.0.23.dna.genome.fa.gz;