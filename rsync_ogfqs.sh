#!/bin/bash -l

#### rsync og_fastqs to local for SRA upload
######
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/og_fastqs
#SBATCH -J rsync
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/rsync_ogfqs_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/rsync_ogfqs_%A_%a.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
#SBATCH --array=3-4
##SBATCH --array=5-18
set -e
set -u

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p /home/sbhadral/Projects/Rice_project/og_fastqs/cksum_list.txt);

for file in "$FILE";

do 

rsync -avzP /home/sbhadral/Projects/Rice_project/og_fastqs/"$file" Sid@172.17.104.83:/Users/Sid/Projects/Rice_Project/og_fastqs/;

done;