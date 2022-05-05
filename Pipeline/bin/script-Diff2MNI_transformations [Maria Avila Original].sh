#!/bin/bash

arrSize=`ls ~/P_samples | wc -l`
i=0
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
calculate_transf () {
  # LINEAR TRANSFOMATION FROM DIFFUSION TO T1 SPACE
  echo "LINEAR TRANSFOMATION FROM DIFFUSION TO T1 SPACE"
  /usr/local/fsl/bin/flirt -in ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/nodif_brain \ #$session/BEDPOSTX.bedpostX/nodif_brain \
  -ref ~/P_samples/sub_$zi/anat/sub_"$zi"_T1w.nii.gz \ #$session/T1/wT1_brain_spm.nii.gz \
  -omat ~/Pipeline/Stg4Tmp/sub_$zi/BedpostX_"$zi".bedpostX/xfms/diff2str.mat #$session/BEDPOSTX.bedpostX/xfms/diff2str.mat \
  -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -cost corratio

  # INVERSE LINEAR TRANSFOMATION FROM T1 SPACE TO DIFFUSION
  echo "INVERSE LINEAR TRANSFOMATION FROM T1 SPACE TO DIFFUSION"
  /usr/local/fsl/bin/convert_xfm -omat $session/BEDPOSTX.bedpostX/xfms/str2diff.mat \
  -inverse $session/BEDPOSTX.bedpostX/xfms/diff2str.mat

  # LINEAR TRANSFOMATION FROM T1 SPACE TO MNI (TEMPLATE)
  echo "LINEAR TRANSFOMATION FROM T1 SPACE TO MNI (TEMPLATE)"
  /usr/local/fsl/bin/flirt -in $session/T1/wT1_brain_spm.nii.gz \
  -ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain \
  -omat $session/BEDPOSTX.bedpostX/xfms/str2standard.mat \
  -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 -cost corratio

  # INVERSE LINEAR TRANSFORMATION FROM MNI TO T1 SPACE
  echo "INVERSE LINEAR TRANSFORMATION FROM MNI TO T1 SPACE"
  /usr/local/fsl/bin/convert_xfm -omat $session/BEDPOSTX.bedpostX/xfms/standard2str.mat \
  -inverse $session/BEDPOSTX.bedpostX/xfms/str2standard.mat

  # LINEAR TRANSFORMATION FROM DIFFUSION TO MNI (DIFF TO T1 --> T1 TO MNI )
  echo "LINEAR TRANSFORMATION FROM DIFFUSION TO MNI (DIFF TO T1 --> T1 TO MNI )"
  /usr/local/fsl/bin/convert_xfm -omat $session/BEDPOSTX.bedpostX/xfms/diff2standard.mat \
  -concat $session/BEDPOSTX.bedpostX/xfms/str2standard.mat $session/BEDPOSTX.bedpostX/xfms/diff2str.mat

  # INVERSE LINEAR TRANSFORMATION FROM MNI TO DIFFUSION (DIFF TO T1 --> T1 TO MNI )
  echo "INVERSE LINEAR TRANSFORMATION FROM MNI TO DIFFUSION (DIFF TO T1 --> T1 TO MNI )"
  /usr/local/fsl/bin/convert_xfm -omat $session/BEDPOSTX.bedpostX/xfms/standard2diff.mat \
  -inverse $session/BEDPOSTX.bedpostX/xfms/diff2standard.mat

  # NON-LINEAR TRANSFORMATION FROM T1 SPACE TO MNI
  echo "NON-LINEAR TRANSFORMATION FROM T1 SPACE TO MNI"
  /usr/local/fsl/bin/fnirt --in=$session/T1/wT1.nii --aff=$session/BEDPOSTX.bedpostX/xfms/str2standard.mat \
  --cout=$session/BEDPOSTX.bedpostX/xfms/str2standard_warp --config=T1_2_MNI152_2mm

  # INVERSE NON-LINEAR TRANSFORMATION FROM MNI TO T1 SPACE
  echo "INVERSE NON-LINEAR TRANSFORMATION FROM MNI TO T1 SPACE"
  /usr/local/fsl/bin/invwarp -w $session/BEDPOSTX.bedpostX/xfms/str2standard_warp \
  -o $session/BEDPOSTX.bedpostX/xfms/standard2str_warp \
  -r $session/T1/wT1_brain_spm.nii.gz

  # WARP FROM DIFFUSION TO MNI
  echo "WARP FROM DIFFUSION TO MNI"
  /usr/local/fsl/bin/convertwarp -o $session/BEDPOSTX.bedpostX/xfms/diff2standard_warp \
  -r /usr/local/fsl/data/standard/MNI152_T1_2mm -m $session/BEDPOSTX.bedpostX/xfms/diff2str.mat \
  -w $session/BEDPOSTX.bedpostX/xfms/str2standard_warp

  # WARP FROM MNI TO DIFFUSION
  echo "WARP FROM MNI TO DIFFUSION"
  /usr/local/fsl/bin/convertwarp -o $session/BEDPOSTX.bedpostX/xfms/standard2diff_warp \
  -r $session/BEDPOSTX.bedpostX/nodif_brain_mask \
  -w $session/BEDPOSTX.bedpostX/xfms/standard2str_warp \
  --postmat=$session/BEDPOSTX.bedpostX/xfms/str2diff.mat
}

apply_transf (){

  #T1 TO TEMPLATE (LINEAR + NON-LINEAR)
  echo "T1 TO TEMPLATE (LINEAR + NON-LINEAR)"
  applywarp -i $session/T1/wT1.nii \
  -w $session/BEDPOSTX.bedpostX/xfms/str2standard_warp.nii.gz \
  -r /usr/local/fsl/data/standard/MNI152_T1_2mm.nii.gz \
  -o $session/BEDPOSTX.bedpostX/xfms/test_warps/t1_in_MNI

  #T1 BETTED TO TEMPLATE (LINEAR + NON-LINEAR)
  echo "T1 BETTED TO TEMPLATE (LINEAR + NON-LINEAR)"
  applywarp -i $session/T1/wT1_brain_spm.nii.gz \
  -w $session/BEDPOSTX.bedpostX/xfms/str2standard_warp.nii.gz \
  -r /usr/local/fsl/data/standard/MNI152_T1_2mm.nii.gz \
  -o $session/BEDPOSTX.bedpostX/xfms/test_warps/t1_brain_in_MNI

  #T1 TO TEMPLATE (LINEAR) 2mm and 1mm
  echo "T1 TO TEMPLATE (LINEAR) 2mm and 1mm"
  flirt -in $session/T1/wT1.nii \
  -ref /usr/local/fsl/data/standard/MNI152_T1_2mm.nii.gz \
  -applyxfm -init $session/BEDPOSTX.bedpostX/xfms/str2standard.mat \
  -out $session/BEDPOSTX.bedpostX/xfms/test_warps/t1_linear_to_MNI_2mm

  flirt -in $session/T1/wT1.nii \
  -ref /usr/local/fsl/data/standard/MNI152_T1_1mm.nii.gz \
  -applyxfm -init $session/BEDPOSTX.bedpostX/xfms/str2standard.mat \
  -out $session/BEDPOSTX.bedpostX/xfms/test_warps/t1_linear_to_MNI_1mm

  #T1 BETTED TO TEMPLATE (LINEAR) 2mm and 1mm
  echo "T1 BETTED TO TEMPLATE (LINEAR) 2mm and 1mm"
  flirt -in $session/T1/wT1_brain_spm.nii.gz \
  -ref /usr/local/fsl/data/standard/MNI152_T1_2mm.nii.gz \
  -applyxfm -init $session/BEDPOSTX.bedpostX/xfms/str2standard.mat \
  -out $session/BEDPOSTX.bedpostX/xfms/test_warps/t1_brain_linear_to_MNI_2mm

  flirt -in $session/T1/wT1_brain_spm.nii.gz \
  -ref /usr/local/fsl/data/standard/MNI152_T1_1mm.nii.gz \
  -applyxfm -init $session/BEDPOSTX.bedpostX/xfms/str2standard.mat \
  -out $session/BEDPOSTX.bedpostX/xfms/test_warps/t1_brain_linear_to_MNI_1mm

  #DIFFUSION TO T1 (LINEAR)
  echo "DIFFUSION TO T1 (LINEAR)"
  flirt -in $session/BEDPOSTX.bedpostX/nodif_brain.nii.gz \
  -ref $session/T1/wT1.nii -applyxfm -init $session/BEDPOSTX.bedpostX/xfms/diff2str.mat \
  -out $session/BEDPOSTX.bedpostX/xfms/test_warps/diff_to_T1

  #DIFFUSION TO T1 (LINEAR)
  echo "DIFFUSION TO T1 (LINEAR)"
  flirt -in $session/BEDPOSTX.bedpostX/nodif_brain.nii.gz \
  -ref $session/T1/wT1_brain_spm.nii.gz -applyxfm -init $session/BEDPOSTX.bedpostX/xfms/diff2str.mat \
  -out $session/BEDPOSTX.bedpostX/xfms/test_warps/diff_to_T1_brain


  #DIFFUSION TO TEMPLATE (LINEAR + NON-LINEAR)
  echo "DIFFUSION TO TEMPLATE (LINEAR + NON-LINEAR)"
  applywarp -i $session/BEDPOSTX.bedpostX/nodif_brain.nii.gz \
  -w $session/BEDPOSTX.bedpostX/xfms/diff2standard_warp.nii.gz \
  -r /usr/local/fsl/data/standard/MNI152_T1_2mm.nii.gz \
  -o $session/BEDPOSTX.bedpostX/xfms/test_warps/nodif_brain_in_MNI
}

# Calculate Diff2Standard Transformation for all subjects - before running XTRACT I will review them
#directory=/home/maria/Documents/Master-Thesis/Maria-Data/*
dir=/home/maria/Documents/Master-Thesis/Data_Master_Thesis

subjects=('BaIm63'  'HeSu65'  'JuUl58'  'LeEr59'  'NeNo60'  'OsGe59'  'PfRi58'  'SaMo64'  'StCa55'  'WeMa64')
sessions=('FIRST_SESSION_DWI_scan2')

now=$(date +"%T")
echo "Starting time : $now"

#for subject in $subjectsDir
for i in {0..9}
do
  echo "----- Subject ID ${subjects[$i]} -----"
  #echo $(basename $subject)
  #subjectDir=$subject/*
  subjectDir=$dir/${subjects[$i]}

  # for session in $subjectDir
  # do
    #echo $(basename $session)
    echo " Session ${sessions[0]} "
    session=$subjectDir/${sessions[0]}

    now=$(date +"%T")
    echo "Current time : $now"
    echo ""

    # Move Aldana's transformation mat files to a new folder
    mkdir $session/BEDPOSTX.bedpostX/xfms/prev_mat_files
    mv  $session/BEDPOSTX.bedpostX/xfms/* $session/BEDPOSTX.bedpostX/xfms/prev_mat_files

    #### Calculate transformation warps from diffusion to mni space
    echo "Calculating transformations...."

    now=$(date +"%T")
    echo "Current time : $now"

    calculate_transf

    ### apply transformations to check the images later
    echo ""
    echo "Tranforming Files ...."

    mkdir -p $session/BEDPOSTX.bedpostX/xfms/test_warps

    now=$(date +"%T")
    echo "Current time : $now"

    apply_transf

    echo ""

  # done
done

now=$(date +"%T")
echo "Finishing time : $now"
