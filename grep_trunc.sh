#!/bin/bash -l

#### grep read sequences from fastq lanes, compare them between mates, then truncate both accordingly, so they match.
#### checking specifically, og176_2, og179_2, and og275_2
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/fixed_fastqs
#SBATCH -J fastq_check
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/og176_grep_trunc_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/og176_grep_trunc_%A_%a.err
#SBATCH -c 8
##SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
##SBATCH --mail-user=sbhadralobo@ucdavis.edu
##SBATCH --array=1-4
#SBATCH --array=2
set -e
set -u

### Missing read runs.
# 15998464 EJF-001B_index2_CGATGT_L001_R2_003.fastq og275

# 15999487 EJF_002C_GCCAAT_L007_R2_002.fastq 		og176

# 15998456 EJF_003B_ACTTGA_L008_R2_005.fastq 		og179
# 15997944 EJF_003B_ACTTGA_L008_R2_004.fastq 		og179

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p grep_trunc_list.txt ) # list like above, but of R1 lanes.

for file in "$FILE";

do

short=$( echo "$file" | sed -e 's/EJF//g' | sed -e 's/_L//g' | sed -e 's/.fastq//g' | sed -e 's/_//g' | sed -e 's/00//g' | sed -e 's/-//g' | sed -e 's/index2//g'  )
mate2=$( echo "$file" | sed -e 's/R1/R2/g' ) # replace R1 with R2 to specify mate2.

echo "$file"
echo "$mate2"
echo "$short"

grep -n "^@HS" "$file" > headers."$short"_1; # grep every header and it's line number as lines = {1, 5, 9, ... 4n+1}, save to file.

grep -n "^@HS" "$mate2" > headers."$short"_2; # same as above, but for mate2

echo grep1 finished

cut -s -d ':' -f 1 headers."$short"_1 > nums."$short"_1 # cut out line numbers, delimited by colon. (part of grep -n output e.g 2:<for line 2> )

cut -s -d ':' -f 1 headers."$short"_2 > nums."$short"_2

echo cut1 finished;

diff --suppress-common-lines nums."$short"_1 nums."$short"_2 | # output only line numbers that differ

cut -s -d '<' -f 2 - > new.delete."$short";

echo delete lines are ready.
 
# #cp "$file" temp_delete_lines/

#  delete_list=$( less delete."$short" ) 
# 
#  array=( "$delete_list" )
# 
# cd temp_delete_lines/
# 
# 	#for nums in "$delete_list";
# 	for nums in "${array[@]}";
# 	
# 	do
# 
# 	#sed '/"${array[@]}"/,+3d' "$file" > new."$file";
# 	
# 	#sed 's/.*/&+3d/' delete."$short" | sed -i -f - "$file";
# 	
# 	sed '/"${nums}"/,+3d' "$file" > new."$file";
# 	
# 	done;

done;



## Next delete those lines in the mate 2 runs? Can't be sure if the missing header also means the following 3 lines of ( seq\n +\n seq\n ) are also missing? 

## Fastq lines
# @HS1:192:d143cacxx:8:2304:14253:160681 2:N:0:GATCAG
# CTAGCAGTAACTGGTAAGTATGATGTGAAAAGAAAGCTCAATGACTGGACAATTTGTTCCGTTATGCTTATTCCTTGCCATTTTATTTAAAGTTTTCCCA
# +
# CCCFFFFFHHHHHJGHIJIJIJJJJHHJJJJIJJJJJJJIJJJJJIJJIJIIJJJJIJJJJHJJJJJJJJIIJJIJJJHHHHHHGFFFFFFFCEEEEEC>