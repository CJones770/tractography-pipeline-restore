README - dwi-pipeline version 0.0.1 developed by Corey Jones - May 6th 2022

This pipeline was developed to preprocess raw diffusion weighted image data of patients with Early Psychosis provided by the Human Connectome Project (HCP) to prepare them for probabalistic tractography.

An independent, similar pipeline developed by the University of Washington is available on the HCP official website and on the U-Washington Github at either of the following links:

https://github.com/Washington-University/HCPpipelines && https://www.humanconnectome.org/software/hcp-mr-pipelines

Both (my and the official) pipelines rely on NVIDIA's CUDA toolkit for gpu acceleration/parallelization, and therefore nvidia's docker container runtime toolkit should be installed prior to starting the container if it has not been installed already. This can be achieved by running  : 
apt-get install nvidia-docker2 [for docker versions 19.03 or newer]

OR:

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

and subsequently restarting the docker daemon with sudo system (or systemtcl) docker restart (depending on how you have installed docker).

** The above steps were pulled from the official Nvidia website at https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker **

This pipeline is designed to run in a docker container that mounts a subject directory and five output directories from the host machine.

This mounting is performed when calling 'docker run' on the image file e.g.,
If the image is tagged "dwi-pipeline:latest", one may mount their directories by running the following command:

docker run -it --rm --runtime=nvidia -v /Path/to/local_Subject_Data:/Path/inContainer -v /Path/to/local_OutputFolder/1:/Outputs/1 /-v Path/to/local_OutputFolder/2:/Outputs/2 -v /Path/to/local_OutputFolder/3:/Outputs/3 -v /Path/to/local_OutputFolder/4:/Outputs/4 -v /Path/to/local_OutputFolder/X:/Outputs/X --name choose_name_for_container dwi-pipeline:latest

where -it runs the container in an interactive terminal, --rm declares the container shall be removed when stopped, runtime=nvidia enables the CUDA toolkit (CUDA8.0 in this case) -v specifies each volume to be mounted from the host machine to the container, the name of the container is arbitrary, and the final input is the image name with its tag i.e., dwi-pipeline:latest or equivalent as stored on the host machine.

To run in full one must call the 'mini_Runner.sh' script located in the Pipeline's bin, which exists in the container path /opt/Pipeline/Pipeline/Pipeline/bin/ ; 
i.e., once in the container's interactive terminal, one must navigate to the directory with cd /opt/Pipeline/Pipeline/Pipeline/bin/ and then run ./mini_Runner.sh with the following inputs

/Path/to/SubjectDirectory /Path/to/OutputFolder1 /Path/to/OutputFolder2 /Path/to/OutputFolder3 /Path/to/OutputFolder4 /Path/to/OutputFolderX as they have been defined in the container during the mounting step;

working examples of this syntax from building the docker container to executing the main run script:

1:
sudo docker run -it --rm --runtime=nvidia -v /home/corey/P_samples:/SubjDir -v /home/corey/pipeline-test-outputs/1o:/TO/1o -v /home/corey/pipeline-test-outputs/2o:/TO/2o -v /home/corey/pipeline-test-outputs/3o:/TO/3o -v /home/corey/pipeline-test-outputs/4o:/TO/4o -v /home/corey/pipeline-test-outputs/Xo:/TO/Xo --name dwi-pipeline dwi-pipeline:latest

2: 
cd /opt/Pipeline/Pipeline/Pipeline/bin

3:
./mini_Runner.sh /SubjDir /TO/1o /TO/2o /TO/3o /TO/4o /TO/Xo

**NOTE: it is important to not include any additional forward slashes in the above steps **

If all is properly setup, these 3 functions should initiate the pipeline. This will run over each subject in the specified directory. The outputs of pipeline stages 1 through 4 will be stored in the directories /TO/1o - /TO/4o (short for Test Outputs 1 - 4), and tractography data will be stored in /TO/Xo .

It is crucial that input data in /SubjDir are named and stored appropriately i.e., with the form and path specified as follows:
/SubjDir/sub_##/dwi/sub-##_acq-dir107_AP_dwi.nii.gz , /SubjDir/sub_##/dwi/sub-##_acq-dir107_PA_dwi.nii.gz , /SubjDir/sub_##/dwi/sub-##_acq-dir107_PA_dwi.bval , and /SubjDir/sub_##/dwi/sub-##_acq-dir107_PA_dwi.bvec ;
Where /SubjDir is an arbitrarily named subject directory and ## is a 2 digit number specifying the subject ID. The list must start at 01 and increase incrementally. AP refers to the Anterior Posterior principal encoding direction and PA to its reverse; the bval and bvec files are sourced from the posterior-anterior encoding direction in this pipeline (but theoretically can be sourced from either).

The amount of disk space needed per subject is approximately : 9GB. Ultimately ~6GB are stored in the output directories.

The estimated run time from denoising to the completion of tractography using FSL's Xtract i.e., the whole pipeline [while utilizing an NVIDIA 1070ti graphics card] is : 3hrs50minutes per subject

One may choose to stop the pipeline short, i.e., before diffusor tensors are estimated by running ./short_Runner.sh with the same syntax as seen in the above example: Runtime is ~1hour/subject. This will stop the Pipeline after performing Eddy correction and QC report building i.e., after stage 2.

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
eddy_quad [FSL]  [Performs quality control analysis and stores reports in defined second output directory e.g., /TO/2o/...]

Stage 3 [FSLmaths & utils] - Runtime = ~2.5minutes/subject [Generates 'no_dif' brain images, anatomical brain masks, and smoothed copies thereof]

Stage 4 - Runtime =     ~TBD

bedpostx_gpu [FSL]      ~45 minutes/subject [Bayesian Estimation of Diffusion Parameters Obtained using Sampling Techniques, X stands for crossing fibre models]
registration [FSL]      ~30-45 minutes/subject [Anatomical registration of diffusion data]
xtract* [FSL]           ~1hour30minutes/subject [probabalistic tractography method that utilizes ~40 predefined regions of interest] 
*Runtime can be cut down by selecting specific tracts in a structs.txt file [not compatible with current dockerized version]

Pipeline total runtime = ~
Short pipeline total runtime = ~1 hour/subject

Runtime estimates were made while using an NVIDIA-1070-TI graphics card with 8GB of memory. Runtimes for eddy_cuda8.0,bedpostx_gpu, and xtract are affected by GPU memory availability.
