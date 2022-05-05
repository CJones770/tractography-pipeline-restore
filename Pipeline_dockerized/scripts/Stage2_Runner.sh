#!/bin/bash
#Explicitly definte SubjectDirectory as path to samples, e.g., /home/user/SubjectDirectory
#root should be defined as /home/user , will be used instead of '~' when needed.
SubjectDirectory=$1 
root=$2
echo "Beginning preprocessing stage 2 for `ls $1 | wc -l` subjects"
now=$(date +"%T")
echo "Starting time : $now"
./M_topup.sh $1 $2
./M_applyTopup.sh $1 $2
./M_betRunner.sh $1
./M_eddyCuda8.sh $1 $2
now=$(date +"%T")
echo "Finishing time : $now"
echo "Stage 2 Complete"
