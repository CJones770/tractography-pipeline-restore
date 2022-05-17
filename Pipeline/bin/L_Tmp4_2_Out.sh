#!/bin/bash
SubjectDirectory=$1
OutDir4=$2
zi=$3
echo "Copying stage 4 temp folder contents to $2 "
mkdir $2/sub_$zi/4o/BedpostX_"$zi"/
mkdir $2/sub_$zi/4o/BedpostX_"$zi".bedpostX/
mkdir $2/sub_$zi/4o/BedpostX_"$zi".bedpostX/xfms/
mkdir $2/sub_$zi/4o/BedpostX_"$zi".bedpostX/logs/
mkdir $2/sub_$zi/4o/BedpostX_"$zi".bedpostX/logs/logs_gpu/
mkdir $2/sub_$zi/4o/BedpostX_"$zi".bedpostX/xfms/test_warps
cp /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi"/* $2/sub_$zi/4o/BedpostX_"$zi"/
cp /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/* $2/sub_$zi/4o/BedpostX_"$zi".bedpostX/
cp /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/* $2/sub_$zi/4o/BedpostX_"$zi".bedpostX/xfms/
cp /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/logs/* $2/sub_$zi/4o/BedpostX_"$zi".bedpostX/logs/
cp /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/logs/logs_gpu/* $2/sub_$zi/4o/BedpostX_"$zi".bedpostX/logs/logs_gpu/
cp /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/test_warps/* $2/sub_$zi/4o/BedpostX_"$zi".bedpostX/xfms/test_warps/
echo "Stage 4 temp folder contents copied for subject $zi."
