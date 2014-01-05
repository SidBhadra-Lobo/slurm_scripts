#!/bin/bash -l

##########
## Using BWA mem to estimate CRM2 abundance for a single hapmap2 lane. (This is a test script, hence only aligning a single lane).
##########

#!/bin/bash
#SBATCH -D /home/sbhadral/Projects/
#SBATCH -J CRM2_abun
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/slurm_log/CRM2_abun_stdout_%j.txt 
#SBATCH -e /home/sbhadral/Projects/slurm_log/CRM2_abun_stderr_%j.txt
#SBATCH -c 1

########## script starts here 
########## "!!" begins comments for things I'm not sure about.

## Copy files of interest into my directory.

##cp B73_FC42G13AAXX_1_*.txt.bz2 /home/sbhadral/Projects/CRM2_abun/

## Change to CRM2_abun directory.

##cd /home/sbhadral/Projects/CRM2_abun/
##########

#### Since this is a test run, the files of interest will already be in my directory and not in ~/group/

## Indexing the reference TE.

/home/sbhadral/Projects/bwa-0.7.5a/bwa index -p UniqueCRM2 UniqueCRM2.fasta

## Take a test paired end file and use BWA mem to align both mates against the reference. 
## NOTE: samtools -bS forces bam format output, so no need to label the output file as .bam (check.bam).

/home/sbhadral/Projects/bwa-0.7.5a/bwa mem UniqueCRM2 <(bzip2 -dc CRM2_abun/B73_FC42G13AAXX_1_1.txt.bz2)  <(bzip2 -dc CRM2_abun/B73_FC42G13AAXX_1_2.txt.bz2) | /home/sbhadral/Projects/samtools-0.1.19/samtools -bS - check

## From the check.bam, run flagstat for alignment statistics.
## From the outputs, isolate the lines that show total reads per lane (sed -n -e1p) and total reads mapped per lane (-e 3p).
## Save these two numbers to a file (reads.stat).

/home/sbhadral/Projects/samtools-0.1.19/samtools flagstat check.bam  | sed -n -e 1p -e 3p | cut -d " " -f 1 > reads.stat

## Remove excess files.
## Being a test, I will keep the test files for further testing.
## rm B73_FC42G13AAXX_1_*.txt.bz2
rm check.bam

##########
##END
##########\n