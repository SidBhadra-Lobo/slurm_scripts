#!/bin/bash -l

#### fastx quality chart
###### og276, maybe check all of them?
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