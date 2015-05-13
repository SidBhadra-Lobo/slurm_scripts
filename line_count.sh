#!/bin/bash -l

#### check fastq runs to see if number of reads is divisible by 4 and not odd.
#### checking specifically, og176_2, og179_2, and og275_2
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/fixed_fastqs
#SBATCH -J line_count
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/linecount_fixed_mates_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/linecount_fixed_mates_%A_%a.err
#SBATCH -c 8
##SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
##SBATCH --mail-user=sbhadralobo@ucdavis.edu
#SBATCH --array=1-3
set -e
set -u

# EJF-001B_index2_CGATGT_L001_R1_001.fastq	 og275
# EJF_002C_GCCAAT_L007_R1_001.fastq 	og176
# EJF_003B_ACTTGA_L008_R1_001.fastq 	og179

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p line_count_list.txt )

for ogs in "$FILE";
 
do

echo "$ogs"

array=( "$ogs" )
echo "${array[0]}"

#og275=$( ls EJF-001B_index2_CGATGT_L001_R1_*.fastq )
#og176=$( ls EJF_002C_GCCAAT_L007_R1_*.fastq )
#og179=$( ls EJF_003B_ACTTGA_L008_R1_*.fastq )

cd temp_delete_lines

	if [[ "${array[0]}"=="EJF-001B_index2_CGATGT_L001_R1_001.fastq" ]];
	then
		wc -l EJF-001B_index2_CGATGT_L001_R1_*.fastq >> linecount.og275.txt; ## linecount for mate 1 or 2 denoted by R1 or R2, respectively.
		wc -l EJF-001B_index2_CGATGT_L001_R1_*.fastq.fix >> linecount.og275.txt; 
		awk '!x[$0]++' linecount.og275.txt > linecount.og275_1+2.txt
	fi
	
	if [[ "${array[0]}"=="EJF_002C_GCCAAT_L007_R1_001.fastq" ]];
	then
		wc -l EJF_002C_GCCAAT_L007_R1_*.fastq  >> linecount.og176.txt
		wc -l EJF_002C_GCCAAT_L007_R1_*.fastq.fix  >> linecount.og176.txt;
		wc -l EJF_002C_GCCAAT_L007_R2_*.fastq  >> linecount.og176.txt
		wc -l EJF_002C_GCCAAT_L007_R2_*.fastq.fix  >> linecount.og176.txt;
		
		awk '!x[$0]++' linecount.og176.txt > linecount.og176_1+2.txt
	fi

	if [[ "${array[0]}"=="EJF_003B_ACTTGA_L008_R1_001.fastq" ]];
	then
		wc -l EJF_003B_ACTTGA_L008_R1_*.fastq  >> linecount.og179.txt;
		wc -l EJF_003B_ACTTGA_L008_R1_*.fastq.fix  >> linecount.og179.txt;
		awk '!x[$0]++' linecount.og179.txt > linecount.og179_1+2.txt
	fi

done;