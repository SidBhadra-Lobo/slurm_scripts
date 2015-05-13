#!/bin/bash -l

#### 2DSFS script from Tim that will be used as a template.

#SBATCH -D /home/sbhadral/Projects/Rice_project/alignments/og_bams/
#SBATCH -J 2dsfs
#SBATCH -o /home/sbhadral/Projects/Rice_project/2dsfs_%j.out
#SBATCH -p serial
#SBATCH -e /home/sbhadral/Projects/Rice_project/2dsfs_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
set -e
set -u

# Timothy M. Beissinger
# 7-3-2014

# first read in the two arguments, which should be the two populations that
# we wish to compute the 2dsfs for.
pop1=$1
pop2=$2

echo $pop1
echo $pop2
echo

# Next, we set initial values
angsdir=/home/sbhadral/Projects/Rice_project/angsd-wrapper/angsd/
outputdir=/home/sbhadral/Projects/Rice_project/angsd-wrapper/results/
nIndPop1=$( wc -l /home/sbhadral/Projects/Rice_project/angsd-wrapper/data/"$pop1"_samples.txt | cut -f 1 -d " " )
nIndPop2=$( wc -l /home/sbhadral/Projects/Rice_project/angsd-wrapper/data/"$pop2"_samples.txt | cut -f 1 -d " " )
nPop1=$( expr 2 \* $nIndPop1 )
nPop2=$( expr 2 \* $nIndPop2 )
minperc=0.8
minIndPop1=$( printf "%.0f" $(echo "scale=2;$minperc*$nIndPop1" | bc))
minIndPop2=$( printf "%.0f" $(echo "scale=2;$minperc*$nIndPop2" | bc))
glikehood=1
minMapQ=30
cpu=16
range="1:"

# Script will run ANGSD and calculate 2d sfs for pop1 and pop2 hapmap files
# have already run ANGSD for pop1 and pop2 individually, output of interest is
# in "$pop1".saf.pos.gz and "pop2".saf.pos.gz -- we need to know which sites have
# coverage in both populations.
# NOTICE: IF INDIVIDUAL RUNS WERE ON A SUBSET OF POSITIONS, THIS SCRIPT
# SHOULD BE RUN ON THE SAME SUBSET (probably has to be...)

# Next, extract the compressed files

command1=""$outputdir"/"$pop1".saf.pos.gz "
command2=""$outputdir"/"$pop2".saf.pos.gz "
echo gunzip $command1
echo
echo gunzip $command2
echo
gunzip $command1
gunzip $command2

# Now we find the positions that occur in both populations using the
# uniq POSIX program

command3=" "$outputdir"/"$pop1".saf.pos "$outputdir"/"$pop2".saf.pos|sort|uniq -d >"$outputdir"/intersect."$pop1"."$pop2".txt"
echo cat $command3
echo
cat "$outputdir"/"$pop1".saf.pos "$outputdir"/"$pop2".saf.pos|sort|uniq -d >"$outputdir"/intersect."$pop1"."$pop2".txt

# Now redo angsd sample allele frequency calculation by conditioning on
# the sites that occur in both populations.

command4=" -bam /home/sbhadral/Projects/Rice_project/angsd-wrapper/data/"$pop1"_samples.txt -out "$outputdir"/"$pop1"conditioned -doMajorMinor 1 -doMaf 1 -indF /home/sbhadral/Projects/Rice_project/angsd-wrapper/data/"$pop1"_F.txt -doSaf 2 -uniqueOnly 0 -anc /home/sbhadral/Projects/Rice_project/ref_gens/Oryza_sativa.IRGSP-1.0.23.dna.genome.fa.gz -minMapQ $minMapQ -minQ 20 -nInd $nIndPop1 -baq 1 -ref /home/sbhadral/Projects/Rice_project/ref_gens/Oryza_sativa.IRGSP-1.0.23.dna.genome.fa.gz -GL $glikehood -P $cpu -r $range -sites "$outputdir"/intersect."$pop1"."$pop2".txt"
echo "$angsdir"/angsd $command4
echo
"$angsdir"/angsd $command4

command5=" -bam DATA/LISTS/"$pop2"_list.txt -out "$outputdir"/"$pop2"conditioned -doMajorMinor 1 -doMaf 1 -indF /home/sbhadral/Projects/Rice_project/angsd-wrapper/data/"$pop2"_F.txt -doSaf 2 -uniqueOnly 0 -anc /home/sbhadral/Projects/Rice_project/ref_gens/Oryza_sativa.IRGSP-1.0.23.dna.genome.fa.gz -minMapQ $minMapQ -minQ 20 -nInd $nIndPop2 -baq 1 -ref /home/sbhadral/Projects/Rice_project/ref_gens/Oryza_sativa.IRGSP-1.0.23.dna.genome.fa.gz -GL $glikehood -P $cpu -r $range -sites "$outputdir"/intersect."$pop1"."$pop2".txt"
echo "$angsdir"/angsd $command5
echo
"$angsdir"/angsd $command5



# Now we estimate the joint sfs using the realSFS program
command6=" 2dsfs "$outputdir"/"$pop1"conditioned.saf "$outputdir"/"$pop2"conditioned.saf $nPop1 $nPop2 -P $cpu"