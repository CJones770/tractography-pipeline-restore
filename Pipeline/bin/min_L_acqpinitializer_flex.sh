#!/bin/bash
SubjectDirectory=$1
zi=$2
numdir=$3
acquisition_direction=$4
echo "Initializing 'acquisition_parameters_min.txt' files for subject $zi:"
if [-e $1/sub_$zi/dwi/sub_"$zi"_acq-"$numdir"-"$acquisition_direction"_dwi.json]
ReadOut=`grep TotalReadoutTime $1/sub_$zi/dwi/sub-"$zi"_acq-"$numdir"-"$acquisition_direction"_dwi.json | cut -c23-31`
sed 's/$/ '$ReadOut'/' /opt/Pipeline/Pipeline/Pipeline/ACQP/ap_template_min"_$acquisition_direction".txt > /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_"$zi"/acquisition_parameters_min"_$acquisition_direction".txt
cp $1/sub_$zi/dwi/sub-"$zi"_acq-dir"$numdir"_dir-"$4"_dwi.bval /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/bval
cp $1/sub_$zi/dwi/sub-"$zi"_acq-dir"$numdir"_dir-"$4"_dwi.bvec /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/bvec
fi
if [-e $1/$zi/Diffusion/"$zi"_3T_DWI_dir"$numdir"_"$acquisition_direction".nii.gz]
ReadOut=`grep TotalReadoutTime $1/$zi/Diffusion/"$zi"_3T_DWI_dir"$numdir"_"$acquisition_direction".txt | cut -c23-31`
#sed 's/$/ '$ReadOut'/' /opt/Pipeline/Pipeline/Pipeline/ACQP/ap_template_min"_$acquisition_direction".txt > /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_"$zi"/acquisition_parameters_min"_$acquisition_direction".txt
cp $1/$zi/Diffusion/"$zi"_3T_DWI_dir"$numdir"_"$acquisition_direction".bval /opt/Pipeline/Pipeline/Pipeline/ACQP/$zi/bval
cp $1/$zi/Diffusion/"$zi"_3T_DWI_dir"$numdir"_"$acquisition_direction".bvec /opt/Pipeline/Pipeline/Pipeline/ACQP/$zi/bvec
fi
echo "Acquisition parameters initialized. Bvec and Bval files copied to /opt/Pipeline/Pipeline/Pipeline/ACQP/subject directories."
