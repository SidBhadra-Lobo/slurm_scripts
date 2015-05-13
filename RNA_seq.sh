#!/bin/bash -l 

#SBATCH -D /home/sbhadral/Projects/Rice_project/RNAseq
#SBATCH -J RNAseq
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/RNAseq_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/RNAseq_%A_%a.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u
#SBATCH --array=1

module load sratoolkit/2.3.2-4

#cd /home/sbhadral/Projects/Rice_project/RNAseq/gluma

#wget ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRR117/SRR1174773/SRR1174773.sra

#cd /home/sbhadral/Projects/Rice_project/RNAseq/nivara

#wget ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRR117/SRR1171631/SRR1171631.sra

#fastq-dump --split-files /home/sbhadral/Projects/Rice_project/RNAseq/gluma/SRR1174773.sra

#mv SRR1174773* /home/sbhadral/Projects/Rice_project/RNAseq/gluma/

#fastq-dump --split-files /home/sbhadral/Projects/Rice_project/RNAseq/nivara/SRR1171631.sra
