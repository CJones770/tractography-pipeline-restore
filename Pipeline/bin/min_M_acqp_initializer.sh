#!/bin/bash

SubjectDirectory=$1
arrSize=`ls $1 | wc -l`
echo "Initializing 'acquisition_parameters.txt' files for $arrSize subjects:"
i=0
while [ "$(( i += 1 ))" -le $arrSize ]
do
zi=$( printf '%02d' "$i")
ReadOut=`grep TotalReadoutTime $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_dir-PA_dwi.json | cut -c23-31`
docker exec "dwi-pipeline3" sed bash -c "echo 's/$/ '$ReadOut'/' /opt/Pipeline/Pipeline/Pipeline/ACQP/ap_template_min.txt > /opt/Pipeline/Pipeline/Pipeline/Pipeline/ACQP/sub_"$zi"/acquisition_parameters_min.txt"
docker cp $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_dir-PA_dwi.bval /opt/Pipeline/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/bval
docker cp $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_dir-PA_dwi.bvec /opt/Pipeline/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/bvec
done
echo "Acquisition parameters initialized. Bvec and Bval files copied to ~/Pipeline/ACQP/subject directories."
