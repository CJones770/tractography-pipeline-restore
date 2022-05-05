#!/bin/bash

SubjectDirectory=$1
Stg2Out=$2
Stg4Out=$3
arrSize=`ls $1 | wc -l`
i=0
echo "Generating text file list of quality control reports..."
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
$2/sub_$zi/QC_report >> ~/Pipeline/Stg4Tmp/QC_sublist.txt
done
echo "text file generated"
echo "Generating subject wise quality report"
eddy_squad ~/Pipeline/Stg4Tmp/QC_sublist.txt -o $3/SubjectWise_QC_Report
echo "quality report generated and stored in $Stg4Out"
