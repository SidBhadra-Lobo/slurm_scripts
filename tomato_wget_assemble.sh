#!/bin/bash -l

#### Download tomato genome, uncompress, concatenate to make full genome.

#SBATCH -D /home/sbhadral/Projects/Tomato_project/
#SBATCH -J wget_tom
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Tomato_project/outs/wget_tom_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Tomato_project/errors/wget_tom_%A_%a.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
#SBATCH --array=1-12

##SBATCH --array=1
set -e
set -u

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p wget_list.txt )

for file in "$FILE"

do

chr=$( echo "$file" | sed 's/.*\///g' )
unzip=$( echo "$file" | sed -r 's/.{7}$//g' )

# wget -O "$file" /ref_gen/"$chr";

cd ref_gen

curl "$file" -o /home/sbhadral/Projects/Tomato_project/ref_gen/"$chr";

tar -Oxvzf /home/sbhadral/Projects/Tomato_project/ref_gen/"$chr" >> /home/sbhadral/Projects/Tomato_project/ref_gen/S_lycopersicum_build_2.50_chr1-12.fa;

done;
