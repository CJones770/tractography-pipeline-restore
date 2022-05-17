#!/bin/bash
SubjectDirectory=$1
zi=$2
echo "Smoothing eddy corrected output for $arrSize subjects"
fslmaths /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG.eddy_outlier_free_data.nii.gz -kernel 3D -fmean /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/SmoothedEddy.nii.gz
echo "Images smoothed."
