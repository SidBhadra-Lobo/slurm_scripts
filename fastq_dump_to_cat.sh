#!/bin/bash -l

##########
## Converting SRA to fastq.
##########

#SBATCH -D /home/sbhadral/Projects/Rice_project/reseq_japonica
#SBATCH -J reseq_fastqdump_cat
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/%A_%a.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u

###### command line input. for file in $(ls *.sra); do sbatch /home/sbhadral/Projects/scripts/fastq_dump_to_cat.sh "$file" ; done

module load sratoolkit/2.3.2-4

file1=$1


fastq-dump --split-files --gzip /home/sbhadral/Projects/Rice_project/reseq_japonica/$1 --outdir /home/sbhadral/Projects/Rice_project/reseq_japonica/;
