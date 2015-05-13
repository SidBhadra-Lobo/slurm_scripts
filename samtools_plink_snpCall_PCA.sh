#!/bin/bash -l

#### Call Snps
###### wget, fastqdump, and cat files.
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/alignments/
#SBATCH -J smtlsplnk_snp_og_indica
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/smtlsplnk_snp_og_indica_%A_%a.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/smtlsplnk_snp_og_indica_%A_%a.err
#SBATCH -c 8
##SBATCH --mail-type=FAIL
##SBATCH --mail-type=END
##SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u
###SBATCH --array=

FILE1=$( less og_indica_sorted_list.txt )

file1=$( echo "$FILE1" | awk -v row=1 '{A[(NR-1)%row]=A[(NR-1)%row]$0" ";next}END{for(i in A)print A[i]}' )

indica_array=( $file1 )

samtools mpileup -r 1: -uf -r 1:/group/jrigrp5/ECL298/ref_gens/Oryza_sativa.IRGSP-1.0.23.dna.genome.fa.gz "${indica_array[@]}" | 
bcftools view -bvcg - > og_indica_samples.raw.bcf
bcftools view og_indica_samples.raw.bcf > og_indica_samples.raw.vcf
vcftools --vcf og_indica_samples.raw.vcf --plink --out og_indica_samples.raw
plink --file og_indica_samples.raw --genome --noweb --allow-no-sex --out og_indica_samples.raw
plink --file og_indica_samples.raw --read-genome og_indica_samples.raw.genome --cluster --mds-plot 2 --noweb

d <- read.table("results/plink.mds", h=T)
d$pop = factor(c(rep("indica", 42), rep("allopatric", 4), rep("sympatric", 4)))
plot(d$C1, d$C2, col=as.integer(d$pop), pch=19, xlab="PC 1", ylab="PC 2", main = "PCA of O. og_indica (samtools/plink)")
legend("topright", c("Indica", "Allopatric", "Sympatric"), pch=19, col=c(2,1,3))
text(d$C1, d$C2, labels=c(rep(NA, 18), "og276", NA), pos=1)

FILE2=$( less og_japonica_sorted_list.txt )

file2=$( echo "$FILE2" | awk -v row=1 '{A[(NR-1)%row]=A[(NR-1)%row]$0" ";next}END{for(i in A)print A[i]}' )

japonica_array=( $file2 )

samtools mpileup -r 1: -uf /group/jrigrp5/ECL298/ref_gens/Oryza_sativa.IRGSP-1.0.23.dna.genome.fa.gz "${japonica_array[@]}" | 
bcftools view -bvcg - > og_japonica_samples.raw.bcf
bcftools view og_japonica_samples.raw.bcf > og_japonica_samples.raw.vcf
vcftools --vcf og_japonica_samples.raw.vcf --plink --out og_japonica_samples.raw
plink --file og_japonica_samples.raw --genome --noweb --allow-no-sex --out og_japonica_samples.raw
plink --file og_japonica_samples.raw --read-genome og_japonica_samples.raw.genome --cluster --mds-plot 2 --noweb

d <- read.table("results/plink.mds", h=T)
d$pop = factor(c(rep("indica", 42), rep("allopatric", 4), rep("sympatric", 4)))
plot(d$C1, d$C2, col=as.integer(d$pop), pch=19, xlab="PC 1", ylab="PC 2", main = "PCA of O. gluma and og_japonica (samtools/plink)")
legend("topright", c("Indica", "Allopatric", "Sympatric"), pch=19, col=c(2,1,3))
text(d$C1, d$C2, labels=c(rep(NA, 18), "og276", NA), pos=1)