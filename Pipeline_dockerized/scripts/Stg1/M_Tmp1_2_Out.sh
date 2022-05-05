#!/bin/bash

SubjectDirectory=$1

arrSize=`ls $1 | wc -l`
i=0
echo "Copying Stage 1 Temp folder contents to $2 ..."
while [ "$(( i += 1 ))" -le $arrSize ]
do
	zi=$( printf '%02d' "$i")
	cp ~/Pipeline/Stg1Tmp/sub_$zi/PA_residual.nii.gz $2/sub_$zi/PA_residual.nii.gz	
	cp ~/Pipeline/Stg1Tmp/sub_$zi/AP_residual.nii.gz $2/sub_$zi/AP_residual.nii.gz
	cp ~/Pipeline/Stg1Tmp/sub_$zi/d107-AP_DNDG.nii.gz $2/sub_$zi/AP_DNDG.nii.gz
	cp ~/Pipeline/Stg1Tmp/sub_$zi/d107-PA_DNDG.nii.gz $2/sub_$zi/PA_DNDG.nii.gz
	cp ~/Pipeline/Stg1Tmp/sub_$zi/AP_PA_TopupInput2Vols.nii.gz $2/sub_$zi/merged_best_b0.nii.gz
done
echo "Stage 1 temp folder contents copied to $2 for $arrSize subjects"