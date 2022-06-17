#!/bin/bash
SubjectDirectory=$1
zi=$2
echo "Clearing stage 2 temp folder..."
rm -r /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/*
rmdir /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/
echo "stage 2 temp folder cleared for subject $zi"
