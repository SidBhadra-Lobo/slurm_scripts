#!/bin/bash -l

#### Uncompress ogfastqs for SRA upload
######
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/
#SBATCH -J uncompress_loop
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/uncompress_ogfqs_loop.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/uncompress_ogfqs_loop.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
#SBATCH --array=1
set -e
set -u

##Uncompress

# tar -xzvf og_fastqs.tar.gz;

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p uncomp_ogfqs_list.txt )

for file in "$FILE";

do 

   tar -xzvf "$file"; 

done;


