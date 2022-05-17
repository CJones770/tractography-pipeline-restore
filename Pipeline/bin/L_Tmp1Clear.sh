#!/bin/bash
SubjectDirectory=$1
zi=$2
echo "Clearing stage 1 temp folder..."
rm -r /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/*
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/
rm -r /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/*
echo "stage 1 temp folder cleared for subject $zi"
