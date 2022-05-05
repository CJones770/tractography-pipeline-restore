#!/bin/bash
#Explicitly define SubjectDirectory as path to samples, e.g., /home/user/SubjectDirectory
SubjectDirectory=$1 
#Stage 3
cd ~/Pipeline/scripts/Stg3/
echo "Beginning preprocessing stage 3 for `ls $1 | wc -l` subjects...."
now=$(date +"%T")
echo "Starting time : $now"
./M_nodif_brain_maker.sh $1
echo "1/4 done."
./M_FSLmathsRunner.sh $1
echo "2/4 done."
./M_smoothed_nodif_brainmaker.sh $1
echo "3/4 done."
./M_T1Better.sh $1
echo "4/4 done. Stage Processing 3 Complete."
now=$(date +"%T")
echo "Finishing time : $now"
