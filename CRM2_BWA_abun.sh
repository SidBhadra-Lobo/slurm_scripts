#!/bin/bash

##########
## Using BWA mem to estimate CRM2 abundance across hapmap2 inbred lines.
##########


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

## Unzip all compressed lanes, (there was a pesky README.txt.bz2 that I circumvented).
##for FILE in *[1-2].txt.bz2 
##do
##	cp $FILE /home/sbhadral/Projects/CRM2_abun/
##done

## A select loop for running the entire process on one file at a time.
select FILE in *[1-2].txt.bz2
do
	case $FILE in
		

## Move all unzipped files to /home/sbhadral/Projects/CRM2_abun directory. 

for FILE in *.fastq
do
	mv $FILE /home/sbhadral/Projects/CRM2_abun/
done

## Change to CRM2_abun directory.

cd /home/sbhadral/Projects/CRM2_abun/

## Indexing the reference TE.

Projects/bwa-0.7.5a/bwa index -p UniqueCRM2 UniqueCRM2.fasta

## Goes through all hapmap2 lanes (*.fastq files) and aligns against reference index of UniqueCRM2.
## !! So these are paired end reads, I'm considering converting them to single ended reads because from my experience, the PE abundance was being underestimated.

for FILE in *.fastq
do
	Projects/bwa-0.7.5a/bwa mem UniqueCRM2 $FILE_1 $FILE_2 > $FILE.sam		## !! Not sure about using $FILE_1 $FILE_2 to represent each mate per paired end.
done

## Takes the alignment outputs (*.fastq.sam) and converts them directly to sorted .bam using samtools.

for FILE in *.fastq.sam
do
	Projects/samtools-0.1.19/samtools view -bS $FILE | ./samtools-0.1.19/samtools sort - $FILE.sorted ## sort output already set to .bam
done

## Creates an index file for each sorted .bam file.
## !! Not sure if this is necessary 

for FILE in *.fastq.sam.sorted.bam
do
	Projects/samtools-0.1.19/samtools index $FILE $FILE.bai
done

## From the sorted .bam, run flagstat for alignment statistics.
## From the outputs, isolate the lines that show total reads per lane (sed -n -e1p) and total reads mapped per lane (-e 3p).
## Extract only those two numbers (first delimited column), take each line and save to separate files. (1p > total_reads, 2p > mapped_reads) 

for FILE in *.fastq.sam.sorted.bam
do
	Projects/samtools-0.1.19/samtools flagstat $FILE  | sed -n -e 1p -e 3p | cut -d " " -f 1 | sed -n 1p > total_reads.stat
done

for FILE in *.fastq.sam.sorted.bam
do
	Projects/samtools-0.1.19/samtools flagstat $FILE  | sed -n -e 1p -e 3p | cut -d " " -f 1 | sed -n 2p > mapped_reads.stat
done

## Combine all outputs into one file. Should be organized/extracted as reads total reads per lane (odd # lines, 2n + 1) and reads mapped per lane (even #, 2n)
##for FILE in *.fastq.sam.sorted.bam.stat
##do
##	cat $FILE > $FILE.combined
##done

## Delete unnecessary files.

for FILE in *.fastq
rm $FILE
done

for FILE in *.fastq.sam
rm $FILE
done

for FILE in *.fastq.sam.sorted.bam
rm $FILE
done

for FILE in *.fastq.sam.sorted.bam.bai
rm $FILE
done


##########
## END?
##########\n