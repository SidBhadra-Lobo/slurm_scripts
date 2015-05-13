#!/bin/bash -l

#### Use samtools to sort and index bam files.
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/alignments/og_indica_bams
#SBATCH -J sort_index
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/sort_index_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/sort_index_%A_%a.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u
#SBATCH --array=1-6

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p sort_index_list.txt )

samtools sort "$FILE" "$FILE".sorted

samtools index "$FILE".sorted.bam

