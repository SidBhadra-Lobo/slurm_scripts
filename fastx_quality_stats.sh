#!/bin/bash -l

#### fastx quality chart
###### og276, maybe check all of them?
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/og_fastqs
#SBATCH -J fastx_qual
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/gunzip_fastx_qual_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/gunzip_fastx_qual_%A_%a.err
#SBATCH -c 16
##SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
##SBATCH --mail-user=sbhadralobo@ucdavis.edu
##SBATCH --array=2-18
#SBATCH --array=1-3
set -e
set -u

#module load FASTX-Toolkit/0.0.13.2-goolf-1.4.10

module load perlnew fastx

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p recheck_list.txt )

# Initialize a list to run loop through.
for file in "$FILE";

do

echo "$file"
## Replace file extensions accordingly for ease in processing.
#file2=$(echo "$file1" | sed -e 's/_1\.fastq.gz/_2.fastq.gz/g')
#file3=$(echo "$file1" | sed -e 's/_1\.fastq.gz//g')

#fastx_quality_stats -Q 33 -i <( gunzip -dkc "$file" ) -o qual_stats/qual_stats."$file";

fastx_quality_stats -Q33 -i "$file" -o qual_stats/qual_stats."$file";

done;