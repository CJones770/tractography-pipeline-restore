#!/bin/bash
SubjectDirectory=$1
arrSize=`ls $1 | wc -l`
i=0
echo "Clearing stage 4 temp folder..."
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
rm -r /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi/*
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi/
rm -r /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/*
rm -r /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/logs/*
rm -r /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/*
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/logs/
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/
done
echo "stage 4 temp folder cleared"
