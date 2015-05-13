#!/bin/bash -l

##########
## Using BWA mem to estimate Gene abundance from Zea_mays.AGPv3.22.cdna.all.fa across Jiao lines.
##########

#SBATCH -D /group/jrigrp/Share/Jiao_SRA_fastq

#SBATCH -J cDNA_fix

#SBATCH -p bigmem

#SBATCH --ntasks=2

#SBATCH -e /home/sbhadral/Projects/slurm_log/errors/%A_%a.err

#SBATCH -o /home/sbhadral/Projects/slurm_log/outs/%A_%a.out  #might be the cause of seeing squeue in all the previous outputs, if it is the cause... I'm glad I finally found it.


#### Set up Array size as needed, in this case 1-360 .fastq.gz files.

#SBATCH --array=1-360






############# command line input for running this script.

#### Indexing the reference cDNA.

## bwa index -p cDNA_all Zea_mays.AGPv3.22.cdna.all.fa

## cd /group/jrigrp/Share/Jiao_SRA_fastq


############# Script start. 


module load bwa/0.7.5a

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p /home/sbhadral/Projects/slurm_log/alignments/SraAccList.txt)
	
	bwa mem -t 2 /home/sbhadral/Projects/cDNA_abun/cDNA_all /group/jrigrp/Share/Jiao_SRA_fastq/"$FILE"_1.fastq.gz 
		
		| samtools view -Su - > /home/sbhadral/Projects/slurm_log/alignments/$FILE.bam
	

##########
##END
##########\n