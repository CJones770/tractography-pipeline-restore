#!/bin/bash
SubjectDirectory=$1
zi=$2
echo "Creating brain masks for $arrSize subjects"
bet /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDG_hifi_images.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg2Tmp/sub_$zi/DNDG_brain_mask_output
echo "masks generated for $arrSize subjects. Ready for Eddy."
