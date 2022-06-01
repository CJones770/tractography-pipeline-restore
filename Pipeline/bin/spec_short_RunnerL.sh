#!/bin/bash
#Explicitly define SubjectDirectory as path to samples omiting the trailing /, e.g., /home/user/SubjectDirectory
#Exemplary output directories for stages 1-4 and Xtract: /home/user/MyOutputs/ThisRun/dwi_1_out ... /home/user/MyOutputs/ThisRun/dwi_Xtract_out
#This scripts expects 6 arguments to be declared:
SubjectDirectory=$1 
Outputdir=$2
Mount=$3
desiredPad=$4
firstSub=$5
lastSub=$6
i=$firstSub
while [ "$(( i += 1 ))" -le $6 ]
do
zi=$( printf '%02d' "$i")
now=$(date +"%T")
echo "Pipeline starting at $now for subject #$zi."
#Stage 1
cd /opt/Pipeline/Pipeline/Pipeline/bin
./L_disk_Check.sh $1 $3 . $4 #check if there is sufficient disk space to run the program, terminate if not
./L_DirectoryInitializer_Sub.sh $2 $2 $2 $2 $2 $1 $zi #Initialize Acq params, Temp, Output, and BedpostX Directories
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
./L_eddy_quad_runner.sh $1 $2 $zi #Quality control report stored in specified output directory #2 [Stg2Out]
./L_Tmp2_2_Out.sh $1 $2 $zi #Move Temp outputs of interest to specified output directory #2 [Stg2Out]
done
now=$(date +"%T")
echo "Pipeline complete at $now for $arrSize subjects, last subject is sub-$zi"



