#!/bin/bash
mrtrixDIR=/usr/local/anaconda3/pkgs/mrtrix3-3.0.2-h6bb024c_0
PATH="$(pwd)/bin:$PATH"
export mrtrixDIR PATH

SubjectDirectory=$1
arrSize=`ls $1 | wc -l`
echo "Correcting Gibbs Ringing for $arrSize subjects using 'mrdegibbs' from mrtrix3"
i=0
now=$(date +"%T")
echo "Starting time : $now"
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
mrdegibbs /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/107-AP_denoised.nii /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/d107-AP_DNDG.nii.gz	
mrdegibbs /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/107-PA_denoised.nii /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/d107-PA_DNDG.nii.gz
now=$(date +"%T")
echo "Subject $zi degibbsed: Current time is $now"
done
now=$(date +"%T")
echo "Finishing time : $now"
