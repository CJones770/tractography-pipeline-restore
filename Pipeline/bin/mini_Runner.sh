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
now=$(date +"%T")
echo "Pipeline starting at $now ."
#Stage 1
cd /opt/Pipeline/Pipeline/Pipeline/bin
./DirectoryInitializer_Sub.sh $2 $3 $4 $5 $6 $1 #Initialize Acq params, Temp, Output, and BedpostX Directories
./min_M_acqp_initializer.sh $1 #Copy subject acquisition parameters [bval, bvec, acquisition_parameters.txt] into respective ~/Pipeline/ACQP/sub_##/ directories
./M_dwi_denoise.sh $1 #Run MP-PCA denoising [Targets only Gaussian Noise]
./M_dwiDegibbs.sh $1 #Correct Gibbs Ringing Artifacts
./bestb0finder.sh $1 #Calculate difference between each b0 volume and their average
./best_b0_tester.sh $1 $2 #Compare residuals from previous step to choose best b0 volumes
./min_M_Tmp1_2_Out.sh $1 $2 #Move Temp outputs of interest to specified output directory #1 [Stg1Out]
#Stage 2
#cd $2/Pipeline/scripts/Stg2
./min_M_topup.sh $1 #Correct for EPI distortions
./min_applytopup.sh $1 #$2 #Apply correcting warp fields
./M_betRunner.sh $1 #Extract intermediate brain mask for eddy correction 
./Tmp1clear.sh $1 #Clear Stg1Tmp Folder
./min_eddy8.sh $1 #$2 #Correct for Eddy Currents and subject motion
./eddy_quad_runner.sh $1 $3 #Quality control report stored in specified output directory #2 [Stg2Out]
./M_Tmp2_2_Out.sh $1 $3 #Move Temp outputs of interest to specified output directory #2 [Stg2Out]
#Stage 3
#cd $2/Pipeline/scripts/Stg3
./M_nodif_brain_maker.sh $1 #Average b0 volumes from outlier free eddy corrected data
./M_FSLmathsRunner.sh $1 #Smooths outlier free eddy corrected data with 1mm^3 gaussian kernel 
./M_smoothed_nodif_brainmaker.sh $1 #Average b0 volumes from smoothed outlier free eddy corrected data
./M_T1Better.sh $1 #Create anatomical brain mask
./M_Tmp3_2_Out.sh $1 $4 #Move Temp outputs of interest to specified output directory #3 [Stg3Out]
#Stage 4
#cd $2/Pipeline/scripts/Stg4
./M_bedpostXRunner.sh $1 #Estimate Diffusion Tensors
./Tmp2clear.sh $1 #Clear Stg2Tmp Folder
./M_script-Diff2MNI_transformations.sh $1 #Perform nonlinear anatomical registration of diffusion data
./Tmp3clear.sh $1 #Clear Stg3Tmp Folder
./M_Tmp4_2_Out.sh $1 $5 #Move Temp outputs of interest to specified output directory #4 [Stg4Out]
./M_xtract_gpu.sh $1 $6 #Perform tractography algorithm and store in specified output directory #5 [XtractOutDir]
./Tmp4clear.sh $1 #Clear Stg4Tmp Folder
./Pipelinereset.sh $1
now=$(date +"%T")
echo "Pipeline complete at $now"


