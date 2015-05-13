#!/bin/bash -l

#### read checks in fastq.gz
#### checking specifically, og176_2, og179_2, and og275_2
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/og_fastqs
#SBATCH -J read_check
#SBATCH -p bigmemm
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/og176_issue_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/og176_issue_%A_%a.err
#SBATCH -c 4
##SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
##SBATCH --mail-user=sbhadralobo@ucdavis.edu
#SBATCH --array=1
set -e
set -u

#module load FASTX-Toolkit/0.0.13.2-goolf-1.4.10

#module load perlnew fastx

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p fastx_list2.txt );

# Initialize a list to run loop through.
for file in "$FILE";

do

echo "$file"
file1=$( echo "$file" | awk -v row=1 '{A[(NR-1)%row]=A[(NR-1)%row]$0" ";next}END{for(i in A)print A[i]}' );
 file2=$( echo "$file" | sed -r 's/.{3}$//' )
array1=( $file1 );
echo "${array1[0]}"

# 		if [[ "${array1[0]}"=="og179_2.fastq" ]];
# 			then
# 			less "$file" | sed -n '52320070,52321072p' > read_check."$file2" # check error line n-2 to n+1000 
# 		fi
# 	
# 		if [[ "${array1[0]}"=="og275_2.fastq" ]];
# 			then
# 			less "$file" | sed -n '43619074,43620076p' > read_check."$file2" # check error line n-2 to n+1000
# 		fi

		if [[ "${array1[0]}"=="og176_2.fastq" ]];
			then
			#less "$file" | sed -n '24419768,24420770p' > read_check."$file2" # check error line n-2 to n+1000
			less "$file" | sed -n '8419768,15999997p' > problems."$file2"
		fi;

	
done;