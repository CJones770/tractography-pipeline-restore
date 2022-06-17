#!/bin/bash
SubjectDirectory=$1
zi=$2
echo "Denoising images for subject $zi using 'dwidenoise' from mrtrix3"
now=$(date +"%T")
echo "Starting time : $now"
#denoise for current subject zi in specified subject directory
dwidenoise $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_PA_dwi.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/107-PA_denoised.nii -noise /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/PA_noise.nii.gz
dwidenoise $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_AP_dwi.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/107-AP_denoised.nii -noise /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/AP_noise.nii.gz
now=$(date +"%T")
echo "Subject $zi denoised: Current time is $now" 


