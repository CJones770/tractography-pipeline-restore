#!/bin/bash
SubjectDirectory=$1
Stg2Out=$2
arrSize=`ls $1 | wc -l`
i=0
echo "Generating quality control reports using FSL's eddy_quad..."
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
eddy_quad /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG -idx /opt/Pipeline/Pipeline/Pipeline/ACQP/my_index -par /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/acquisition_parameters_min.txt -m /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDG_brain_mask_output.nii.gz -b /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/bval -o /$2/sub_$zi/QC_report -f /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDGTopup_field.nii.gz
done
echo "Quality control reports generated and stored in directory $Stg2Out"
