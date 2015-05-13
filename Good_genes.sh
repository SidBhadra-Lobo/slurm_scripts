#!/bin/bash -l

##########
## Converting SRA to fastq
##########

#SBATCH -D /home/sbhadral/Projects/slurm_log/results/

#SBATCH -J Good_genes

#SBATCH -p serial

#SBATCH --ntasks=1

#SBATCH -e /home/sbhadral/Projects/slurm_log/errors/slurm-%A_%a.err

#SBATCH -o /home/sbhadral/Projects/slurm_log/outs/slurm-%A_%a.out  #might be the cause of seeing squeue in all the previous outputs, if it is the cause... I'm glad I finally found it.

#SBATCH --array=1

## -e (errexit) Exit immediately if a simple command exits with a non-zero status
set -e

## -u (nounset) Treat unset variables as an error when performing parameter expansion.
set -u

##SBATCH --mail-type=END # options are END, NONE, BEGIN, FAIL, ALL
##SBATCH --mail-user=sbhadralobo@ucdavis.edu 

########################
###### Command line input. 
### for file in $(ls *.bam); do sbatch /home/sbhadral/Projects/scripts/Good_genes.sh "$file" ; done
##### Test sample, with 2 lines SRR801200 and SRR801201. 
### for file in $(ls *.SRR801*.bam); do sbatch /home/sbhadral/Projects/scripts/Good_genes.sh "$file" ; done

########## Script Start
##### Courtesy of Jeff, many thanks.

## First we run through each file, get the total number of reads. Run back through each file and calculate the % of reads mapping to each genes. We flag any gene that has more than 0.00001% of reads mapping. We do this across all files, make a list of genes to ignore, and write that to "skip_genes.txt" in the results directory.



FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p /home/sbhadral/Projects/slurm_log/results/abun_list.txt )

echo $FILE


cut -f 1 <( for i in $( ls abundance*); do  perl -e '@file=<>; $sum=0; foreach(@file){ ($gene,$reads)=split(/,/,$_); $sum+=$reads}; foreach(@file){ ($gene,$reads)=split(/,/,$_); next if $gene=~m/\*/; print "$gene\t",$reads/$sum,"\n" if $reads/$sum>5E-5; }  ' < $i; done ) | sort -n | uniq > skip_genes.txt


## Using the skip_genes.txt file, we run back through each abundance file, and ignore genes that should be skipped, recalculating the reads mapping to our "good" reference, and writing that to a file. 


for i in $( ls abundance*); do  echo "$i,$( perl -e 'open BAD, "<skip_genes.txt"; while(<BAD>){ chomp; $badgenes{$_}=1;}; close BAD; @file=<>; $count=0; $totcount=0; $sum=0; $bigsum=0; foreach(@file){ ($gene,$reads)=split(/,/,$_); $bigsum+=$reads; $totcount+=1; next if $gene=~m/\*/; next if $badgenes{$gene}; $count+=1; $sum+=$reads; } print "$bigsum,$totcount,$sum,$count,",$sum/$bigsum,"\n";' < $i )" ; done > fixed_genes_percent.txt
