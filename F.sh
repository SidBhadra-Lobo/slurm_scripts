#!/bin/bash -l

#### F script.

#SBATCH -D /home/sbhadral/Projects/Rice_project/angsd-wrapper/
#SBATCH -J F
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/F_%j.err
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/F_%j.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u


##/home/sbhadral/Projects/Rice_project/angsd-wrapper/angsd/angsd -bam /home/tvkent/projects/rice/data/sympfilelist.txt -doGLF 3 -GL 1 -out /home/sbhadral/Projects/Rice_project/angsd-wrapper/results/F/sympGL -doMaf 2 -SNP_pval 1e-6 -doMajorMinor 1 -nThreads 4

N_SITES="$((`zcat /home/sbhadral/Projects/Rice_project/angsd-wrapper/results/F/sympGL.mafs.gz | wc -l`-1))"

zcat /home/sbhadral/Projects/Rice_project/angsd-wrapper/results/F/sympGL.glf.gz | /home/sbyfield/ngsF/ngsF -n_ind 4 -n_sites $N_SITES -min_epsilon 1e-6 -glf - -out /home/sbhadral/Projects/Rice_project/angsd-wrapper/results/F/symp.approx_indF -approx_EM -seed 12345 -init_values r -n_threads 4

zcat /home/sbhadral/Projects/Rice_project/angsd-wrapper/results/F/sympGL.glf.gz | /home/sbyfield/ngsF/ngsF -n_ind 4 -n_sites $N_SITES -min_epsilon 1e-6 -glf - -out /home/sbhadral/Projects/Rice_project/angsd-wrapper/results/F/symp.indF -init_values /home/sbhadral/Projects/Rice_project/angsd-wrapper/results/F/symp.approx_indF.pars -n_threads 4

#zcat /home/sbhadral/Projects/Rice_project/angsd-wrapper/results/F/sympGL.glf.gz | /home/sbyfield/ngsF/ngsF -n_ind 4 -n_sites 4804870 -min_epsilon 1e-6 -glf - -out /home/sbhadral/Projects/Rice_project/angsd-wrapper/results/F/symp.approx_indF -approx_EM -seed 12345 -init_values r -n_threads 4

#zcat /home/sbhadral/Projects/Rice_project/angsd-wrapper/results/F/sympGL.glf.gz | /home/sbyfield/ngsF/ngsF -n_ind 4 -n_sites 4804870 -min_epsilon 1e-6 -glf - -out /home/sbhadral/Projects/Rice_project/angsd-wrapper/results/F/symp.indF -init_values /home/sbhadral/Projects/Rice_project/angsd-wrapper/results/F/symp.approx_indF.pars -n_threads 4