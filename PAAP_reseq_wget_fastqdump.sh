#!/bin/bash -l

#### Pre-Preprocessing and Alignment Pipeline (PAAP) This time for resequenced indica or japonica.
###### wget, fastqdump, and cat files.
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/alignments/reseq_japonica_japonica_bams/
#SBATCH -J reseq_japonica_prep
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/wget_reseq_japonica_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/wget_reseq_japonica_%A_%a.err
#SBATCH -c 1
##SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
##SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u
###SBATCH --array=7,9,10-12,27-29,30,32-33
###SBATCH --array=1
###SBATCH --array=2-35
###SBATCH --array=5,7,23,29,30-35
###SBATCH --array=8-11,26-29,31-32
###SBATCH --array=11,30,33
#SBATCH --array=7,12,33

module load sratoolkit/2.3.2-4

## Download all the genomes from ncbi ftp site.
FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p reseq_japonica_wget_list.txt )

for file in "$FILE";

do

#mkdir "$file"

echo "$file"

file1=$( echo "$file" | awk -v row=1 '{A[(NR-1)%row]=A[(NR-1)%row]$0" ";next}END{for(i in A)print A[i]}' )
file2=$( echo "$file" | sed -r 's/.{3}$//' ) ## make array with last 3 chars removed per string.

array1=( $file1 )
array2=( $file2 ) ## array with last 3 chars missing per file ex. ERS467, instead of ERS467764


for i in "${array1[@]}"; # loop through array

do
	length="${#array1[@]}"; # initialize length of array
	
	while [ $length -ne 0 ]; # while array length is != 0
do 
	if [[ "${array1[0]}"=="$file" ]]; # if array first position matches the current file in the slurm array
	then
		wget -r -A.sra -nd -nv -nc -P /home/sbhadral/Projects/Rice_project/alignments/reseq_japonica_japonica_bams/"$file"/ ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads//BySample/sra/ERS/"${array2[0]}"/"${array1[0]}"/;
	unset array1[0]; # remove first position in array1
	unset array2[0]; 
	
	#array1=("${array1[@]}"); # reassign array w/o first position
	#array2=("${array2[@]}");
	
	length=("${#array1[@]}"); # reassign length to new (n - 1) length.
	
	fi
	done

done;

cat /home/sbhadral/Projects/Rice_project/alignments/reseq_japonica_japonica_bams/"$file"/*.sra > /home/sbhadral/Projects/Rice_project/alignments/reseq_japonica_japonica_bams/"$file".sra

fastq-dump --split-files --gzip /home/sbhadral/Projects/Rice_project/alignments/reseq_japonica_japonica_bams/"$file".sra --outdir /home/sbhadral/Projects/Rice_project/alignments/reseq_japonica_japonica_bams/ ;

#gunzip -c /home/sbhadral/Projects/Rice_project/alignments/reseq_japonica_japonica_bams/"$file"/*_1.fastq.gz | cat | gzip /home/sbhadral/Projects/Rice_project/alignments/reseq_japonica_japonica_bams/"$file"_1.fastq.gz ;

#gunzip -c /home/sbhadral/Projects/Rice_project/alignments/reseq_japonica_japonica_bams/"$file"/*_2.fastq.gz | cat | gzip /home/sbhadral/Projects/Rice_project/alignments/reseq_japonica_japonica_bams/"$file"_2.fastq.gz ;

done;


##END
##########\n