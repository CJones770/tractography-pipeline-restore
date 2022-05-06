#!/bin/bash
SubjectDirectory=$1
OutDir2=$2
arrSize=`ls $1 | wc -l`
i=0
echo "Copying Stage 2 Temp folder contents to $2 "
while [ "$(( i += 1 ))" -le $arrSize ]
do
	zi=$( printf '%02d' "$i")
	cp /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/* $2/sub_$zi/
done
echo "Stage 2 temp folder contents copied for $arrSize subjects"
