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

#### Since this is a test run, the files of interest will already be in my directory and not in ~/group/

## Load the BWA module. Once the module is loaded, it is already in your path. So just 'bwa mem' will suffice.

module load /share/apps/modulefiles/hpc/bwa/0.7.5a

## Indexing the reference TE.

bwa index -p CRM2_abun/UniqueCRM2 /home/sbhadral/Projects/CRM2_abun/UniqueCRM2.fasta

## Take a test paired end file and run BWA mem, convert .sam to .bam, isolate flagstat output lines that show total reads per lane (sed -n -e1p) and total reads mapped per lane (-e 3p). Send to stdout.
## NOTE: samtools is already available in your path, so no need to load it's module.
## samtools view (-S) specifies that the input is in .sam and (-b) sets the output format to .bam

bwa mem CRM2_abun/UniqueCRM2 <(bzip2 -dc CRM2_abun/B73_FC42G13AAXX_1_1.txt.bz2)  <(bzip2 -dc CRM2_abun/B73_FC42G13AAXX_1_2.txt.bz2) | samtools view -Sb - > check.bam

## From the check.bam, run flagstat for alignment statistics.
## From the outputs, isolate the lines that show total reads per lane (sed -n -e1p) and total reads mapped per lane (-e 3p).
## Save these two numbers to a file (reads.stat).

samtools flagstat /home/sbhadral/Projects/check.bam  | sed -n -e 1p -e 3p | cut -d " " -f 1 | /dev/stdout

## Remove excess files.
rm check.bam

##########
##END
##########\n