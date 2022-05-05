#!/bin/bash
FSLDIR=/usr/local/fsl 
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH

SubjectDirectory=$1
arrSize=`ls $1 | wc -l`
echo "Preparing to estimate Diffusor Tensors for $arrSize subjects. Requires CUDA8.0 compatible hardware and drivers."
i=0
now=$(date +"%T")
echo "Starting time : $now"
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
cp ~/Pipeline/ACQP/sub_$zi/bvec ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi/bvecs
cp ~/Pipeline/ACQP/sub_$zi/bval ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi/bvals
cp ~/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG.eddy_outlier_free_data.nii.gz ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi/data.nii.gz
cp ~/Pipeline/Stg3Tmp/sub_$zi/nodif_brain_mask_smoothed_mask.nii.gz ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi/nodif_brain_mask.nii.gz
cp ~/Pipeline/Stg3Tmp/sub_$zi/nodif_brain.nii.gz ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi/nodif_brain.nii.gz
echo "Subject $zi's BedpostX directory was successfully populated. Beginning estimations."
bedpostx_gpu ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi --rician
echo "Estimations complete for subject $zi."
now=$(date +"%T")
echo "Current time : $now"
done
echo "Tensor estimates complete for all $arrSize subjects"
now=$(date +"%T")
echo "Finishing time : $now"
