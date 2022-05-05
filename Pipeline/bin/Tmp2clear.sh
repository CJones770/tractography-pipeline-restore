#!/bin/bash
SubjectDirectory=$1
arrSize=`ls $1 | wc -l`
i=0
echo "Clearing stage 2 temp folder..."
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
rm -r ~/Pipeline/Stg2Tmp/sub_$zi/*
rmdir ~/Pipeline/Stg2Tmp/sub_$zi/
rmdir ~/Pipeline/Stg2Tmp/
done
echo "stage 2 temp folder cleared"
