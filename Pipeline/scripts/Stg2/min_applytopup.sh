#!/bin/bash
FSLDIR=/usr/local/fsl 
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH

SubjectDirectory=$1
root=$2
arrSize=`ls $1 | wc -l`
i=0
echo "Running applytopup for $arrSize subjects"
now=$(date +"%T")
echo "Starting time : $now"
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
applytopup --imain=$2/Pipeline/Stg1Tmp/sub_$zi/d107-AP_DNDG.nii.gz,$2/Pipeline/Stg1Tmp/sub_$zi/d107-PA_DNDG.nii.gz \
--datain=$2/Pipeline/ACQP/sub_$zi/acquisition_parameters_min.txt --inindex=1,2 --topup=$2/Pipeline/Stg2Tmp/sub_$zi/DNDGTopup \
--out=$2/Pipeline/Stg2Tmp/sub_$zi/DNDG_hifi_images --verbose
now=$(date +"%T")
echo "Topup applied to subject $zi : current time is $now"
done
echo "Topup applied to all $arrSize subjects. Ready for brainmask creation."
now=$(date +"%T")
echo "Finishing time : $now"
