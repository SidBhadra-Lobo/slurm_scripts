#!/bin/bash -l

##########
## Using BWA mem to estimate CRM2 abundance for a single hapmap2 lane. (This is a test script, hence only aligning a single lane).
##########


file1=$1
file2=$(echo $file1 | sed -e 's/_1_1/_1_2/g')
file3=$(echo $file1 | sed -e 's/_[1-2]\.txt.bz2//')
	
cd /Users/Sid/Projects/
	
#### Since this is a test run, the files of interest will already be in my directory and not in ~/group/


## Indexing the reference TE.

./bwa-0.7.5a/bwa index -p UniqueCRM2 UniqueCRM2.fasta

## Take a test paired end file and run BWA mem, convert .sam to .bam, isolate flagstat output lines that show total reads per lane (sed -n -e1p) and total reads mapped per lane (-e 3p). Send to stdout.
## NOTE: samtools is already available in your path, so no need to load it's module.
## samtools view (-S) specifies that the input is in .sam and (-b) sets the output format to .bam

./bwa-0.7.5a/bwa mem UniqueCRM2 <(bzip2 -dc $file1 )  <(bzip2 -dc $file2 ) | ./samtools-0.1.19/samtools view -Sb - > check.bam

## From the check.bam, run Samtools flagstat for alignment statistics, pipe to stdout.
## From the outputs, isolate the lines that show total reads per lane (sed -n -e1p) and total reads mapped per lane (-e 3p).
## Separate out first tab delimited column, now only 2 rows.
## Take second value, move to column 2 in row 1. 
## Add a third column with the corresponding lane.
## Concatenate all lane alignment outputs into a single table.
## Save to a single file in Projects/

./samtools-0.1.19/samtools flagstat check.bam 	| 
		sed -n -e 1p -e 3p 		| 
			cut -d " " -f 1 	| 
					paste -d ' ' - - > ${file3}.reads 	;

							echo ${file3}  	| 
									paste -d ' ' - ${file3}.reads > ${file3}.abun
									
## Remove excess files.
rm check.bam
rm ${file3}.reads

##########
##END
##########\n
