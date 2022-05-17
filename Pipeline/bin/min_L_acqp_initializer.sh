#!/bin/bash
SubjectDirectory=$1
zi=$2
echo "Initializing 'acquisition_parameters_min.txt' files for subject $zi:"
ReadOut=`grep TotalReadoutTime $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_dir-PA_dwi.json | cut -c23-31`
sed 's/$/ '$ReadOut'/' /opt/Pipeline/Pipeline/Pipeline/ACQP/ap_template_min.txt > /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_"$zi"/acquisition_parameters_min.txt
cp $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_dir-PA_dwi.bval /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/bval
cp $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_dir-PA_dwi.bvec /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/bvec
echo "Acquisition parameters initialized. Bvec and Bval files copied to /opt/Pipeline/Pipeline/Pipeline/ACQP/subject directories."
