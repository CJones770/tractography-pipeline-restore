#!/bin/bash
#Explicitly define SubjectDirectory as path to samples omiting the trailing /, e.g., /home/user/SubjectDirectory
#Exemplary output directories for stages 1-4 and Xtract: /home/user/MyOutputs/ThisRun/dwi_1_out ... /home/user/MyOutputs/ThisRun/dwi_Xtract_out
#This scripts expects 6 arguments to be declared:

SubjectDirectory=$1 
Stg1Out=$2
Stg2Out=$3
Stg3Out=$4
Stg4Out=$5
XtractOutDir=$6
Mount=$7
desiredPad=$8
arrSize=`ls $6 | wc -l`
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
now=$(date +"%T")
echo "Pipeline starting at $now for subject #$zi."
#Stage 1
cd /opt/Pipeline/Pipeline/Pipeline/bin
./L_disk_Check.sh $1 $7 . $8 #check if there is sufficient disk space to run the program, terminate if not
./L_DirectoryInitializer_Sub.sh $2 $3 $4 $5 $6 $1 $zi #Initialize Acq params, Temp, Output, and BedpostX Directories
./min_L_acqp_initializer.sh $1 $zi #Copy subject acquisition parameters [bval, bvec, acquisition_parameters.txt] into respective ~/Pipeline/ACQP/sub_##/ directories
./L_dwi_denoise.sh $1 $zi #Run MP-PCA denoising [Targets only Gaussian Noise]
./L_dwiDegibbs.sh $1 $zi #Correct Gibbs Ringing Artifacts
./L_bestb0finder.sh $1 $zi #Calculate difference between each b0 volume and their average
./L_best_b0_tester.sh $1 $2 $zi #Compare residuals from previous step to choose best b0 volumes
./min_L_Tmp1_2_Out.sh $1 $2 $zi #Move Temp outputs of interest to specified output directory #1 [Stg1Out]
#Stage 2
./min_L_topup.sh $1 $zi #Correct for EPI distortions
./L_min_applytopup.sh $1 $zi #$2 #Apply correcting warp fields
./L_betRunner.sh $1 $zi #Extract intermediate brain mask for eddy correction 
./L_Tmp1Clear.sh $1 $zi #Clear Stg1Tmp Folder
./L_min_eddy8.0.sh $1 $zi #$2 #Correct for Eddy Currents and subject motion
./L_eddy_quad_runner.sh $1 $3 $zi #Quality control report stored in specified output directory #2 [Stg2Out]
./L_Tmp2_2_Out.sh $1 $3 $zi #Move Temp outputs of interest to specified output directory #2 [Stg2Out]
#Stage 3
./L_nodif_brain_maker.sh $1 $zi #Average b0 volumes from outlier free eddy corrected data
./L_FSLmathsRunner.sh $1 $zi #Smooths outlier free eddy corrected data with 1mm^3 gaussian kernel 
./L_smoothed_nodif_brainmaker.sh $1 $zi #Average b0 volumes from smoothed outlier free eddy corrected data
./L_T1Better.sh $1 $zi #Create anatomical brain mask
./L_Tmp3_2_Out.sh $1 $4 $zi #Move Temp outputs of interest to specified output directory #3 [Stg3Out]
#Stage 4
./L_bedpostXRunner.sh $1 $zi #Estimate Diffusion Tensors
./L_Tmp2clear.sh $1 $zi #Clear Stg2Tmp Folder
./L_script-Diff2MNI_transformations.sh $1 #Perform nonlinear anatomical registration of diffusion data
./L_Tmp3clear.sh $1 $zi #Clear Stg3Tmp Folder
./L_Tmp4_2_Out.sh $1 $5 $zi #Move Temp outputs of interest to specified output directory #4 [Stg4Out]
./L_xtract_gpu.sh $1 $6 $zi #Perform tractography algorithm and store in specified output directory #5 [XtractOutDir]
./L_Tmp4clear.sh $1 $zi #Clear Stg4Tmp Folder
./L_Pipelinereset.sh $1 $zi
now=$(date +"%T")
echo "Pipeline complete at $now"


