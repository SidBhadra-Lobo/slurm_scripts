#!/bin/bash -l

#### compress all the files in Rice_project. Deleted 1.3Tb -> 945Gb, Goal 945Gb -> 300Gb? 
######
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/
#SBATCH -J compress_dirs
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/compress_dirs.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/compress_dirs.err
#SBATCH -c 4
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u

#SBATCH --array=1-6
##SBATCH --array=1-2

##compress

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p compress_list.txt)
#FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p compress_test_list.txt)

for dirs in "$FILE";

do 

   tar -czvf "$dirs".tar.gz "$dirs" --remove-files; 

done;


##decompress
# 
# 
# 
# for dirs in "$FILE";
# 
# do 
# 
#    tar -xzvf "$dirs".tar.gz;
#    rm -f "$dirs".tar.gz; 
# 
# done;