#!/bin/bash -l

##########
## Using BWA mem to estimate CRM2 abundance across hapmap2 inbred lines.
##########

## -D sets project directory.
#SBATCH -D /group/jrigrp/bigd_fastq/

## -J sets the job name.
#SBATCH -J CRM2_abun

## -p Specifies the partition.
#SBATCH -p serial # some options are low, med, hi, bigmem, serial.

## -c Specify the number of cpus per task.
#SBATCH -c 2

## -e  sets the destination for the stderr.
## %j places the job number as the filename.
#SBATCH -e /home/sbhadral/Projects/slurm_log/%j.err

## -o sets the destination for the stdout.
#SBATCH -o /home/sbhadral/Projects/slurm_log/%j.out

#### Send email notifications. 
#SBATCH --mail-type=END # options are END, NONE, BEGIN, FAIL, ALL
#SBATCH --mail-user=sbhadralobo@ucdavis.edu 

## -e (errexit) Exit immediately if a simple command exits with a non-zero status
set -e

## -u (nounset) Treat unset variables as an error when performing parameter expansion.
set -u

############# command line input for running this script.

#### Indexing the reference TE.

##bwa index -p UniqueCRM2 UniqueCRM2.fasta

## cd /group/jrigrp/bigd_fastq/

#### Loop through all files while executing the script across all files in parallel.

## for file in $(ls *1.txt.bz2) ; do sbatch /home/sbhadral/Projects/scripts/CRM2_BWA_abun_test.sh $file ; done

############# Script start. 

#### Load the BWA module. Once the module is loaded, it is already in your path. So just 'bwa mem' will suffice.

module load bwa/0.7.5a
	
file1=$1
file2=$(echo $file1 | sed -e 's/_1_1/_1_2/g')
file3=$(echo $file1 | sed -e 's/_[1-2]\.txt.bz2//')


## Take a paired end file and run BWA mem, convert .sam to .bam, isolate flagstat output lines that show total reads per lane (sed -n -e1p) and total reads mapped per lane (-e 3p). Send to stdout.
## NOTE: samtools is already available in your path, so no need to load it's module.
## samtools view (-S) specifies that the input is in .sam and (-b) sets the output format to .bam

bwa mem /home/sbhadral/Projects/CRM2_abun/UniqueCRM2 <(bzip2 -dc $file1 )  <(bzip2 -dc $file2 ) | samtools view -Sb - > /home/sbhadral/Projects/check.%j.bam

## Add corresponding lane name to column 1 row 1.
## From the check.%j.bam, run Samtools flagstat for alignment statistics, pipe to stdout.
## From the outputs, isolate the lines that show total reads per lane (sed -n -e1p) and total reads mapped per lane (-e 3p).
## Separate out first tab delimited column, now only 2 rows.
## Take column 1 row 2 value, move to column 3 in row 1. 

echo $file3 $( samtools flagstat /home/sbhadral/Projects/check.%j.bam 	| 
		sed -n -e 1p -e 3p 		| 
			cut -d " " -f 1 	| 
					paste -d ' ' - -  )					



		
			
## Remove excess files.
rm check.%j.bam






##########
##END
##########\n