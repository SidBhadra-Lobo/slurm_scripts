#!/bin/bash -l
#SBATCH -D /home/sbhadral/Projects/slurm_log/alignments
#SBATCH -J Jiao_readcount
#SBATCH -o /home/sbhadral/Projects/slurm_log/outs/%A_%a.out
#SBATCH -p serial
#SBATCH --ntasks=1
#SBATCH -e /home/sbhadral/Projects/slurm_log/errors/%A_%a.err
##SBATCH --mail-type=END # options are END, NONE, BEGIN, FAIL, ALL
##SBATCH --mail-user=sbhadralobo@ucdavis.edu 

#SBATCH --array=1-360


module load bwa/0.7.5a

#FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p data/hm2.files ).bam
FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p /home/sbhadral/Projects/slurm_log/alignments/SraAccList.txt)

echo $FILE
#gets total reads and mapped reads from bamfile
#samtools view alignments/$FILE | tee >( cut -f 1 | sort -n | uniq | wc -l >results/$FILE.total ) | cut -f 1,3 | grep -v "*" | cut -f 1 | sort -n | uniq | wc -l > results/$FILE.mapped;

#samtools view -h /home/sbhadral/Projects/slurm_log/alignments/$FILE.bam -o /home/sbhadral/Projects/slurm_log/alignments/$FILE.sam 

perl /home/sbhadral/Projects/scripts/parsesam.pl <( samtools view -S /home/sbhadral/Projects/slurm_log/alignments/$FILE.sam | sort -T /home/sbhadral/Projects/slurm_log/sort_tmp/ -n -k 1 ) /home/sbhadral/Projects/slurm_log/results/abundance."$FILE".txt
