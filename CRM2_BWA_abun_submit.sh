#!/bin/bash -l

##########
## Using BWA mem to estimate CRM2 abundance for a single hapmap2 lane. (This is a test script, hence only aligning a single lane).
##########

## -D sets directory
#SBATCH -D /home/sbhadral/Projects/CRM2_abun/

## -p sets the partition to run the job on
#SBATCH -p hi

## -o sets the destination for the stdout. %j sets the job name.
#SBATCH -o /home/sbhadral/Projects/slurm_log/CRM2_submit_stdout_%j.txt

## -e sets the destination for the stderr.
#SBATCH -e /home/sbhadral/Projects/slurm_log/CRM2_submit_stderr_%j.txt

## -N Specify the number of requested nodes.
#SBATCH -N 1

## -c sets number of cpus required per task
#SBATCH -c 1

## Loop through all files while executing the script across all files in parallel.

list1=(*[1].txt.bz2)
list2=(*[2].txt.bz2)

for file1 in ${list1}

do	
	for file2 in ${list2}
	
	do

## Run script.
	sbatch -J CRM2_abun --export=VARIABLE=${file1} --export=VARIABLE=${file2}  /home/sbhadral/Projects/scripts/CRM2_BWA_abun_test.sh
	
	echo "submitting: ${file1}"
	echo "submitting: ${file2}"
	 

done
	
##########
##END
##########\n