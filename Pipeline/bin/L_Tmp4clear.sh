#!/bin/bash
SubjectDirectory=$1
zi=$2
echo "Clearing stage 4 temp folder..."
rm -r /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi/*
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi/
rm -r /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/*
rm -r /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/logs/*
rm -r /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/*
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/logs/
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/
echo "stage 4 temp folder cleared for subject $zi"
