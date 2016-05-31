#!/bin/bash -l

#### rsync og_fastqs to local for SRA upload
######
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/og_fastqs
#SBATCH -J seq_check
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/seq_check_ogfqs.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/seq_check_ogfqs.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
##SBATCH --array=1-9
set -e
set -u

#FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p /home/sbhadral/Projects/Rice_project/og_fastqs/seq_check.txt)

for file in $(less /home/sbhadral/Projects/Rice_project/og_fastqs/seq_check.txt);

do

	echo "$file" >> /home/sbhadral/Projects/Rice_project/og_fastqs/all_seq_headers.txt;

	echo file name "$file" added;

	zless /home/sbhadral/Projects/Rice_project/og_fastqs/"$file" | grep -B 3 "^>" | head -2 >> /home/sbhadral/Projects/Rice_project/og_fastqs/all_seq_headers.txt;

	echo "$file" zless, grep, head, finished 

done;

