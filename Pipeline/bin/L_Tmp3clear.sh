#!/bin/bash
SubjectDirectory=$1
zi=$2
echo "Clearing stage 3 temp folder..."
rm -r /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/*
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/
echo "stage 3 temp folder cleared for subject $zi"
