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
mkdir /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp
mkdir /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp
mkdir /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp
mkdir /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp
mkdir /opt/Pipeline/Pipeline/Pipeline/$1
mkdir /opt/Pipeline/Pipeline/Pipeline/$2
mkdir /opt/Pipeline/Pipeline/Pipeline/$3
mkdir /opt/Pipeline/Pipeline/Pipeline/$4
mkdir /opt/Pipeline/Pipeline/Pipeline/$5
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
mkdir /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/
mkdir /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/
mkdir /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/ 
mkdir /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/
mkdir /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/
mkdir /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi/
mkdir /opt/Pipeline/Pipeline/Pipeline/$1/sub_$zi/  #denoised, degibbsed, merged images
mkdir /opt/Pipeline/Pipeline/Pipeline/$2/sub_$zi/  #outputs of topup and eddy [corrected for EPI distortions, eddy currents, and subject movement]
mkdir /opt/Pipeline/Pipeline/Pipeline/$3/sub_$zi/  #Anatomical and 0-Diffusion masks and 'nodif_brain.nii.gz'
mkdir /opt/Pipeline/Pipeline/Pipeline/$4/sub_$zi/  #BedpostX outputs: Diffusion tensor estimates [Fractional Anisotropy and Mean Diffusivity]	
mkdir /opt/Pipeline/Pipeline/Pipeline/$5/sub_$zi/ #Tractography outputs [fiber density norm, length, etc.]
done
echo "Directories initialized"

