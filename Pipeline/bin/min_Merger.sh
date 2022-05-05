#!/bin/bash
FSLDIR=/usr/local/fsl 
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH

SubjectDirectory=$1
arrSize=`ls $1 | wc -l`
echo "Extracting blip-up blip-down 0-Diffusion volumes for $arrSize subjects...."
i=0
now=$(date +"%T")
echo "Starting time : $now"
while [ "$(( i += 1 ))" -le $arrSize ]
do
	zi=$( printf '%02d' "$i")
#extract b0 images in both directions and merge into ~/Stg1Tmp/sub_$zi/AP_PA_b0.nii.gz
	fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-PA_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/PA_b0_0 0 2
	fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-AP_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/AP_b0_0 0 2
echo "Volumes extracted for subject $zi. Now merging...."
	fslmerge -t ~/Pipeline/Stg1Tmp/sub_$zi/min_AP_PA_b0.nii.gz \
~/Pipeline/Stg1Tmp/sub_$zi/AP_b0_0.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/PA_b0_0.nii.gz
echo "Subject $zi processed."
now=$(date +"%T")
echo "Current time : $now"
done
echo "Volumes merged. Ready for topup."
now=$(date +"%T")
echo "Finishing time : $now"


