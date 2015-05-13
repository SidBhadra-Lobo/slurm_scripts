#!/bin/bash -l

##########
## Converting SRA to fastq.
##########

# #SBATCH -D /home/sbhadral/Projects/Rice_project/ref_gens/
# #SBATCH -J fastqdump
# #SBATCH -p serial
# #SBATCH -o /home/sbhadral/Projects/Rice_project/outs/%j.out
# #SBATCH -e /home/sbhadral/Projects/Rice_project/errors/%j.err
# #SBATCH -c 1
# #SBATCH --mail-type=FAIL
# #SBATCH --mail-type=END
# #SBATCH --mail-user=sbhadralobo@ucdavis.edu
# set -e
# set -u
# 
# module load sratoolkit/2.3.2-4
# 
# file1=$( ls /*.sra )
# 
# 
# fastq-dump --split-files --gzip /home/sbhadral/Projects/Rice_project/ref_gens/$file1 --outdir /home/sbhadral/Projects/Rice_project/ref_gens/;

#SBATCH -D /home/sbhadral/Projects/Rice_project/alignments/reseq_japonica_japonica_bams
#SBATCH -J fastqdump
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/fastq-dump_%j.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/fastq-dump_%j.err
#SBATCH -c 1
##SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
##SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u

module load sratoolkit/2.3.2-4

du=$( ls ERS*/*.sra )


fastq-dump --split-files --gzip /home/sbhadral/Projects/alignments/reseq_japonica_japonica_bams/$file1 --outdir /home/sbhadral/Projects/Rice_project/alignments/reseq_japonica_japonica_bams/;
