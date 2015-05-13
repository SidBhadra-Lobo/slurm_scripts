#!/bin/bash -l

##moving data.

#SBATCH -D /home/sbhadral/Projects/Rice_project/
#SBATCH -J mv_data
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/mv_data%j.out
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/mv_data%j.err
#SBATCH -c 1
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u


#mv *.* /group/jrigrp5/ECL298/ref_gens/SRR1528444/



#mv /group/jrigrp5/ECL298/ref_gens/* /home/sbhadral/Projects/Rice_project/ref_gens/

mv /group/jrigrp5/ECL298/ref_gens/merid_fastq/* /home/sbhadral/Projects/Rice_project/ref_gens/merid_fastq/

mv /group/jrigrp5/ECL298/reseq_indica/* /home/sbhadral/Projects/Rice_project/reseq_indica/