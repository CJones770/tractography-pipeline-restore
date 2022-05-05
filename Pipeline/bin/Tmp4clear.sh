#!/bin/bash

SubjectDirectory=$1

arrSize=`ls $1 | wc -l`
i=0
echo "Clearing stage 4 temp folder..."
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
rm -r ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi/*
rmdir ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi/
rm -r ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/*
rm -r ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/logs/*
rm -r ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/*
rmdir ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/
rmdir ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/logs/
rmdir ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/
rmdir ~/Pipeline/Stg4Tmp/sub_$zi/
rmdir ~/Pipeline/Stg4Tmp/
done
echo "stage 4 temp folder cleared"
