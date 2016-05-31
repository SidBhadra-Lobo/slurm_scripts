#!/bin/bash -l

#### checksums on og_fastqs
######
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/og_fastqs
#SBATCH -J cksum
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/cksum_ogfqs_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/cksum_ogfqs_%A_%a.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
##SBATCH --array=1-18
#SBATCH --array=2


set -e
set -u


FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p /home/sbhadral/Projects/Rice_project/og_fastqs/cksum_list.txt);

for file in "$FILE";

do 

cksum "$file" >> /home/sbhadral/Projects/Rice_project/og_fastqs/cksum_stats.txt;

echo "$file" | paste -d " " >> /home/sbhadral/Projects/Rice_project/og_fastqs/cksum_stats.txt;

done;


