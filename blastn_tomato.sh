#!/bin/bash -l

#### blastn Tomato probes against tomato build 2.50 assembled reference genome.

#SBATCH -D /home/sbhadral/Projects/Tomato_project/
#SBATCH -J blastn
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Tomato_project/outs/blastn_tom_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Tomato_project/errors/blastn_tom_%A_%a.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu

##SBATCH --array=1-12

#SBATCH --array=1-5937 #Number of unique probes after concatenation.

set -e
set -u

module load blast

#skip formatdb if already done.
#formatdb -i /home/sbhadral/Projects/Tomato_project/ref_gen/S_lycopersicum_build_2.50_chr1-12.fa -p F 2> /dev/null; 

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p tomato_query_list_2col_nodups.txt ) # using non-duplicate headers for running blast on concatenated fast 

for file in "$FILE";

do
	probe_id=$( echo "$file" | cut -f 1 );

	blastn -query /home/sbhadral/Projects/Tomato_project/queries/"$probe_id".cat.fa -db /home/sbhadral/Projects/Tomato_project/ref_gen/S_lycopersicum_build_2.50_chr1-12.fa -outfmt 7 > /home/sbhadral/Projects/Tomato_project/blastn_outs/"$probe_id".out;

	rm /home/sbhadral/Projects/Tomato_project/queries/"$probe_id".fa -f;

done;