#!/bin/bash
SubjectDirectory=$1
#Define Number of Subjects as an Array
arrSize=`ls $1 | wc -l`
echo "Denoising images for $arrSize subjects using 'dwidenoise' from mrtrix3"
i=0
now=$(date +"%T")
echo "Starting time : $now"
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
#denoise for all subjects in specified directory
dwidenoise $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_PA_dwi.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/107-PA_denoised.nii -noise /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/PA_noise.nii.gz
dwidenoise $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_AP_dwi.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/107-AP_denoised.nii -noise /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/AP_noise.nii.gz
now=$(date +"%T")
echo "Subject $zi denoised: Current time is $now" 
mrcalc $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_PA_dwi.nii.gz \
/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/107-PA_denoised.nii -subtract \
/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/PA_residual.nii.gz
mrcalc $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_AP_dwi.nii.gz \
/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/107-AP_denoised.nii -subtract \
/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/AP_residual.nii.gz
now=$(date +"%T")
echo "Residuals stored for subject $zi: Current time is $now"
done
now=$(date +"%T")
echo "Finishing time : $now"


