#!/bin/bash
FSLDIR=/usr/local/fsl 
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH

SubjectDirectory=$1
arrSize=`ls $1 | wc -l`
echo "Creating anatomical masks for $arrSize subjects from T1w images."
i=0
while [ "$(( i += 1 ))" -le $arrSize ]
do
	zi=$( printf '%02d' "$i")
	bet $1/sub_$zi/anat/sub-"$zi"_T1w.nii.gz ~/Pipeline/Stg3Tmp/sub_$zi/sub-"$zi"_T1bet.nii.gz
done
echo "Anatomical masks created."
