#!/bin/bash
#Explicitly definte SubjectDirectory as path to samples, e.g., /home/user/SubjectDirectory
#root should be defined as /home/user , will be used instead of '~' when needed.
#Exemplary output directories /home/user/Desktop/dwi_1_out ... /home/user/Desktop/dwi_X_out
SubjectDirectory=$1 
root=$2
Stg1Out=$3
Stg2Out=$4
Stg3Out=$5
Stg4Out=$6
XtractOutDir=$7
#Stage 1
cd $2/Pipeline/scripts/Stg1
./DirectoryInitializer_Sub.sh $3 $4 $5 $6 $7 $1 #Initialize Acq params, Temp, Output, and BedpostX Directories
./M_acqp_initializer.sh $1 #Copy subject acquisition parameters [bval, bvec, acquisition_parameters.txt] into respective ~/Pipeline/ACQP/sub_##/ directories
./M_dwi_denoise.sh $1 #Run MP-PCA denoising [Targets only Gaussian Noise]
./M_dwiDegibbs.sh $1 #Correct Gibbs Ringing Artifacts
./M_fslRunner_19Mar22.sh $1 #Extract ROIs and merge
./M_Tmp1_2_Out.sh $1 $3 #Move Temp outputs of interest to specified output directory #1
#Stage 2
cd $2/Pipeline/scripts/Stg2
./M_topup.sh $1 $2 #Correct for EPI distortions
./M_applyTopup.sh $1 $2 #Apply correcting warp fields
./M_betRunner.sh $1 #Extract intermediate brain mask for eddy correction 
./M_eddyCuda8.sh $1 $2 #Correct for Eddy Currents and subject motion
./M_fast.sh $1 #Perform Bias Field Correction
./M_Tmp2_2_Out.sh $1 $4 #Move Temp outputs of interest to specified output directory #2
#Stage 3
cd $2/Pipeline/scripts/Stg3
./M_nodif_brain_maker.sh $1 #Average b0 volumes from outlier free eddy corrected data
./M_FSLmathsRunner.sh $1 #Smooths outlier free eddy corrected data with 1mm^3 gaussian kernel 
./M_smoothed_nodif_brainmaker.sh $1 #Average b0 volumes from smoothed oulier free eddy corrected data
./M_T1Better.sh $1 #Create anatomical brain mask
./M_Tmp3_2_Out.sh $1 $5 #Move Temp outputs of interest to specified output directory #3
#Stage 4
cd $2/Pipeline/scripts/Stg4
./M_bedpostXRunner.sh $1 #Estimate Diffusion Tensors
./M_script-Diff2MNI_transformations.sh $1 $2 #Perform nonlinear anatomical registration of diffusion data
./M_Tmp4_2_Out.sh $1 $6 #Move Temp outputs of interest to specified output directory #4
./M_xtract_gpu.sh $1 $7 #Perform tractography algorithm and store in specified output directory #5 [XtractOutDir]

