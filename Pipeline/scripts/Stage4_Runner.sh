#!/bin/bash
#Explicitly definte SubjectDirectory as path to samples, e.g., /home/user/SubjectDirectory
#root should be defined as /home/user , will be used instead of '~' when needed.
SubjectDirectory=$1 
root=$2
Xtractout=$3
#Stage 4
cd $2/Pipeline/scripts/Stg4
now=$(date +"%T")
echo "Starting time : $now"
./M_bedpostXRunner.sh $1
./M_script-Diff2MNI_transformations.sh $1 $2
./M_xtract_gpu.sh $1 $3
now=$(date +"%T")
echo "Finishing time : $now"
echo "Stage 4 Complete. Pipeline Complete."
