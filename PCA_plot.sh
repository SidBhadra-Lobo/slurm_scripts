#!/bin/bash -l

#### PCA plot in R
####
########

#SBATCH -D /home/sbhadral/Projects/Rice_project/ngsTools
#SBATCH -J PCA_plot
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/PCA_plot_all_%J.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/PCA_plot_all_%J.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u

module load R

##### All samples, reseq indica + ogs, aligned to japonica. -nind 86 42 indica, 35 japonica, 9 ogs/bc1
Rscript -e 'write.table(cbind(seq(1,10),rep(1,10),c(rep("BC1", 1),rep("Allopatric",4),rep("Sympatric",4),rep("Indica",42),rep("Japonica",35))), row.names=F, sep=" ", col.names=c("FID","IID","CLUSTER"), file="/home/sbhadral/Projects/Rice_project/ngsTools/results/all.pops.clst", quote=F)'

Rscript /home/sbhadral/Projects/Rice_project/ngsTools/scripts/plotPCA.R -i /home/sbhadral/Projects/Rice_project/ngsTools/results/all.pop.covar -c 1-2 -a /home/sbhadral/Projects/Rice_project/ngsTools/results/all.pops.clst -o /home/sbhadral/Projects/Rice_project/ngsTools/results/PCA_reseq_indica+japonica+ogs.pdf


##### ogs aligned to japonica. -nind 9
Rscript -e 'write.table(cbind(seq(1,9),rep(1,9),c(rep("BC1", 1),rep("Allopatric",4),rep("Sympatric",4))), row.names=F, sep=" ", col.names=c("FID","IID","CLUSTER"), file="/home/sbhadral/Projects/Rice_project/ngsTools/results/og_japonica.pops.clst", quote=F)'

Rscript /home/sbhadral/Projects/Rice_project/ngsTools/scripts/plotPCA.R -i /home/sbhadral/Projects/Rice_project/ngsTools/results/og_japonica.pop.covar -c 1-2 -a /home/sbhadral/Projects/Rice_project/ngsTools/results/og_japonica.pops.clst -o /home/sbhadral/Projects/Rice_project/ngsTools/results/PCA_og_japonica.pdf


##### ogs aligned to indica. -nind 9
Rscript -e 'write.table(cbind(seq(1,9),rep(1,9),c(rep("BC1", 1),rep("Allopatric",4),rep("Sympatric",4))), row.names=F, sep=" ", col.names=c("FID","IID","CLUSTER"), file="/home/sbhadral/Projects/Rice_project/ngsTools/results/og_indica.pops.clst", quote=F)'

Rscript /home/sbhadral/Projects/Rice_project/ngsTools/scripts/plotPCA.R -i /home/sbhadral/Projects/Rice_project/ngsTools/results/og_indica.pop.covar -c 1-2 -a /home/sbhadral/Projects/Rice_project/ngsTools/results/og_indica.pops.clst -o /home/sbhadral/Projects/Rice_project/ngsTools/results/PCA_og_indica.pdf