#!/bin/bash -l

##########
## Using BWA mem to estimate CRM2 abundance across hapmap2 inbred lines.
##########

#SBATCH -D /group/jrigrp/bigd_fastq/

#SBATCH -J CRM2_Hapmap2_abun

#SBATCH -p serial

#SBATCH -c 1

#SBATCH -e /home/sbhadral/Projects/slurm_log/Hapmap_CRM2_abun/%j.err

#SBATCH -o /home/sbhadral/Projects/slurm_log/Hapmap_CRM2_abun/%j.out

## -e (errexit) Exit immediately if a simple command exits with a non-zero status
set -e

## -u (nounset) Treat unset variables as an error when performing parameter expansion.
set -u

############# command line input for running this script.

#### Indexing the reference TE.

##bwa index -p UniqueCRM2 UniqueCRM2.fasta

## cd /group/jrigrp/bigd_fastq/

#### Loop through all files while executing the script across all files in parallel.

## for file in $(ls *_1.txt.bz2) ; do sbatch /home/sbhadral/Projects/scripts/CRM2_BWA_abun.sh "$file" ; done

############# Script start. 


module load bwa/0.7.5a
	
file1=$1
file2=$(echo $file1 | sed -e 's/_[0-9]_1/_[0-9]_2/g')
file3=$(echo $file1 | sed -e 's/_[1-2]\.txt.bz2//')


bwa mem /home/sbhadral/Projects/CRM2_abun/UniqueCRM2 <(bzip2 -dc $file1 )  <(bzip2 -dc $file2 ) | 
		
		samtools view -Sb - > /home/sbhadral/Projects/check.$file3.bam


	echo $file3 $( samtools flagstat /home/sbhadral/Projects/check.$file3.bam 	| 
		
		sed -n -e 1p -e 3p 		| 
		
			cut -d " " -f 1 	| 
		
					paste -d ' ' - -  | 
					
							sed -n '$p')					


rm home/sbhadral/Projects/check.$file3.bam

#############

## command line input for isolating and concatenating outputs into a single file containing a tab delimited table.

## for file in $(ls *.out) ; do less "$file" | sed -n '$p' > Hapmap2_abun/reads.$file.out ; done

## sed '/serial/d' reads.out > Hapmap2_CRM2_abun.stat

##########
##END
##########\n