#!/bin/bash
SubjectDirectory=$1
zi=$2
echo "Creating anatomical masks for subject $zi using their T1w images."
bet $1/sub_$zi/anat/sub-"$zi"_T1w.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/sub-"$zi"_T1bet.nii.gz
echo "Anatomical masks created."
