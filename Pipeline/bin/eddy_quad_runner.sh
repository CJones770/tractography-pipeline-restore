#!/bin/bash

SubjectDirectory=$1
Stg2Out=$2
arrSize=`ls $1 | wc -l`
i=0
echo "Generating quality control reports using FSL's eddy_quad..."
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
eddy_quad ~/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG -idx ~/Pipeline/ACQP/my_index -par ~/Pipeline/ACQP/sub_$zi/acquisition_parameters_min.txt -m ~/Pipeline/Stg2Tmp/sub_$zi/DNDG_brain_mask_output.nii.gz -b ~/Pipeline/ACQP/sub_$zi/bval -o $2/sub_$zi/QC_report -f ~/Pipeline/Stg2Tmp/sub_$zi/DNDGTopup_field.nii.gz
done
echo "Quality control reports generated and stored in directory $Stg2Out"
