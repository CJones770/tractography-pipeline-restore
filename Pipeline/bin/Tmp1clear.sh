#!/bin/bash

SubjectDirectory=$1

arrSize=`ls $1 | wc -l`
i=0
echo "Clearing stage 1 temp folder..."
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
rm /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/*
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/
done
echo "stage 1 temp folder cleared"
