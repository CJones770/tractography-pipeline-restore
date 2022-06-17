#!/bin/bash
SubjectDirectory=$1
arrSize=`ls $1 | wc -l`
i=0
echo "Clearing pipeline of temporarily stored values..."
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
rm -r /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/*
rmdir /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/
done
echo "Values removed: Pipeline ready for next cohort"
