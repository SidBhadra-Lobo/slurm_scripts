#!/bin/bash -l

#### Match BLAST table probes to IDs from Gene ID table.

#SBATCH -D /home/sbhadral/Projects/Tomato_project/
#SBATCH -J gene_match
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Tomato_project/outs/gene_match_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Tomato_project/errors/gene_match_%A_%a.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu

#SBATCH --array=1-992

set -e
set -u

FILE=$( less /home/sbhadral/Projects/Tomato_project/Gene_ID_tabdelim.txt | sed '/Probe/d' | sed -n "$SLURM_ARRAY_TASK_ID"p );

for id_line in  "$FILE"; # go through gene ID table row by row, in order.

do
	id=$( echo "$id_line" | cut -f1 ); # grab just the ID from that row.

	echo "$id_line";

	echo "$id";

	for file in $(less /home/sbhadral/Projects/Tomato_project/queries/concat_probe_list.txt); # go through concatenated file list.

	do
		cat_name=$( echo "$file" | sed -r 's/.{7}$//' ); # remove .cat.fa from end of file name.

		if [[ "$id" == "$cat_name" ]]; # if the ID matches the file name, then...

			then

				echo "$id" matches "$cat_name" fasta;

				echo about to grep sequence;

				grep "^[ATCG]" /home/sbhadral/Projects/Tomato_project/queries/"$file" | awk -vORS=, '{ print $1 }' | sed 's/,$/\n/' > /home/sbhadral/Projects/Tomato_project/temp/temp."$id"; # turn sequence liene into one long sequence row.


		fi;

	done;

	echo searching blast outputs;

	for blast in $(less /home/sbhadral/Projects/Tomato_project/full_blastn.table | sed '/query/d');

		do
			blast_query=$( echo "$blast" | cut -f 1 );
					
			if [[ "$id" == "$blast_query" ]];

				then

					echo "$id" matches "$blast_query" blast output;

					paste -d '\t' /home/sbhadral/Projects/Tomato_project/temp/temp."$id" <( less /home/sbhadral/Projects/Tomato_project/blastn_outs/"$blast_query".out | grep SL2 ) > /home/sbhadral/Projects/Tomato_project/data_outs/"$id".row; # Add the above generated sequence line to the respective row, in a new table with the new concatenated sequence column.

					echo pasted seq and blast output to new column.;

			fi
					
	done;

	paste -d '\t' <(echo "$id_line") <( less /home/sbhadral/Projects/Tomato_project/data_outs/"$id".row ) >> /home/sbhadral/Projects/Tomato_project/Gene_ID_fulltable.txt

	echo pasted output to final table

done;

