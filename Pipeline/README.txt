README - dwi-pipeline version 1.0.4d developed by Corey Jones - May 17th, 2022

This pipeline was developed to preprocess raw diffusion weighted image data of patients with Early Psychosis provided by the Human Connectome Project (HCP) to prepare them for probabalistic tractography.

An independent, similar pipeline developed by the University of Washington is available on the HCP official website and on the U-Washington Github at either of the following links:

https://github.com/Washington-University/HCPpipelines && https://www.humanconnectome.org/software/hcp-mr-pipelines

Both (my and the official) pipelines rely on NVIDIA's CUDA toolkit for gpu acceleration/parallelization, and therefore to run this dwi-pipeline version 1.0.2d in a docker container as intended, nvidia's docker container runtime toolkit should be installed prior to starting the container if it has not been installed already. This can be achieved by running  : 
apt-get update && apt-get install nvidia-docker2 [for docker versions 19.03 or newer] see https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html for troubleshooting

OR:

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

and subsequently restarting the docker daemon with sudo system (or systemtcl) docker restart (depending on how you have installed docker).
[you may need superuser/root priveleges to perform docker commands in general, and restarting the daemon will likely interrupt active processes in other containers if not kill them entirely]
** The above steps were pulled from the official Nvidia website at https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker **

The necessary docker image to run this pipeline can be pulled from docker hub by calling $ sudo docker pull jonescorey/dwi-pipeline

This pipeline is designed to run in a docker container that mounts a subject directory and an output directory from the host machine as volumes in the container.

This mounting is performed while calling 'docker run' on the image file e.g.,
If the image is tagged "dwi-pipeline:latest", one may mount their directories by running the following command:

docker run -it --rm --runtime=nvidia -v /Path/to/local_Subject_Data:/Path/toSubjData/inContainer -v /Path/to/local_OutputFolder:/Outputs --name choose_name_for_container jonescorey/dwi-pipeline:latest

where the -it option runs the container in an interactive terminal, --rm declares the container shall be removed when stopped, runtime=nvidia enables the CUDA container runtime, -v specifies each volume to be mounted from the host machine to the container, the name of the container is arbitrary, and the final input is the image name with its tag i.e., dwi-pipeline:latest or equivalent as stored on the host machine.

To run the pipeline in full one must call the 'long_Runner.sh' or 'mini_Runner.sh' script located in the Pipeline's bin, which exists in the container path /opt/Pipeline/Pipeline/Pipeline/bin/ ; 
i.e., once in the container's interactive terminal, one must navigate to the directory with $ cd /opt/Pipeline/Pipeline/Pipeline/bin/ ; then run $ ./long_Runner.sh (or mini_Runner.sh) with the following inputs:

/Path/toSubjData/inContainer /Outputs /Path/to/CurrentMount 102400 [or other integer representing the amount of space in MB to leave open on the disk after running the pipeline]

working examples of this syntax from building the docker container to executing the main run script are below:

1: #Run the container, mount your subject and output directories, name the container, and choose the appropriate image:tag to build it from  
sudo docker run -it --rm --runtime=nvidia -v /home/corey/P_samples:/SubjDir -v /home/corey/pipeline-test-outputs/TO:/TO --name dwi-pipeline jonescorey/dwi-pipeline:experimental

1.a. Note: if you want to utilize the disk check function, pull jonescorey/dwi-pipeline:experimental from docker hub instead of the image tagged 'latest'. If using the latest version that doesn't check disk space, you may omit the last two arguments declared when running ./mini_Runner as described below.

2: #change directories to access the pipeline's scripts
cd /opt/Pipeline/Pipeline/Pipeline/bin 

3: #Run a runner script of your choice: long_Runner.sh mini_Runner.sh runner_NoTract.sh or short_Runner.sh (see the section preceding References for their descriptions)
./long_Runner.sh /SubjDir /TO /MountName/For/DiskSpaceCheck 102400 [where 102400 is an exemplary minimum pad one may specify in MBs to remain open on the disk after the pipeline runs]

To ensure the specified disk is not overloaded by this process, one should specify no integer that is less than 0, and should consider using at least 10240 to leave 10GB of space; this is especially true if the disk is shared. Use your own discretion to choose a pad based on the amount of space you have available and the amount of space you might expect others to need.

**NOTE: it is important to not include any additional forward slashes in the above steps **

If all is properly setup, these 3 commands should initiate the pipeline. This will run over each subject in the specified directory. The outputs of pipeline stages 1 through 4 will be stored in the directories /TO/sub_##/1o/ - /TO/sub_##/4o/ (short for Test Outputs 1 - 4), and tractography data will be stored in /TO/sub_##/Xo/ .

It is crucial that input data in /SubjDir/ are named and stored appropriately i.e., with the form and path specified as follows:
/SubjDir/sub_##/dwi/sub-##_acq-dir107_AP_dwi.nii.gz , /SubjDir/sub_##/dwi/sub-##_acq-dir107_PA_dwi.nii.gz , /SubjDir/sub_##/dwi/sub-##_acq-dir107_PA_dwi.bval , and /SubjDir/sub_##/dwi/sub-##_acq-dir107_PA_dwi.bvec , which should be the default bids format;
Where /SubjDir is an arbitrarily named subject directory and ## is a 2 digit number specifying the subject ID. The list must start at 01 and increase incrementally. AP refers to the Anterior Posterior principal encoding direction and PA to its reverse; the bval and bvec files are sourced from the posterior-anterior encoding direction in this pipeline (but theoretically can be sourced from either).
*This pipeline does not handle data that have been collected in the RL-LR reverse phase encoding acquisition regime*

The user can specify an arbitrary range of subjects to run the pipeline over by using the spec_* runners i.e., (spec_longRunner.sh , spec_short_RunnerL.sh or spec_NoTract_RunnerL.sh) with the same arguments as seen above with the addition of two arguments at the end, the first being the first subject number in the desired range and the second being the last. An example is given below:

./spec_longRunner.sh /SubjDir /TO /Mount 0 1 10 ; which will run the pipeline for subjects 1 through 10 storing their outputs in /TO/sub_##/* . To run one subject only one can specify the following:

./spec_longRunner.sh /SubjDir /TO /Mount 0 2 2 ; which will run the pipeline for only subject 2.

NOTE: IF YOU MANUALLY INTERRUPT THE PIPELINE YOU MAY EXPERIENCE ERRORS ATTEMPTING TO RESTART IT. THIS CAN BE RESOLVED BY RESTARTING THE DOCKER CONTAINER WITH `exit` AND RERUNNING THE "RUN" COMMAND ABOVE. THE RAMIFICATIONS OF RESTARTING THE DOCKER CONTAINER IN THE MIDDLE OF LARGE PROCESSING JOBS HAS NOT BEEN FULLY TESTED. The subject data that have been processed and exported to the specified output directory should not be lost as a result.

The amount of disk space needed per subject is approximately : 9GB. Ultimately ~6GB are stored in the output directories. If using long_Runner.sh, the amount of space needed is 6GB per subject + 3GB.

The estimated run time from denoising to the completion of tractography using FSL's Xtract i.e., the whole pipeline [while utilizing an NVIDIA 1070TI graphics card] is : 4hrs50minutes per subject

The pipeline relies on CUDA8.0 for gpu utilization, therefore a compatible NVIDIA graphics card is needed. 
A list of cards and their CUDA version compatability can be found here: https://developer.nvidia.com/cuda-gpus
Future versions of this pipeline may include newer versions of CUDA by default.

Runtime breakdown:
Stage 1 - Runtime =     ~15minutes/subject

dwidenoise [mrtrix3]    ~7minutes30seconds/subject [removes gaussian noise using Marcenko-Pastur PCA denoising];
mrdegibbs [mrtrix3]     ~5minutes/subject [removes Gibbs Ringing artefacts] https://mrtrix.readthedocs.io/en/dev/reference/commands/mrdegibbs.html ; 
bestb0find&test [shell] ~2minutes/subject

Stage 2 - Runtime =     ~40-45minutes/subject

topup [FSL]             ~13minutes/subject [Reduces effect of EPI distortions]
applytopup [FSL]        ~5minutes30seconds/subject
eddy_cuda8.0 [FSL]      ~22minutes/subject [Reduces effects of eddy current and subject motion artefacts]
eddy_quad [FSL]         ~<1minute/subject [Performs quality control analysis and stores reports in defined second output directory e.g., /TO/sub_##/2o/...]

Stage 3 [FSLutils]      ~2.5minutes/subject [Generates 'no_dif' brain images, anatomical brain masks, and smoothed copies thereof]

Stage 4 - Runtime =     ~1hr30minutes/subhect

bedpostx_gpu [FSL]      ~45 minutes/subject [Bayesian Estimation of Diffusion Parameters Obtained using Sampling Techniques, X stands for crossing fibre models]
registration [FSL]      ~30-45 minutes/subject [Anatomical registration of diffusion data]

Xtract stage: Runtime = ~2hours15minutes/subject
xtract* [FSL]           ~2hours15minutes/subject [probabalistic tractography method that utilizes ~40 predefined regions of interest] 
*Runtime can be cut down by selecting specific tracts in a structs.txt file [not compatible with current dockerized version]

Pipeline total runtime = ~4hrs50minutes/subject
Short pipeline total runtime = ~1 hour/subject

Full pipeline omitting Xtract total runtime (runner_NoTract.sh) = ~2hrs30minutes/subject

long_Runner.sh runtime is similar to mini_Runner.sh [4hrs50minutes] as it runs all of the same processes. The differece is that the long runner performs the whole pipeline on one subject at a time [for all subjects in the specified directory assuming there is disk space], whereas the mini runner runs each step of the pipeline for each subject in the directory before moving to the next step;

Therefore, the long_Runner.sh script is more disk space efficient [~50% more efficient for a large number of subjects to be processed]

Runtime estimates were made while using an NVIDIA-1070-TI graphics card with 8GB of memory. Runtimes for eddy_cuda8.0,bedpostx_gpu, and xtract are affected by GPU memory availability.

One may choose to stop the pipeline short, i.e., before diffusor tensors are estimated by running ./short_Runner.sh with the same syntax as seen in the above example: Runtime is ~1hour/subject. This will stop the Pipeline after performing Eddy correction and QC report building i.e., after stage 2.

One may choose to stop the pipeline immediately before running tractography [in order to select a given set of structures to track before proceeding, or to break up the processes]. This is done by running runner_NoTract.sh with the same inputs as above. Runtime is ~2hrs20mins/subject.

Note that the short and NoTract runner scripts can only be run in the wide format, therefore they are less efficient with respect to the disk space utilized while the pipeline runs.

#############################################################################################################################################################################################################

References:
dwidenoise: [pulled from https://mrtrix.readthedocs.io/en/latest/reference/commands/dwidenoise.html]
Veraart, J.; Novikov, D.S.; Christiaens, D.; Ades-aron, B.; Sijbers, J. & Fieremans, E. Denoising of diffusion MRI using random matrix theory. NeuroImage, 2016, 142, 394-406, doi: 10.1016/j.neuroimage.2016.08.016

Veraart, J.; Fieremans, E. & Novikov, D.S. Diffusion MRI noise mapping using random matrix theory. Magn. Res. Med., 2016, 76(5), 1582-1593, doi: 10.1002/mrm.26059

Cordero-Grande, L.; Christiaens, D.; Hutter, J.; Price, A.N.; Hajnal, J.V. Complex diffusion-weighted image estimation via matrix recovery under general noise models. NeuroImage, 2019, 200, 391-404, doi: 10.1016/j.neuroimage.2019.06.039

Tournier, J.-D.; Smith, R. E.; Raffelt, D.; Tabbara, R.; Dhollander, T.; Pietsch, M.; Christiaens, D.; Jeurissen, B.; Yeh, C.-H. & Connelly, A. MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. NeuroImage, 2019, 202, 116137

mrdegibbs: [pulled from https://mrtrix.readthedocs.io/en/latest/reference/commands/mrdegibbs.html]
Kellner, E; Dhital, B; Kiselev, V.G & Reisert, M. Gibbs-ringing artifact removal based on local subvoxel-shifts. Magnetic Resonance in Medicine, 2016, 76, 1574–1581.

Tournier, J.-D.; Smith, R. E.; Raffelt, D.; Tabbara, R.; Dhollander, T.; Pietsch, M.; Christiaens, D.; Jeurissen, B.; Yeh, C.-H. & Connelly, A. MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. NeuroImage, 2019, 202, 116137

Overall FSL references: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FSL
1. M.W. Woolrich, S. Jbabdi, B. Patenaude, M. Chappell, S. Makni, T. Behrens, C. Beckmann, M. Jenkinson, S.M. Smith. Bayesian analysis of neuroimaging data in FSL. NeuroImage, 45:S173-86, 2009

2. S.M. Smith, M. Jenkinson, M.W. Woolrich, C.F. Beckmann, T.E.J. Behrens, H. Johansen-Berg, P.R. Bannister, M. De Luca, I. Drobnjak, D.E. Flitney, R. Niazy, J. Saunders, J. Vickers, Y. Zhang, N. De Stefano, J.M. Brady, and P.M. Matthews. Advances in functional and structural MR image analysis and implementation as FSL. NeuroImage, 23(S1):208-19, 2004

3. M. Jenkinson, C.F. Beckmann, T.E. Behrens, M.W. Woolrich, S.M. Smith. FSL. NeuroImage, 62:782-90, 2012 

FSL sub-references:
topup: [pulled from https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/topup]
[Andersson 2003] J.L.R. Andersson, S. Skare, J. Ashburner. How to correct susceptibility distortions in spin-echo echo-planar images: application to diffusion tensor imaging. NeuroImage, 20(2):870-888, 2003.

[Smith 2004] S.M. Smith, M. Jenkinson, M.W. Woolrich, C.F. Beckmann, T.E.J. Behrens, H. Johansen-Berg, P.R. Bannister, M. De Luca, I. Drobnjak, D.E. Flitney, R. Niazy, J. Saunders, J. Vickers, Y. Zhang, N. De Stefano, J.M. Brady, and P.M. Matthews. Advances in functional and structural MR image analysis and implementation as FSL. NeuroImage, 23(S1):208-219, 2004. 

Eddy: [pulled from https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/eddy]
[Andersson 2016a] Jesper L. R. Andersson and Stamatios N. Sotiropoulos. An integrated approach to correction for off-resonance effects and subject movement in diffusion MR imaging. NeuroImage, 125:1063-1078, 2016. 

Eddy-replace outliers:
[Andersson 2016b] Jesper L. R. Andersson, Mark S. Graham, Eniko Zsoldos and Stamatios N. Sotiropoulos. Incorporating outlier detection and replacement into a non-parametric framework for movement and distortion correction of diffusion MR images. NeuroImage, 141:556-572, 2016. 

BedpostX:
Behrens TE, Berg HJ, Jbabdi S, Rushworth MF, Woolrich MW. Probabilistic diffusion tractography with multiple fibre orientations: What can we gain? Neuroimage. 2007 Jan 1;34(1):144-55. doi: 10.1016/j.neuroimage.2006.09.018. Epub 2006 Oct 27. PMID: 17070705; PMCID: PMC7116582.

Jbabdi S, Sotiropoulos SN, Savio AM, Graña M, Behrens TE. Model-based analysis of multishell diffusion MR data for tractography: how to get over fitting problems. Magn Reson Med. 2012 Dec;68(6):1846-55. doi: 10.1002/mrm.24204. Epub 2012 Feb 14. PMID: 22334356; PMCID: PMC3359399.

BedpostX Technical Report at: https://www.fmrib.ox.ac.uk/datasets/techrep/tr03tb1/tr03tb1/index.html ;
authored by T.E.J. Behrens, M.W. Woolrich, M. Jenkinson, H. Johansen-Berg, R.G. Nunes, S. Clare, P.M Matthews, J.M. Brady and S.M. Smith

FLIRT: [in registration step] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FLIRT
Jenkinson, M., Bannister, P., Brady, J. M. and Smith, S. M. Improved Optimisation for the Robust and Accurate Linear Registration and Motion Correction of Brain Images. NeuroImage, 17(2), 825-841, 2002.

Jenkinson, M. and Smith, S. M. A Global Optimisation Method for Robust Affine Registration of Brain Images. Medical Image Analysis, 5(2), 143-156, 2001.

Greve, D.N. and Fischl, B. Accurate and robust brain image alignment using boundary-based registration. NeuroImage, 48(1):63-72, 2009. 

FNIRT [in registration step] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FNIRT
technical report: https://www.fmrib.ox.ac.uk/datasets/techrep/ Andersson JLR, Jenkinson M, Smith S (2010) Non-linear registration, aka spatial normalisation.

XTRACT: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/XTRACT
Warrington S, Bryant K, Khrapitchev A, Sallet J, Charquero-Ballester M, Douaud G, Jbabdi S*, Mars R*, Sotiropoulos SN* (2020) XTRACT - Standardised protocols for automated tractography and connectivity blueprints in the human and macaque brain. NeuroImage, 217(116923). DOI: 10.1016/j.neuroimage.2020.116923

de Groot M; Vernooij MW. Klein S, Ikram MA, Vos FM, Smith SM, Niessen WJ, Andersson JLR (2013) Improving alignment in Tract-based spatial statistics: Evaluation and optimization of image registration. NeuroImage, 76(1), 400-411. DOI: 10.1016/j.neuroimage.2013.03.015 
