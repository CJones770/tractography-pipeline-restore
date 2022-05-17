#!/bin/bash
SubjectDirectory=$1
OutDir3=$2
zi=$3
echo "Copying Stage 3 temp folder contents to $2 "
cp /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/nodif_brain.nii.gz $2/sub_$zi/nodif_brain.nii.gz	
cp /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/nodif_brain_mask.nii.gz $2/sub_$zi/nodif_brain_mask.nii.gz
cp /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/smoothed_nodif_brain.nii.gz $2/sub_$zi/no_dif_brain_smoothed.nii.gz
cp /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/nodif_brain_mask_mask.nii.gz $2/sub_$zi/nodif_brain_binary_mask.nii.gz
cp /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/nodif_brain_mask_smoothed.nii.gz $2/sub_$zi/nodif_brain_mask_smoothed.nii.gz
cp /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/nodif_brain_mask_smoothed_mask.nii.gz $2/sub_$zi/nodif_brain_binary_mask_smoothed.nii.gz
cp /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/sub-"$zi"_T1bet.nii.gz $2/sub_$zi/T1_anat_mask.nii.gz
echo "Stage 3 temp folder contents copied for $arrSize subjects"