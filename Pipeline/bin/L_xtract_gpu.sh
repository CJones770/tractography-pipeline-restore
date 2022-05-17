#!/bin/bash
SubjectDirectory=$1
XtractOutDir=$2
zi=$3
echo "Preparing to run tractography algorithm for subject $zi. Requires CUDA8.0 compatible hardware and drivers."
now=$(date +"%T")
echo "Current time : $now"
echo "----- Subject ID $zi -----"
xtract -bpx /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi.bedpostX -out $2/sub_$zi/XtractOut_$zi -species HUMAN \
-stdwarp /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/standard2diff_warp.nii.gz \
/opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2standard_warp.nii.gz \
-ref /usr/local/fsl/data/standard/MNI152_T1_1mm_brain /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2standard_warp.nii.gz \
/opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/standard2diff_warp.nii.gz -gpu #-ptx_options [path-to]/Pipeline/TractographyOptions/ptx_options.txt #-str [path to specific structures] e.g., ~/Pipeline/scripts/Stg4/structs.txt 
now=$(date +"%T")
echo "Current time : $now"
echo "Tractography complete for subject $zi"

