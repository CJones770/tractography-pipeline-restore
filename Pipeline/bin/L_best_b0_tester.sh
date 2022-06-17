#!/bin/bash
SubjDirectory=$1
Out1Dir=$2
zi=$3
echo "Testing b0 volumes for closest resemblance to mean volume for subject $zi"
now=$(date +"%T")
echo "Starting time: $now"
#Initialize the first volume as the volume that best resembles the mean b0 volume [see best_b0_finder.sh for method of calculating residual values for each volume]
j=1
bestAPb0res=/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_1_rsqr.nii.gz
bestPAb0res=/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_1_rsqr.nii.gz
bestAP_b0=/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_1.nii.gz
bestPA_b0=/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_1.nii.gz
#Iteratively calculate the difference between the (1) currently held best volume and (2) all volumes with higher index numbers, store difference of averaged residuals in 3 directions in a txt file
for  ((j=1;j<=7;j++));
do
xi=$( printf "$j")
fslmaths $bestAPb0res -sub /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_"$xi"_rsqr.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/AP_best-b_"$xi".nii.gz
fslmaths /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/AP_best-b_"$xi".nii.gz -Xmean -Ymean -Zmean /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/AP_best_mean-"$xi".nii.gz
fsl2ascii /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/AP_best_mean-"$xi".nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/AP_b0rsqr_best-"$xi".txt
ResStoreAP=`grep . /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/AP_b0rsqr_best-"$xi".txt00000 | cut -c1-2`
fslmaths $bestPAb0res -sub /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_"$xi"_rsqr.nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/PA_best-b_"$xi".nii.gz
fslmaths /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/PA_best-b_"$xi".nii.gz -Xmean -Ymean -Zmean /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/PA_best_mean-"$xi".nii.gz
fsl2ascii /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/PA_best_mean-"$xi".nii.gz /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/PA_b0rsqr_best-"$xi".txt
ResStorePA=`grep . /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/PA_b0rsqr_best-"$xi".txt00000 | cut -c1-2`
#If the residual of the 'best' volume minus the residual of the current volume being tested >= 0, i.e., current best residual >= current residual, update so that current volume index is the new best
if [ $ResStoreAP -ge 0 ];
then
bestAPb0res=/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_"$xi"_rsqr.nii.gz
bestAP_b0=/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/tAP_b0_"$xi".nii.gz
fi
if [ $ResStorePA -ge 0 ];
then
bestPAb0res=/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_"$xi"_rsqr.nii.gz
bestPA_b0=/opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/tPA_b0_"$xi".nii.gz
fi
done
#write to log
exec > $2/sub_"$zi"/1o/bestb0log.txt 2>&1
echo "Closest matches for subject $zi are: "	
echo "$bestAPb0res"
echo "$bestPAb0res"
#Store best volume as input volume for topup.
echo "merging best volumes for subject $zi"
fslmerge -t /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/AP_PA_TopupInput2Vols.nii.gz $bestAP_b0 $bestPA_b0
cp $bestAP_b0 /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/BestAP_b0vol.nii.gz
cp $bestAP_b0 /$2/sub_$zi/1o/AP_bestb0.nii.gz
cp $bestPA_b0 /opt/Pipeline/Pipeline/Pipeline/Stg1Tmp/sub_$zi/BestPA_b0vol.nii.gz
cp $bestPA_b0 /$2/sub_$zi/1o/PA_bestb0.nii.gz
echo $bestAP_b0
echo $bestPA_b0
now=$(date +"%T")
echo "Finishing time: $now"
