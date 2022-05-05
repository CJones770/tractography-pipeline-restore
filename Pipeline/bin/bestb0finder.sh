#!/bin/bash
FSLDIR=/usr/local/fsl 
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH
SubjectDirectory=$1
arrSize=`ls $1 | wc -l`
i=0
j=0
now=$(date +"%T")
#edit 7 to account for a variable number of b0 volumes, and to defer to 7 as a default
echo "Extracting b0 volumes and calculating residuals with respect to the average b0 [mean of 7 volumes] for $arrSize subjects...."
echo "Starting time : $now"
for ((i=1;i<=$arrSize;i++));
do
zi=$( printf '%02d' "$i")
#extract b0 volumes
fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-PA_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_1 0 1
fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-PA_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_2 1 1
fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-PA_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_3 17 1
fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-PA_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_4 33 1
fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-PA_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_5 49 1
fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-PA_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_6 65 1
fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-PA_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_7 81 1
fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-AP_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_1 0 1
fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-AP_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_2 1 1
fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-AP_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_3 17 1
fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-AP_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_4 33 1
fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-AP_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_5 49 1
fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-AP_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_6 65 1
fslroi ~/Pipeline/Stg1Tmp/sub_$zi/d107-AP_DNDG.nii.gz ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_7 81 1
	#average b0 volumes
fslmaths ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_1 -add ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_2 -add ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_3 \
-add ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_4 -add ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_5 -add ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_6 \
-add ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_7 ~/Pipeline/Stg1Tmp/sub_$zi/tPA_sum.nii.gz 
fslmaths ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_1 -add ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_2 -add ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_3 \
-add ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_4 -add ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_5 -add ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_6 \
-add ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_7 ~/Pipeline/Stg1Tmp/sub_$zi/tAP_sum.nii.gz 
fslmaths ~/Pipeline/Stg1Tmp/sub_$zi/tPA_sum.nii.gz -div 7 ~/Pipeline/Stg1Tmp/sub_$zi/tPA_avg.nii.gz
fslmaths ~/Pipeline/Stg1Tmp/sub_$zi/tAP_sum.nii.gz -div 7 ~/Pipeline/Stg1Tmp/sub_$zi/tAP_avg.nii.gz
	for  ((j=1;j<=7;j++));
	do
	xi=$( printf "$j")
	#calculate residuals for all b0s in comparison to average
	fslmaths ~/Pipeline/Stg1Tmp/sub_$zi/tPA_avg.nii.gz -sub ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_$xi ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_"$xi"_r.nii.gz
	fslmaths ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_"$xi"_r.nii.gz -sqr ~/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_"$xi"_rsqr.nii.gz
	fslmaths ~/Pipeline/Stg1Tmp/sub_$zi/tAP_avg.nii.gz -sub ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_$xi ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_"$xi"_r.nii.gz
	fslmaths ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_"$xi"_r.nii.gz -sqr ~/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_"$xi"_rsqr.nii.gz
	done
done
now=$(date +"%T")
echo "Finishing time : $now"

