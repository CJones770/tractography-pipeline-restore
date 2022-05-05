#!/bin/bash
Stage1outdir=$1
Stage2outdir=$2
Stage3outdir=$3
Stage4outdir=$4
Xtractoutdir=$5
SubjectDirectory=$6
arrSize=`ls $6 | wc -l`
i=0
echo "Initializing Directories for $arrSize subjects."
mkdir ~/Pipeline/Stg1Tmp
mkdir ~/Pipeline/Stg2Tmp
mkdir ~/Pipeline/Stg3Tmp
mkdir ~/Pipeline/Stg4Tmp
mkdir $1
mkdir $2
mkdir $3
mkdir $4
mkdir $5
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
mkdir ~/Pipeline/ACQP/sub_$zi/
mkdir ~/Pipeline/Stg1Tmp/sub_$zi/
mkdir ~/Pipeline/Stg2Tmp/sub_$zi/ 
mkdir ~/Pipeline/Stg3Tmp/sub_$zi/
mkdir ~/Pipeline/Stg4Tmp/sub_$zi/
mkdir ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi/
mkdir $1/sub_$zi/  #denoised, degibbsed, merged images
mkdir $2/sub_$zi/  #outputs of topup and eddy [corrected for EPI distortions, eddy currents, and subject movement]
mkdir $3/sub_$zi/  #Anatomical and 0-Diffusion masks and 'nodif_brain.nii.gz'
mkdir $4/sub_$zi/  #BedpostX outputs: Diffusion tensor estimates [Fractional Anisotropy and Mean Diffusivity]	
mkdir $5/sub_$zi/ #Tractography outputs [fiber density norm, length, etc.]
done
echo "Directories initialized"


