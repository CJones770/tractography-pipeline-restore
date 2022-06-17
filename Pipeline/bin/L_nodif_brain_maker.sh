#!/bin/bash
SubjectDirectory=$1
zi=$2
echo "Generating nodif_brain images and masks for subject $zi"
fslroi /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG.eddy_outlier_free_data.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i1 0 1
fslroi /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG.eddy_outlier_free_data.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i2 1 1
fslroi /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG.eddy_outlier_free_data.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i3 17 1
fslroi /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG.eddy_outlier_free_data.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i4 33 1
fslroi /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG.eddy_outlier_free_data.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i5 49 1
fslroi /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG.eddy_outlier_free_data.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i6 65 1
fslroi /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG.eddy_outlier_free_data.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i7 81 1
fslroi /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG.eddy_outlier_free_data.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i8 99 1
fslroi /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG.eddy_outlier_free_data.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i9 100 1
fslroi /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG.eddy_outlier_free_data.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i10 101 1
fslmaths /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i1 -add /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i2 \
-add /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i3 -add /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i4 \
-add /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i5 -add /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i6 \
-add /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i7 -add /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i8 \
-add /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i9 -add /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/i10 \
/opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/final_sum 
fslmaths /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/final_sum -div 10 /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/nodif_brain.nii.gz
bet /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/nodif_brain.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/nodif_brain_mask -m
echo "Images and masks generated for subject $zi."
