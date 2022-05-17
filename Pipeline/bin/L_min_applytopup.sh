#!/bin/bash
SubjectDirectory=$1
zi=$2
echo "Running applytopup for subject $zi"
now=$(date +"%T")
echo "Starting time : $now"
applytopup --imain=/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/d107-AP_DNDG.nii.gz,/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/d107-PA_DNDG.nii.gz \
--datain=/opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/acquisition_parameters_min.txt --inindex=1,2 --topup=/opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDGTopup \
--out=/opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDG_hifi_images --verbose
now=$(date +"%T")
echo "Topup applied to subject $zi : current time is $now"
echo "Ready for brainmask creation."

