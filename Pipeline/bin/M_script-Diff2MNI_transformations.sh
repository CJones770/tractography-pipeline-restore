#!/bin/bash
#specify full path to subject directory e.g., /home/user/SubjectDirectory
#specify root as follows: /home/user
SubjectDirectory=$1
calculate_transf () {
  # LINEAR TRANSFOMATION FROM DIFFUSION TO T1 SPACE
  echo "LINEAR TRANSFOMATION FROM DIFFUSION TO T1 SPACE"
  /opt/fsl/bin/flirt -in /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/nodif_brain \
  -ref /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/sub-"$zi"_T1bet.nii.gz \
  -omat /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2str.mat \
  -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -cost corratio

  # INVERSE LINEAR TRANSFOMATION FROM T1 SPACE TO DIFFUSION
  echo "INVERSE LINEAR TRANSFOMATION FROM T1 SPACE TO DIFFUSION"
  /opt/fsl/bin/convert_xfm -omat /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2diff.mat \
-inverse /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2str.mat 

  # LINEAR TRANSFOMATION FROM T1 SPACE TO MNI (TEMPLATE)
  echo "LINEAR TRANSFOMATION FROM T1 SPACE TO MNI (TEMPLATE)"
  /opt/fsl/bin/flirt -in /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/sub-"$zi"_T1bet.nii.gz \
  -ref /opt/fsl/data/standard/MNI152_T1_2mm_brain \
  -omat /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2standard.mat \
  -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 -cost corratio

  # INVERSE LINEAR TRANSFORMATION FROM MNI TO T1 SPACE
  echo "INVERSE LINEAR TRANSFORMATION FROM MNI TO T1 SPACE"
  /opt/fsl/bin/convert_xfm -omat /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/standard2str.mat \
  -inverse /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2standard.mat

  # LINEAR TRANSFORMATION FROM DIFFUSION TO MNI (DIFF TO T1 --> T1 TO MNI )
  echo "LINEAR TRANSFORMATION FROM DIFFUSION TO MNI (DIFF TO T1 --> T1 TO MNI )"
  /opt/fsl/bin/convert_xfm -omat /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2standard.mat \
  -concat /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2standard.mat /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2str.mat

  # INVERSE LINEAR TRANSFORMATION FROM MNI TO DIFFUSION (DIFF TO T1 --> T1 TO MNI )
  echo "INVERSE LINEAR TRANSFORMATION FROM MNI TO DIFFUSION (DIFF TO T1 --> T1 TO MNI )"
  /opt/fsl/bin/convert_xfm -omat /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/standard2diff.mat \
  -inverse /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2standard.mat 

  # NON-LINEAR TRANSFORMATION FROM T1 SPACE TO MNI
  echo "NON-LINEAR TRANSFORMATION FROM T1 SPACE TO MNI"
  /opt/fsl/bin/fnirt --in=$1/sub_$zi/anat/sub-"$zi"_T1w.nii.gz \
--aff=/opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2standard.mat \
--cout=/opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2standard_warp \
--config=T1_2_MNI152_2mm

  # INVERSE NON-LINEAR TRANSFORMATION FROM MNI TO T1 SPACE
  echo "INVERSE NON-LINEAR TRANSFORMATION FROM MNI TO T1 SPACE"
  /opt/fsl/bin/invwarp -w /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2standard_warp \
  -o /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/standard2str_warp \
  -r /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/sub-"$zi"_T1bet.nii.gz

  # WARP FROM DIFFUSION TO MNI
  echo "WARP FROM DIFFUSION TO MNI"
  /opt/fsl/bin/convertwarp -o /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2standard_warp \
  -r /opt/fsl/data/standard/MNI152_T1_2mm -m /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2str.mat \
  -w /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2standard_warp

  # WARP FROM MNI TO DIFFUSION
  echo "WARP FROM MNI TO DIFFUSION"
  /opt/fsl/bin/convertwarp -o /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/standard2diff_warp \
  -r /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/nodif_brain_mask \
  -w /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/standard2str_warp \
  --postmat=/opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2diff.mat
}

apply_transf (){

  #T1 TO TEMPLATE (LINEAR + NON-LINEAR)
  echo "T1 TO TEMPLATE (LINEAR + NON-LINEAR)"
  applywarp -i $1/sub_$zi/anat/sub-"$zi"_T1w.nii.gz \
  -w /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2standard_warp.nii.gz \
  -r /opt/fsl/data/standard/MNI152_T1_2mm.nii.gz \
  -o /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/test_warps/t1_in_MNI

  #T1 BETTED TO TEMPLATE (LINEAR + NON-LINEAR)
  echo "T1 BETTED TO TEMPLATE (LINEAR + NON-LINEAR)"
  applywarp -i /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/sub-"$zi"_T1bet.nii.gz \
  -w /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2standard_warp.nii.gz \
  -r /opt/fsl/data/standard/MNI152_T1_2mm.nii.gz \
  -o /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/test_warps/t1_brain_in_MNI

  #T1 TO TEMPLATE (LINEAR) 2mm and 1mm
  echo "T1 TO TEMPLATE (LINEAR) 2mm and 1mm"
  flirt -in $1/sub_$zi/anat/sub-"$zi"_T1w.nii.gz \
  -ref /opt/fsl/data/standard/MNI152_T1_2mm.nii.gz \
  -applyxfm -init /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2standard.mat \
  -out /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/test_warps/t1_linear_to_MNI_2mm

  flirt -in $1/sub_$zi/anat/sub-"$zi"_T1w.nii.gz \
  -ref /opt/fsl/data/standard/MNI152_T1_1mm.nii.gz \
  -applyxfm -init /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2standard.mat \
  -out /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/test_warps/t1_linear_to_MNI_1mm

  #T1 BETTED TO TEMPLATE (LINEAR) 2mm and 1mm
  echo "T1 BETTED TO TEMPLATE (LINEAR) 2mm and 1mm"
  flirt -in /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/sub-"$zi"_T1bet.nii.gz \
  -ref /opt/fsl/data/standard/MNI152_T1_2mm.nii.gz \
  -applyxfm -init /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2standard.mat \
  -out /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/test_warps/t1_brain_linear_to_MNI_2mm

  flirt -in /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/sub-"$zi"_T1bet.nii.gz \
  -ref /opt/fsl/data/standard/MNI152_T1_1mm.nii.gz \
  -applyxfm -init /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/str2standard.mat \
  -out /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/test_warps/t1_brain_linear_to_MNI_1mm

  #DIFFUSION TO T1 (LINEAR)
  echo "DIFFUSION TO T1 (LINEAR)"
  flirt -in /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/nodif_brain.nii.gz \
-ref $1/sub_$zi/anat/sub-"$zi"_T1w.nii.gz \
-init /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2str.mat \
-out /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/test_warps/diff_to_T1

  #DIFFUSION TO T1 (LINEAR)
  echo "DIFFUSION TO T1 (LINEAR)"
  flirt -in /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/nodif_brain.nii.gz \
-ref /opt/Pipeline/Pipeline/Pipeline/Stg3Tmp/sub_$zi/sub-"$zi"_T1bet.nii.gz \
-applyxfm -init /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2str.mat \
-out /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/test_warps/diff_to_T1_brain


  #DIFFUSION TO TEMPLATE (LINEAR + NON-LINEAR)
  echo "DIFFUSION TO TEMPLATE (LINEAR + NON-LINEAR)"
  applywarp -i /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/nodif_brain.nii.gz \
  -w /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2standard_warp.nii.gz \
  -r /opt/fsl/data/standard/MNI152_T1_2mm.nii.gz \
  -o /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/test_warps/nodif_brain_in_MNI
}

arrSize=`ls $1 | wc -l`
i=0
now=$(date +"%T")
echo "Starting time : $now"
echo "Running registration for $arrSize subjects...."
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
cp /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi"/nodif_brain.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/nodif_brain.nii.gz
echo "----- Subject ID $zi -----"
echo "Calculating transformations...."

now=$(date +"%T")
echo "Current time : $now"
calculate_transf $1
echo ""
echo "Tranforming Files ...."

mkdir -p /opt/Pipeline/Pipeline/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/test_warps #$session/BEDPOSTX.bedpostX/xfms/test_warps

now=$(date +"%T")
echo "Current time : $now"
apply_transf $1
done

now=$(date +"%T")
echo "Finishing time : $now"


