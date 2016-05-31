#!/bin/bash -l

#SBATCH -D /home/adurvasu/rilab/rice2k16/data/alignments/
#SBATCH -J bam_depth_decimal
#SBATCH -p serial  
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/bam_depth_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/bam_depth_%A_%a.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu

#SBATCH --array=1-92
##SBATCH --array=1-2
set -e
set -u

LIST=$( sed -n "$SLURM_ARRAY_TASK_ID"p /home/sbhadral/Projects/Rice_project/bam_depths/all_bams_depth_list.txt )

for file in "$LIST";
do
	 name=$(echo "$file" | sed 's/\//_/g')

	# samtools depth -a "$file" > /home/sbhadral/Projects/Rice_project/bam_depths/bam_depth_"$name".txt; #-a, Output all positions (including those with zero depth)

	# echo "$name" | cat - /home/sbhadral/Projects/Rice_project/bam_depths/bam_depth_"$name".txt > /home/sbhadral/Projects/Rice_project/bam_depths/temp && mv -f /home/sbhadral/Projects/Rice_project/bam_depths/temp /home/sbhadral/Projects/Rice_project/bam_depths/bam_depth_"$name".txt;

	# paste -d ' ' /home/sbhadral/Projects/Rice_project/bam_depths/bam_depth_"$name".txt /home/sbhadral/Projects/Rice_project/bam_depths/bam_depths_table.txt;

	
	# samtools depth  "$file"  |  awk '{sum+=$3} END { print "Average = ",sum/NR}'; # Average depth using awk.

	# samtools depth "$file"  |  awk '{sum+=$3; sumsq+=$3*$3} END { print "Average = ",sum/NR; print "Stdev = ",sqrt(sumsq/NR - (sum/NR)**2)}' > /home/sbhadral/Projects/Rice_project/bam_depths/"$name"_avg_stdev.txt  # Average depth with std dev.

	
	# samtools depth "$file"  |  awk '{sum+=$3} END { print sum}' > /home/sbhadral/Projects/Rice_project/bam_depths/"$name"_sum.txt  # Average depth with std dev.

	# samtools view -H "$file" | grep -P '^@SQ' | cut -f 3 -d ':' | awk '{sum+=$1} END {print sum}' > /home/sbhadral/Projects/Rice_project/bam_depths/"$name"_genome_size.txt; # genome size to divide by.



	sum=$(samtools depth "$file"  |  awk '{sum+=$3} END { print sum }'); # get total sum of read depths

	genome_size=$(samtools view -H "$file" | grep -P '^@SQ' | cut -f 3 -d ':' | awk '{sum+=$1} END { print sum }'); # get genome size

	# depth=$((sum / genome_size)); # divide

	depth=$( echo "$sum/$genome_size" | bc -l ); # divide with decimal values

	# depth=$(bc <<< 'scale=2; "$sum"/"$genome_size"');

	paste <(echo "$name") <(echo " ") <(echo "$depth") -d '' >> /home/sbhadral/Projects/Rice_project/bam_depths/full_decimal_bam_depths_table.txt; # append to 2 column table of all depths




done;

####\n