#!/bin/bash
root=$1
sudo chmod u+x PipelineRunner.sh
sudo chmod u+x Stage1_Runner.sh
sudo chmod u+x Stage2_Runner.sh
sudo chmod u+x Stage3_Runner.sh
sudo chmod u+x Stage4_Runner.sh
#Stage 1
cd $1/Pipeline/scripts/Stg1
sudo chmod u+x DirectoryInitializer_Sub.sh
sudo chmod u+x M_acqp_initializer.sh
sudo chmod u+x M_dwi_denoise.sh 
sudo chmod u+x M_dwiDegibbs.sh 
sudo chmod u+x M_fslRunner_19Mar22.sh 
#Stage 2
cd $1/Pipeline/scripts/Stg2
sudo chmod u+x M_topup.sh 
sudo chmod u+x M_applyTopup.sh 
sudo chmod u+x M_eddyCuda8.sh 
sudo chmod u+x M_betRunner.sh 
#Stage 3
cd $1/Pipeline/scripts/Stg3
sudo chmod u+x M_nodif_brain_maker.sh 
sudo chmod u+x M_FSLmathsRunner.sh 
sudo chmod u+x M_smoothed_nodif_brainmaker.sh 
sudo chmod u+x M_T1Better.sh 
#Stage 4
cd $1/Pipeline/scripts/Stg4
sudo chmod u+x M_bedpostXRunner.sh 
sudo chmod u+x M_script-Diff2MNI_transformations.sh 
sudo chmod u+x M_xtract_gpu 
