#!/bin/bash -l

#### 2DSFS script from Tim that will be used as a template.

#SBATCH -D /group/jrigrp5/ECL298/alignments/og_indica_bams/
#SBATCH -J 2DSFS_Fst_og2_reseq
#SBATCH -e /home/sbhadral/Projects/Rice_project/errors/2dsfs_og2_reseq_%j.err
#SBATCH -p serial
#SBATCH -o /home/sbhadral/Projects/Rice_project/outs/2dsfs_og2_reseq_%j.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=sbhadralobo@ucdavis.edu
set -e
set -u



# Set initial values
pop1=og2
pop2=reseq_indica
angsdir=/home/sbhadral/Projects/Rice_project/angsd-wrapper/angsd
outputdir=/home/sbhadral/Projects/Rice_project/angsd-wrapper/results/og2ngreseq_2dsfs
ref=/group/jrigrp5/ECL298/ref_gens/Oryza_indica.ASM465v1.24.dna.genome.fa.gz
anc=/home/tvkent/projects/rice/data/meridionalis_anc.fa.gz
pop1List=/home/sbhadral/Projects/Rice_project/angsd-wrapper/data/"$pop1"_list.txt
pop2List=/home/sbhadral/Projects/Rice_project/angsd-wrapper/data/"$pop2"_list.txt
nIndPop1=$( wc -l "$pop1List" | cut -f 1 -d " " )
nIndPop2=$( wc -l "$pop2List" | cut -f 1 -d " " )
nPop1=$( expr 2 \* $nIndPop1 )
nPop2=$( expr 2 \* $nIndPop2 )
minperc=0.8
##### use minInd and do 80% of num individuals for indica, and use 4 for ogs.
minIndPop1=$( printf "%.0f" $(echo "scale=2;$minperc*$nIndPop1" | bc))
minIndPop2=$( printf "%.0f" $(echo "scale=2;$minperc*$nIndPop2" | bc))
#### For ogs, minInd is = 4
#minIndPop1=4
#minIndPop2=4
####
pop1F=/home/sbhadral/Projects/Rice_project/angsd-wrapper/data/"$pop1".indF
pop2F=/home/sbhadral/Projects/Rice_project/angsd-wrapper/data/"$pop2".indF
glikehood=1
minMapQ=30
cpu=8
regionfile="/home/sbhadral/Projects/Rice_project/angsd-wrapper/data/wholeGenomeRegionFile.txt"
windowsize=1000
step=1000



# Echo input values
echo "pop1 = "$pop1""
echo "pop2 = "$pop2""
echo "angsdir = "$angsdir""
echo "outputdir = "$outputdir""
echo "ref = "$ref""
echo "anc = "$anc""
echo "pop1List = "$pop1List""
echo "pop2List = "$pop2List""
echo "nIndPop1 = "$nIndPop1""
echo "nIndPop2 = "$nIndPop2""
echo "nPop1 = "$nPop1""
echo "nPop2 = "$nPop2""
echo "minperc = "$minperc""
echo " = "$minIndPop1""
echo "minIndPop2 = "$minIndPop2""
echo "pop1F = "$pop1F""
echo "pop2F = "$pop2F""
echo "glikehood = "$glikehood""
echo "minMapQ = "$minMapQ""
echo "cpu = "$cpu""
echo "regionfile = "$regionfile""
echo "windowsize = "$windowsize""
echo "step = "$step""

######################
##### Compute pop1 sfs
command1="-bam "$pop1List" -out "$outputdir"/"$pop1"_intergenic -doMajorMinor 1 -doMaf 1 -indF "$pop1F" -doSaf 2 -uniqueOnly 0 -anc "$anc" -minMapQ $minMapQ -minQ 20 -nInd $nIndPop1 -minInd $minIndPop1 -baq 1 -ref "$ref" -GL $glikehood -P $cpu -rf $regionfile"
echo $command1
echo 
$angsdir/angsd $command1

command2=""$outputdir"/"$pop1"_intergenic.saf $nPop1 -P $cpu" 
echo $command2
echo
$angsdir/misc/realSFS $command2 > "$outputdir"/"$pop1"_intergenic.sfs

#####################
#### Compute pop2 sfs
command3="-bam "$pop2List" -out "$outputdir"/"$pop2"_intergenic -doMajorMinor 1 -doMaf 1 -indF "$pop2F" -doSaf 2 -uniqueOnly 0 -anc "$anc" -minMapQ $minMapQ -minQ 20 -nInd $nIndPop2 -minInd $minIndPop2 -baq 1 -ref "$ref" -GL $glikehood -P $cpu -rf $regionfile"
echo $command1
echo 
$angsdir/angsd $command3

command4=""$outputdir"/"$pop2"_intergenic.saf $nPop2 -P $cpu" 
echo $command4
echo
$angsdir/misc/realSFS $command4 > "$outputdir"/"$pop2"_intergenic.sfs

####################################
# Next, extract the compressed files
command5=""$outputdir"/"$pop1"_intergenic.saf.pos.gz "
command6=""$outputdir"/"$pop2"_intergenic.saf.pos.gz "
echo gunzip -k $command5
echo
echo gunzip -k $command6
echo
gunzip -k $command5
gunzip -k $command6

####################################################################
# Now we find the positions that occur in both populations using the
# uniq POSIX program
command7=" "$outputdir"/"$pop1"_intergenic.saf.pos "$outputdir"/"$pop2"_intergenic.saf.pos|sort|uniq -d " 
echo cat $command7
echo 
cat "$outputdir"/"$pop1"_intergenic.saf.pos "$outputdir"/"$pop2"_intergenic.saf.pos|sort|uniq -d > "$outputdir"/intersect."$pop1"."$pop2"_intergenic.txt

####################################################################
# Now redo angsd sample allele frequency calculation by conditioning
# on the sites that occur in both populations.
command8=" -bam "$pop1List" -out "$outputdir"/"$pop1"_intergenic_conditioned -doMajorMinor 1 -doMaf 1 -indF "$pop1F" -doSaf 2 -uniqueOnly 0 -anc "$anc" -minMapQ $minMapQ -minQ 20 -nInd $nIndPop1 -minInd $minIndPop1 -baq 1 -ref "$ref" -GL $glikehood -P $cpu -rf $regionfile -sites "$outputdir"/intersect."$pop1"."$pop2"_intergenic.txt"
echo "$angsdir"/angsd $command8
echo 
"$angsdir"/angsd $command8

command9=" -bam "$pop2List" -out "$outputdir"/"$pop2"_intergenic_conditioned -doMajorMinor 1 -doMaf 1 -indF "$pop2F" -doSaf 2 -uniqueOnly 0 -anc "$anc" -minMapQ $minMapQ -minQ 20 -nInd $nIndPop2 -minInd $minIndPop2 -baq 1 -ref "$ref" -GL $glikehood -P $cpu -rf $regionfile -sites "$outputdir"/intersect."$pop1"."$pop2"_intergenic.txt"
echo "$angsdir"/angsd $command9
echo 
"$angsdir"/angsd $command9

####################################################################

N_SITES=$(cut -f 1 -d " " "$outputdir"/intersect."$pop1"."$pop2"_intergenic.txt | wc -l )
echo "$N_SITES"

#########################################################
# Now we estimate the joint sfs using the realSFS program
command10="2dsfs "$outputdir"/"$pop1"_intergenic_conditioned.saf "$outputdir"/"$pop2"_intergenic_conditioned.saf $nPop1 $nPop2 -P $cpu"
echo "$angsdir"/misc/realSFS $command10 
echo 
"$angsdir"/misc/realSFS $command10  > "$outputdir"/2dsfs_intergenic."$pop1"."$pop2".sfs

######################################################
### Do Fst for each pop to pop comparison with 2dsfs out file.
####### For nsites, use number of intersections in intersect.txt. 
#/home/sbhadral/Projects/Rice_project/ngsPopGen/ngsFST -postfiles "$outputdir"/"$pop1"_intergenic_conditioned.saf "$outputdir"/"$pop2"_intergenic_conditioned.saf -priorfile "$outputdir"/2dsfs_intergenic."$pop1"."$pop2".sfs -nind 4 4 -nsites "$N_SITES" -outfile "$outputdir"/"$pop1"."$pop2".fst -verbose 0