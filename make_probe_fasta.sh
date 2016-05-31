#!/bin/bash -l

#### blastn Tomato probes against tomato build 2.50 assembled reference genome.

#SBATCH -D /home/sbhadral/Projects/Tomato_project/
#SBATCH -J make_fasta
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Tomato_project/outs/make_fasta_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Tomato_project/errors/make_fasta_%A_%a.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu

##SBATCH --array=1-12

##SBATCH --array=1-65535 # can't run all at once.
##SBATCH --array=1-10000 #done
##SBATCH --array=10001-20000 #done
##SBATCH --array=20001-30000 #done
##SBATCH --array=30001-50000 #done

#SBATCH --array=1-15535 # to do the last 15535

set -e
set -u

# FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p tomato_query_list_2col.txt); # to do the first 50000

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p tomato_query_list_2col_tail_15535.txt ); # to do the last 15535

for file in "$FILE";

do
	probe_id=$( echo "$file" | cut -f 1 );
	
	echo probe assigned;
	echo "$probe_id";

	seq=$(echo "$file" | cut -f 5 );

	echo seq assigned;

	echo "$seq";
	
	# echo "$seq" >> /home/sbhadral/Projects/Tomato_project/queries/"$seq".txt;
	# echo added to "$seq".txt;

 	echo ">"$probe_id"" >> /home/sbhadral/Projects/Tomato_project/queries/"$probe_id"."$sed".fa;
 	echo made "$probe_id" header;

 	echo "$seq" >> /home/sbhadral/Projects/Tomato_project/queries/"$probe_id"."$seq".fa;

 	echo fasta added to;

 	awk '!x[$0]++' /home/sbhadral/Projects/Tomato_project/queries/"$probe_id".fa > /home/sbhadral/Projects/Tomato_project/queries/"$probe_id".cat.fa;

 	# rm /home/sbhadral/Projects/Tomato_project/queries/"$seq".txt -f;
 	# echo removed "$seq".txt;

 	# rm /home/sbhadral/Projects/Tomato_project/queries/"$probe_id".txt -f;
 	# echo removed "$probe_id".txt;

	# blastn -query /home/sbhadral/Projects/Tomato_project/queries/"probe_id".fa -db /home/sbhadral/Projects/Tomato_project/ref_gen/S_lycopersicum_build_2.50_chr1-12.fa -outfmt 7 > /home/sbhadral/Projects/Tomato_project/blastn_outs/"$probe_id".out;

done;

	# blastn -query /home/sbhadral/Projects/Tomato_project/queries/"$probe_id".fa -db /home/sbhadral/Projects/Tomato_project/ref_gen/S_lycopersicum_build_2.50_chr1-12.fa -outfmt 7 > /home/sbhadral/Projects/Tomato_project/blastn_outs/"$probe_id".out;


