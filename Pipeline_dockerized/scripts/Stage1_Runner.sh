#!/bin/bash
#Explicitly definte SubjectDirectory as path to samples, e.g., /home/user/SubjectDirectory
SubjectDirectory=$1 
Stg1Out=$2
Stg2Out=$3
Stg3Out=$4
Stg4Out=$5
XtractOutDir=$6

#Stage 1
cd ~/Pipeline/scripts/Stg1
echo "Beginning preprocessing stage 1 for `ls $1 | wc -l` subjects"
now=$(date +"%T")
echo "Starting time : $now"
./DirectoryInitializer_Sub.sh $2 $3 $4 $5 $6 $1
./M_acqp_initializer.sh $1
./M_dwi_denoise.sh $1
./M_dwiDegibbs.sh $1
./M_fslRunner_19Mar22.sh $1
now=$(date +"%T")
echo "Finishing time : $now"
echo "Stage 1 Complete"
