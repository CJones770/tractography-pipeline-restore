#!/bin/bash
FSLDIR=/usr/local/fsl 
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH

SubjectDirectory=$1
arrSize=`ls $1 | wc -l`
echo "Smoothing eddy corrected output for $arrSize subjects"
i=0
while [ "$(( i += 1 ))" -le $arrSize ]
do
	zi=$( printf '%02d' "$i")
	fslmaths ~/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG.eddy_outlier_free_data.nii.gz -kernel 3D -fmean ~/Pipeline/Stg3Tmp/sub_$zi/SmoothedEddy.nii.gz
done
echo "Images smoothed."
