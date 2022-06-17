#!/bin/bash
SubjectDirectory=$1
zi=$2
echo "Preparing eddy current correction for subject $zi. Requires CUDA8.0 compatible hardware and drivers."
now=$(date +"%T")
echo "Starting time : $now"
echo "Copying bvec and bval files from Subject directory to ~/Pipeline/ACQP/sub_$zi/"
cp $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_dir-PA_dwi.bvec /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/bvec
cp $1/sub_$zi/dwi/sub-"$zi"_acq-dir107_dir-PA_dwi.bval /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/bval
echo "bval and bvec files successfully copied for sub-$zi. Beginning eddy current correction...."
eddy_cuda8.0 --imain=/opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDG_hifi_images.nii.gz \
--mask=/opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDG_brain_mask_output.nii.gz --acqp=/opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/acquisition_parameters_min.txt \
--index=/opt/Pipeline/Pipeline/Pipeline/ACQP/my_index --bvecs=/opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/bvec --bvals=/opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/bval \
--topup=/opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDGTopup --out=/opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/EddyOut_DNDG \
--data_is_shelled --verbose --repol
echo "Corrected Subject $zi."
now=$(date +"%T")
echo "Current time : $now"
echo "Data ready for Stage 3: Mask creation and preparation for bedpostX."
