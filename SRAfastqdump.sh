#!/bin/bash -l

##########
## Converting SRA to fastq
##########

#SBATCH -D /group/jrigrp/Share/Jiao_SRA_fastq

#SBATCH -J Jiao_fastqdump

#SBATCH -p serial

#SBATCH -c 1

#SBATCH -e /home/sbhadral/Projects/slurm_log/errors/%j.err

#SBATCH -o /home/sbhadral/Projects/slurm_log/outs/%j.out  #might be the cause of seeing squeue in all the previous outputs, if it is the cause... I'm glad I finally found it.

## -e (errexit) Exit immediately if a simple command exits with a non-zero status
set -e

## -u (nounset) Treat unset variables as an error when performing parameter expansion.
set -u

###### command line input. for file in $(ls *.sra); do sbatch /home/sbhadral/Projects/scripts/SRAfastqdump.sh "$file" ; done

module load sratoolkit/2.3.2-4

file1=$1

###	/nas-9-0BKUP/apps/sratoolkit-2.3.2-4/tools/sra-dump/fastq-dump --split-files --gzip $file1 --outdir /group/jrigrp/Share/Jiao_SRA_fastq/



fastq-dump --split-files --gzip /group/jrigrp/Share/Jiao_SRA_fastq/$1 --outdir /group/jrigrp/Share/Jiao_SRA_fastq/;

