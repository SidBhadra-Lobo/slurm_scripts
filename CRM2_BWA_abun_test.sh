##########
## Using BWA mem to estimate CRM2 abundance for a single hapmap2 lane. (This is a test script, hence only aligning a single lane).
##########

#!/bin/bash

## -D sets your project directory.
#SBATCH -D /group/jrigrp/bigd_fastq/

## -o sets where standard output (from batch script) goes.
## %j places the job number in the name of the file.
#SBATCH -o /home/sbhadral/Projects/slurm_log/CRM2_abun_stdout_%j.txt 

## -e sets where standard error (from batch script) goes.
#SBATCH -e /home/sbhadral/Projects/slurm_log/CRM2_abun_stderr_%j.txt

## -J sets the job name.
#SBATCH -J CRM2_abun

## Send email notifications.
#SBATCH --mail-type=ALL # other options are END, NONE, BEGIN, FAIL
#SBATCH --mail-user=sbhadralobo@ucdavis.edu 

## Specify the partition.
#SBATCH --partition=hi # other options are low, med, bigmem, serial.

## Specify the number of requested nodes.
#SBATCH --nodes=1

## Specify the number of tasks per node,
## Cannot exceed the number of processor cores on any of the requested nodes.
#SBATCH --ntasks-per-node=1

## -e (errexit) Exit immediately if a simple command exits with a non-zero status
set -e

## -u (nounset) Treat unset variables as an error when performing parameter expansion.
set -u

########## script starts here 
########## "!!" begins comments for things I'm not sure about.

## Copy files of interest into my directory.

cp B73_FC42G13AAXX_1_*.txt.bz2 /home/sbhadral/Projects/CRM2_abun/

## Change to CRM2_abun directory.

cd /home/sbhadral/Projects/CRM2_abun/

## Indexing the reference TE.

/Projects/bwa-0.7.5a/bwa index -p UniqueCRM2 UniqueCRM2.fasta

## Take a test paired end file and use BWA mem to align both mates against the reference. 
## NOTE: samtools -bS forces bam format output, so no need to label the output file as .bam (check.bam).

/Projects/bwa-0.7.5a/bwa mem UniqueCRM2 <(bzip2 -dc B73_FC42G13AAXX_1_1.txt.bz2)  <(bzip2 -dc B73_FC42G13AAXX_1_2.txt.bz2) | /Projects/samtools-0.1.19/samtools -bS - check

## From the check.bam, run flagstat for alignment statistics.
## From the outputs, isolate the lines that show total reads per lane (sed -n -e1p) and total reads mapped per lane (-e 3p).
## Save these two numbers to a file (reads.stat).

Projects/samtools-0.1.19/samtools flagstat check.bam  | sed -n -e 1p -e 3p | cut -d " " -f 1 > reads.stat

## Remove excess files.
rm B73_FC42G13AAXX_1_*.txt.bz2
rm check.bam

##########
END
##########\n