#!/bin/bash -l

#### Make single fastas to blast against tomato ref gen.

#SBATCH -D /home/sbhadral/Projects/Tomato_project/
#SBATCH -J make_fasta
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Tomato_project/outs/make_single_fasta_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Tomato_project/errors/make_single_fasta_%A_%a.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu

##SBATCH --array=1-65535 # can't run all at once.


##SBATCH --array=1-10

##SBATCH --array=1-40000
#SBATCH --array=1-25535 #last 25535 


set -e
set -u

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p /home/sbhadral/Projects/Tomato_project/tomato_query_list_tail_25535.txt ); 

for file in "$FILE";

do
	probe_id=$( echo "$file" | cut -f 1 );
	
	echo probe assigned;
	echo "$probe_id";

	seq=$(echo "$file" | cut -f 5 );

	echo seq assigned;

	echo "$seq";

 	echo ">"$probe_id"" >> /home/sbhadral/Projects/Tomato_project/single_queries/"$probe_id"."$seq".fa;
 	
 	echo made "$probe_id" header;

 	echo "$seq" >> /home/sbhadral/Projects/Tomato_project/single_queries/"$probe_id"."$seq".fa;

 	echo fasta added to;

 	#Do blastn on query made above.

	blastn -query /home/sbhadral/Projects/Tomato_project/single_queries/"$probe_id"."$seq".fa -db /home/sbhadral/Projects/Tomato_project/ref_gen/S_lycopersicum_build_2.50_chr1-12.fa -outfmt 7 > /home/sbhadral/Projects/Tomato_project/single_blastn_outs/"$probe_id"."$seq".out;


done;

