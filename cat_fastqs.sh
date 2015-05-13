#!/bin/bash -l

#### Concatenating fastq runs into a full genome paired-end fastqs
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/fixed_fastqs/
#SBATCH -J cat_fastqs
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/cat_fastqs_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/cat_fastqs_%A_%a.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u
##SBATCH --array=1-9
#SBATCH --array=2,8

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p cat_list_all9.txt )


for file in "$FILE";

do 

file1=$( echo $file | sed -e 's/R1\_001.fastq/R1*.fastq/g' )
##file2=$( echo $file1 |  sed -e 's/R1\*.fastq/R2*.fastq/g' ) ## Doesn't work, spits out file1 again.
file2=$( echo $file1 |  sed -e 's/R1/R2/g' )
file3=$( echo $file | sed -e 's/_R1_\001.fastq//g' )

echo $file1
echo $file2
echo $file3

less $file1 | cat | gzip -kc > /home/sbhadral/Projects/Rice_project/og_fastqs/$file3.R1.cat 

less $file2 | cat | gzip -kc > /home/sbhadral/Projects/Rice_project/og_fastqs/$file3.R2.cat ;

done

# EJF-001A_index1_ATCACG_L001_R1_001.fastq	 og273
# EJF-001B_index2_CGATGT_L001_R1_001.fastq	 og275
# EJF-001C_index3_TTAGGC_L001_R1_001.fastq	 og276
# EJF_002A_TGACCA_L007_R1_001.fastq		og278
# EJF_002B_ACAGTG_L007_R1_001.fastq 	og175


# EJF_002C_GCCAAT_L007_R1_001.fastq 	og176
# EJF_003A_CAGATC_L008_R1_001.fastq 	og177
# EJF_003B_ACTTGA_L008_R1_001.fastq 	og179
# EJF_003C_GATCAG_L008_R1_001.fastq 	bc1