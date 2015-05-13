#!/bin/bash -l

#### PCA file prep pipeline with ANGSD
####
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/ngsTools
#SBATCH -J PCA_fileprep
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/PCA_ogs_prep_ogs_%J.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/PCA_ogs_prep_ogs_%J.err
#SBATCH -c 8
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u


##### All samples, reseq indica + ogs, aligned to japonica. -nind 86, 42 indica, 35 japonica, 9 ogs/bc1
angsd/angsd -bam data/all_samples.txt -GL 1 -out results/all.test -doMaf 1 -doMajorMinor 1 -doGeno 32 -doPost 1 -nind 86 -P 8 -r 1:

gunzip results/all.test.geno.gz

ngsPopGen/ngsCovar -probfile results/all.test.geno -outfile results/all.pop.covar -nind 86 -nsites 100000 -call 0


##### ogs aligned to japonica. -nind 9
angsd/angsd -bam data/og_japonica_samples.txt -GL 1 -out results/og_japonica.test -doMaf 1 -doMajorMinor 1 -doGeno 32 -doPost 1 -nind 9 -P 8 -r 1:

gunzip results/og_japonica.test.geno.gz

ngsPopGen/ngsCovar -probfile results/og_japonica.test.geno -outfile results/og_japonica.pop.covar -nind 9 -nsites 100000 -call 0



##### ogs aligned to indica. -nind 9
angsd/angsd -bam data/og_indica_samples.txt -GL 1 -out results/og_indica.test -doMaf 1 -doMajorMinor 1 -doGeno 32 -doPost 1 -nind 9 -P 8 -r 1:

gunzip results/og_indica.test.geno.gz

ngsPopGen/ngsCovar -probfile results/og_indica.test.geno -outfile results/og_indica.pop.covar -nind 9 -nsites 100000 -call 0
