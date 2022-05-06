#!/bin/bash
SubjectDirectory=$1
OutDir4=$2
arrSize=`ls $1 | wc -l`
i=0
echo "Copying stage 4 temp folder contents to $2 "
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
mkdir /$2/sub_$zi/BedpostX_"$zi"/
mkdir /$2/sub_$zi/BedpostX_"$zi".bedpostX/
mkdir /$2/sub_$zi/BedpostX_"$zi".bedpostX/xfms/
mkdir /$2/sub_$zi/BedpostX_"$zi".bedpostX/logs/
mkdir /$2/sub_$zi/BedpostX_"$zi".bedpostX/xfms/test_warps
cp /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi"/* /$2/sub_$zi/BedpostX_"$zi"/
cp /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/* /$2/sub_$zi/BedpostX_"$zi".bedpostX/
cp /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/* /$2/sub_$zi/BedpostX_"$zi".bedpostX/xfms/
cp /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/logs/* /$2/sub_$zi/BedpostX_"$zi".bedpostX/logs/
cp /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/test_warps/* /$2/sub_$zi/BedpostX_"$zi".bedpostX/xfms/test_warps/
done
echo "Stage 4 temp folder contents copied for $arrSize subjects."
