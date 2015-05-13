#!/bin/bash -l
#SBATCH -D /home/sbhadral/Projects/slurm_log/alignments
#SBATCH -J Jiao_bam_sam
#SBATCH -o /home/sbhadral/Projects/slurm_log/outs/%A_%a.out
#SBATCH -p serial
#SBATCH --ntasks=1
#SBATCH -e /home/sbhadral/Projects/slurm_log/errors/%A_%a.err
##SBATCH --mail-type=END # options are END, NONE, BEGIN, FAIL, ALL
##SBATCH --mail-user=sbhadralobo@ucdavis.edu 

#SBATCH --array=1-2


module load bwa/0.7.5a

#FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p data/hm2.files ).bam
FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p /home/sbhadral/Projects/slurm_log/alignments/missing_files3.txt)

echo $FILE
#gets total reads and mapped reads from bamfile

samtools view -h /home/sbhadral/Projects/slurm_log/alignments/$FILE.bam -o /home/sbhadral/Projects/slurm_log/alignments/$FILE.sam