#!/bin/bash -l

#### delete reads from og runs.
#### specifically mismatches betweeen, og176_2, og179_2, and og275_2 and their mates.
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/fixed_fastqs/temp_delete_lines/
#SBATCH -J sed_delete
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/sed_delete_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/sed_delete_%A_%a.err
#SBATCH -c 8
##SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
##SBATCH --mail-user=sbhadralobo@ucdavis.edu
##SBATCH --array=1-4
set -e
set -u

### Missing read runs.
# 15998464 EJF-001B_index2_CGATGT_L001_R2_003.fastq og275

# 15999487 EJF_002C_GCCAAT_L007_R2_002.fastq 		og176

# 15998456 EJF_003B_ACTTGA_L008_R2_005.fastq 		og179
# 15997944 EJF_003B_ACTTGA_L008_R2_004.fastq 		og179

 cp ../EJF_002C_GCCAAT_L007_R2_002.fastq ./
 

## delete lines missing from _2 mate, in _1 mate, so both mates match.

sed -i.back -e '8419769,8419771d' EJF_002C_GCCAAT_L007_R1_002.fastq # delete lines from og176_1

##sed -i.back -e '8419769,8419771d' EJF_002C_GCCAAT_L007_R2_002.fastq # "   "   " og176_2

## need to run grep_trunc.sh on the above 2, to see if corrupt read is fixed.
# 
# sed -i.back -e '15998465,16000000d' EJF-001B_index2_CGATGT_L001_R1_003.fastq # og275_1
# 
# sed -i.back -e '15997945,16000000d' EJF_003B_ACTTGA_L008_R1_004.fastq # og179_1 lane 4
# 
# sed -i.back -e '15998457,16000000d' EJF_003B_ACTTGA_L008_R1_005.fastq # og179_1 lane 5

## then run line_count.sh on the above to check if all is good.