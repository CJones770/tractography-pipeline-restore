#!/bin/bash
FSLDIR=/usr/local/fsl 
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH

SubjectDirectory=$1
XtractOutDir=$2
arrSize=`ls $1 | wc -l`
echo "Preparing to run tractography algorithm for $arrSize subjects. Requires CUDA8.0 compatible hardware and drivers."
i=0
while [ "$(( i += 1 ))" -le $arrSize ]
do
now=$(date +"%T")
echo "Current time : $now"
zi=$( printf '%02d' "$i")
echo "----- Subject ID $zi -----"
xtract -bpx ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_$zi.bedpostX -out $2/sub_$zi/XtractOut_$zi -species HUMAN \
-stdwarp ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/standard2diff_warp.nii.gz ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2standard_warp.nii.gz \
-ref /usr/local/fsl/data/standard/MNI152_T1_1mm_brain ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2standard_warp.nii.gz \
~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/standard2diff_warp.nii.gz -gpu #-ptx_options ~/Pipeline/TractographyOptions/ptx_options.txt #-str ~/Pipeline/scripts/Stg4/structs.txt 
now=$(date +"%T")
echo "Current time : $now"
echo "Tractography complete for subject $zi"
done
now=$(date +"%T")
echo "Finishing time : $now"
#uncomment above to run different tractography parameters, e.g., angular or fiber density stopping thresholds or on a specified set of structures
