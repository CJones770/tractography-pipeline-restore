#!/bin/bash
FSLDIR=/usr/local/fsl 
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH

SubjectDirectory=$1
arrSize=`ls $1 | wc -l`
echo "Creating brain masks for $arrSize subjects"
i=0
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
bet ~/Pipeline/Stg2Tmp/sub_$zi/DNDG_hifi_images.nii.gz ~/Pipeline/Stg2Tmp/sub_$zi/DNDG_brain_mask_output
done
echo "masks generated for $arrSize subjects. Ready for Eddy."
