#!/bin/bash
SubjectDirectory=$1
OutDir2=$2
zi=$3
echo "Copying Stage 2 Temp folder contents to $2 "
cp /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/* $2/sub_$zi/
echo "Stage 2 temp folder contents copied for $arrSize subjects"
