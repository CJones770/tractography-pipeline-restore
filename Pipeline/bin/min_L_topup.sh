#!/bin/bash
# ./M_topup.sh SubjectDirectory e.g., ./M_topup.sh ~/Path_to_Samples 
SubjectDirectory=$1
zi=$2
echo "Beginning topup EPI distorion correction. The number of subjects detected in directory $1 is $arrSize ."
now=$(date +"%T")
echo "Starting time : $now"
topup --imain=/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/AP_PA_TopupInput2Vols.nii.gz --datain=/opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/acquisition_parameters_min.txt --out=/opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDGTopup \
--fout=/opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDGTopup_field --iout=/opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDGTopup_unwarped_images --config=/usr/local/fsl/etc/flirtsch/b02b0.cnf -v #--config=/opt/fsl/etc/flirtsch/b02b0.cnf
echo "Topup complete for subject $zi"
now=$(date +"%T")
echo "Current time : $now"
echo "Topup completed for subject $zi. Ready for applytopup."
now=$(date +"%T")

