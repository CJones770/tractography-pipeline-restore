#!/bin/bash
SubjectDirectory=$1
zi=$2
#Define Number of Subjects as an Array
arrSize=`ls $1 | wc -l`
echo "Denoising images for $arrSize subjects using 'dwidenoise' from mrtrix3"
i=0
now=$(date +"%T")
echo "Starting time : $now"
#denoise for all subjects in specified directory
dwidenoise $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_PA_dwi.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/107-PA_denoised.nii -noise /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/PA_noise.nii.gz
dwidenoise $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_AP_dwi.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/107-AP_denoised.nii -noise /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/AP_noise.nii.gz
now=$(date +"%T")
echo "Subject $zi denoised: Current time is $now" 


