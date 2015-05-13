#!/bin/bash -l

#### Showing flagstats of bams using samtools.

#SBATCH -D /group/jrigrp5/ECL298/students
#SBATCH -J flagstat_students_reseq_indica
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/flagstats_students_reseq_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/flagstats_students_reseq_%a.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u
#SBATCH --array=1-12

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p /home/sbhadral/Projects/Rice_project/alignments/reseq_indica_bams/flagstats/flagstat_students_reseq_list.txt )

##samtools flagstat "$FILE" | sed -n -e 1p -e 3p  >> /home/sbhadral/Projects/Rice_project/alignments/flagstats/flagstat_merid_indica.txt

samtools flagstat "$FILE" > /home/sbhadral/Projects/Rice_project/alignments/reseq_indica_bams/flagstats/flagstat.students."$FILE"