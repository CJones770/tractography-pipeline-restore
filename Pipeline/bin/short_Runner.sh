#!/bin/bash
#Explicitly define SubjectDirectory as path to samples omiting the trailing /, e.g., /home/user/SubjectDirectory
#Exemplary output directories for stages 1-4 and Xtract: /home/user/MyOutputs/ThisRun/dwi_1_out ... /home/user/MyOutputs/ThisRun/dwi_Xtract_out
#This scripts expects 6 arguments to be declared:
SubjectDirectory=$1 
OutDir=$2
Mount=$3
desiredPad=$4
now=$(date +"%T")
echo "Pipeline starting at $now ."
#Stage 1
cd /opt/Pipeline/Pipeline/Pipeline/bin
./disk_Check.sh $1 $7 . $4
./DirectoryInitializer_Sub.sh $2 $2 $2 $2 $2 $1 #Initialize Acq params, Temp, Output, and BedpostX Directories
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
./eddy_quad_runner.sh $1 $2 #Quality control report stored in specified output directory #2 [Stg2Out]
./M_Tmp2_2_Out.sh $1 $2 #Move Temp outputs of interest to specified output directory #2 [Stg2Out]
./Tmp2clear.sh $1 #Clear Stg2Tmp Folder
./Pipelinereset.sh $1
now=$(date +"%T")
echo "Pipeline complete at $now"


