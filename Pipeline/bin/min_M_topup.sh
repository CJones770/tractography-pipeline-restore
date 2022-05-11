#!/bin/bash
# ./M_topup.sh SubjectDirectory e.g., ./M_topup.sh ~/Path_to_Samples 
SubjectDirectory=$1
arrSize=`ls $1 | wc -l`
echo "Beginning topup EPI distorion correction. The number of subjects detected in directory $1 is $arrSize ."
i=0
now=$(date +"%T")
echo "Starting time : $now"
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
topup --imain=/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/AP_PA_TopupInput2Vols.nii.gz --datain=/opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/acquisition_parameters_min.txt --out=/opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDGTopup \
--fout=/opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDGTopup_field --iout=/opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDGTopup_unwarped_images --config=b02b0.cnf -v #--config=/opt/fsl/etc/flirtsch/b02b0.cnf
echo "Subject $zi complete"
now=$(date +"%T")
echo "Current time : $now"
done
echo "Topup completed for $arrSize subjects. Ready for applytopup."
now=$(date +"%T")
echo "Finishing time : $now"

