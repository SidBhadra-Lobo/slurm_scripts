#!/bin/bash -l

##########
## Using BWA mem to estimate CRM2 abundance for a single hapmap2 lane. (This is a test script, hence only aligning a single lane).
##########

## -D sets directory
#SBATCH -D /home/sbhadral/Projects/CRM2_abun/

## -J sets the job name
##SBATCH -J CRM2_abun

## -p sets the partition to run the job on
#SBATCH -p hi

## -o sets the destination for the stdout. %j sets the job name.
#SBATCH -o /home/sbhadral/Projects/slurm_log/CRM2_out_%j.txt

## -e sets the destination for the stderr.
#SBATCH -e /home/sbhadral/Projects/slurm_log/CRM2_stderr_%j.txt

## -c sets number of cpus required per task
#SBATCH -c 1

## -e (errexit) Exit immediately if a simple command exits with a non-zero status
set -e

## -u (nounset) Treat unset variables as an error when performing parameter expansion.
set -u

## Loop through all files while executing the script across all files in parallel.


## command line input for running this script.


## for i in "$(ls *[1-2].txt.bz2)" ; do sbatch /home/sbhadral/Projects/scripts/CRM2_BWA_abun_test.sh $i ; done

	
file=$1
file2=$(echo $file | sed -e 's/_1_1/_1_2/g')
	
	
#### Since this is a test run, the files of interest will already be in my directory and not in ~/group/

## Load the BWA module. Once the module is loaded, it is already in your path. So just 'bwa mem' will suffice.

module load /share/apps/modulefiles/hpc/bwa/0.7.5a


## Indexing the reference TE.

bwa index -p UniqueCRM2 UniqueCRM2.fasta

## Take a test paired end file and run BWA mem, convert .sam to .bam, isolate flagstat output lines that show total reads per lane (sed -n -e1p) and total reads mapped per lane (-e 3p). Send to stdout.
## NOTE: samtools is already available in your path, so no need to load it's module.
## samtools view (-S) specifies that the input is in .sam and (-b) sets the output format to .bam

bwa mem UniqueCRM2 <(bzip2 -dc $file )  <(bzip2 -dc $file2 ) | samtools view -Sb - > check.bam

## From the check.bam, run Samtools flagstat for alignment statistics, pipe to stdout.
## From the outputs, isolate the lines that show total reads per lane (sed -n -e1p) and total reads mapped per lane (-e 3p).
## Separate out first tab delimited column, now only 2 rows.
## Take second value, move to column 2 in row 1. 
## Add a third column with the corresponding lane.
## Concatenate all lane alignment outputs into a single table.
## Save to a single file in Projects/

samtools flagstat check.bam 	| 
		sed -n -e 1p -e 3p 	| 
			cut -d " " -f 1 	| 
					awk '{printf "%s%s",$0,(NR%2?FS:RS)}'	| 
							awk '{print $0, "${file:0:((-10))}"}'	| 
									cat - >> /home/sbhadral/Projects/reads.stat 

## Remove excess files.
rm check.bam



##########
##END
##########\n