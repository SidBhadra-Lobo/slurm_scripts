#!/bin/bash -l

##########
## Using BWA mem to estimate CRM2 abundance for a single hapmap2 lane. (This is a test script, hence only aligning a single lane).
##########

## -D sets directory
#SBATCH -D /home/sbhadral/Projects/
## -J sets the job name

#SBATCH -J CRM2_abun
## -p sets the partition to run the job on

#SBATCH -p serial
## -o sets the destination for the stdout. %j includes the job number in the name.
#SBATCH -o /home/sbhadral/Projects/slurm_log/CRM2_abun_stdout_%j.txt 

## -e sets the destination for the stderr.
#SBATCH -e /home/sbhadral/Projects/slurm_log/CRM2_abun_stderr_%j.txt

## -c sets number of cpus required per task
#SBATCH -c 1

########## script starts here 
########## "!!" begins comments for things I'm not sure about.

## Copy files of interest into my directory.

##cp B73_FC42G13AAXX_1_*.txt.bz2 /home/sbhadral/Projects/CRM2_abun/

## Change to CRM2_abun directory.

##cd /home/sbhadral/Projects/CRM2_abun/
##########

#### Since this is a test run, the files of interest will already be in my directory and not in ~/group/

## Load the BWA module.

module load /share/apps/modulefiles/hpc/bwa/0.7.5a

## Change to my directory.

##cd /home/sbhadral/Projects/

## Indexing the reference TE.

bwa index -p CRM2_abun/UniqueCRM2 /home/sbhadral/Projects/CRM2_abun/UniqueCRM2.fasta

## Take a test paired end file and use BWA mem to align both mates against the reference. 
## NOTE: samtools -bS forces bam format output, so no need to label the output file as .bam (check.bam).

bwa mem CRM2_abun/UniqueCRM2 <(bzip2 -dc CRM2_abun/B73_FC42G13AAXX_1_1.txt.bz2)  <(bzip2 -dc CRM2_abun/B73_FC42G13AAXX_1_2.txt.bz2) | samtools view -Sb - > check.bam

## From the check.bam, run flagstat for alignment statistics.
## From the outputs, isolate the lines that show total reads per lane (sed -n -e1p) and total reads mapped per lane (-e 3p).
## Save these two numbers to a file (reads.stat).

samtools flagstat /home/sbhadral/Projects/check.bam  | sed -n -e 1p -e 3p | cut -d " " -f 1 > reads.stat

## Remove excess files.
## Being a test, I will keep the test files for further testing.
## rm B73_FC42G13AAXX_1_*.txt.bz2
rm check.bam

##########
##END
##########\n