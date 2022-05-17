#!/bin/bash
SubjectDirectory=$1
zi=$2
arrSize=`ls $1 | wc -l`
echo "Correcting Gibbs Ringing for $arrSize subjects using 'mrdegibbs' from mrtrix3"
now=$(date +"%T")
echo "Starting time : $now"
mrdegibbs /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/107-AP_denoised.nii /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/d107-AP_DNDG.nii.gz	
mrdegibbs /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/107-PA_denoised.nii /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/d107-PA_DNDG.nii.gz
now=$(date +"%T")
echo "Subject $zi degibbsed: Current time is $now"
now=$(date +"%T")
echo "Finishing time : $now"
