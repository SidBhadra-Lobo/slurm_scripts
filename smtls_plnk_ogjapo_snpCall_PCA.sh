#!/bin/bash -l

#### Call Snps
###### samtools/plink PCA of ogs aligned to japonica
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/alignments/plink_og_japonica/
#SBATCH -J smtlsplnk_snp_og_japonica
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/smtlsplnk_snp_og_japonica_full.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/smtlsplnk_snp_og_japonica_full.err
#SBATCH -c 8
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u

module load plink/1.90

FILE2=$( less /home/sbhadral/Projects/Rice_project/alignments/og_japonica_sorted_list.txt )

file2=$( echo "$FILE2" | awk -v row=1 '{A[(NR-1)%row]=A[(NR-1)%row]$0" ";next}END{for(i in A)print A[i]}' )

japonica_array=( $file2 )

samtools mpileup -r 1: -uf /home/sbhadral/Projects/Rice_project/ref_gens/Oryza_sativa.IRGSP-1.0.23.dna.genome.fa.gz "${japonica_array[@]}" | 
bcftools view -bvcg - > og_japonica_samples.raw.bcf
bcftools view og_japonica_samples.raw.bcf > og_japonica_samples.raw.vcf
vcftools --vcf og_japonica_samples.raw.vcf --plink --out og_japonica_samples.raw
plink --file og_japonica_samples.raw --genome --noweb --allow-no-sex --out og_japonica_samples.raw
plink --file og_japonica_samples.raw --read-genome og_japonica_samples.raw.genome --cluster --mds-plot 2 --noweb #--out results/og_japonica_plink.mds 

Rscript /home/sbhadral/Projects/Rice_project/slurm_scripts/samtools_plink_og_japonica_PCA.R > /home/sbhadral/Projects/Rice_project/ngsTools/results/PCA_samtools_plink_og_japonica.pdf
