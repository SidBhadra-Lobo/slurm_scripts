#!/bin/bash -l

#### Call Snps
###### samtools/plink PCA of all samples aligned to japonica.
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/alignments/plink_all_samples/
#SBATCH -J smtlsplnk_snp_all_samples
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/smtlsplnk_snp_all_samples_full.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/smtlsplnk_snp_all_samples_full.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u

# module load plink/1.90
# 
# FILE=$( less /home/sbhadral/Projects/Rice_project/ngsTools/data/all_samples.txt )
# 
# file=$( echo "$FILE" | awk -v row=1 '{A[(NR-1)%row]=A[(NR-1)%row]$0" ";next}END{for(i in A)print A[i]}' )
# 
# all_samples_array=( $file )
# 
# samtools mpileup -r 1: -uf /home/sbhadral/Projects/Rice_project/ref_gens/Oryza_sativa.IRGSP-1.0.23.dna.genome.fa.gz "${all_samples_array[@]}" | 
# bcftools view -bvcg - > all_samples.raw.bcf
# bcftools view all_samples.raw.bcf > all_samples.raw.vcf
# vcftools --vcf all_samples.raw.vcf --plink --out all_samples.raw
# plink --file all_samples.raw --genome --noweb --allow-no-sex --out all_samples.raw
# plink --file all_samples.raw --read-genome all_samples.raw.genome --cluster --mds-plot 2 --noweb #--out results/og_japonica_plink.mds 

Rscript /home/sbhadral/Projects/Rice_project/slurm_scripts/samtools_plink_all_sample_PCA.R > /home/sbhadral/Projects/Rice_project/ngsTools/results/PCA_samtools_plink_all_samples_japonica.pdf
