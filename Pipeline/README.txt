README - dwi-pipeline version 1.0.0 developed by Corey Jones - May 6th 2022

This pipeline has been developed to preprocess raw diffusion weighted image data provided by the Human Connectome Project (HCP) to prepare them for probabalistic tractography.

This iteration is designed to run in a docker container that mounts a subject directory and five output directories from the host machine.

This mounting is performed when calling 'docker run' on the image file e.g.,
If the image is tagged "dwi-pipeline:latest", one may mount their directories by running the following command:

docker run -it -v /Path/to/Subject_Data:/Path/inContainer -v /Path/to/OutputFolder/1:/Outputs/1 /-v Path/to/OutputFolder/2:/Outputs/2 -v /Path/to/OutputFolder/3:/Outputs/3 -v /Path/to/OutputFolder/4:/Outputs/4 -v /Path/to/OutputFolder/X:/Outputs/X --name choose_name_for_container dwi-pipeline:latest

where -it runs the container in an interactive terminal, -v specifies each volume to be mounted from the host machine to the container, the name of the container is arbitrary, and the final input is the image name with its tag i.e., dwi-pipeline:latest

To run in full one must call the 'mini_Runner.sh' script located in the Pipeline's bin, which exists in the container path /opt/Pipeline/Pipeline/Pipeline/bin/ ; 
i.e., once in the container's interactive terminal, one must navigate to the directory with cd /opt/Pipeline/Pipeline/Pipeline/bin/ and then run ./mini_Runner.sh with the following inputs

Path/to/SubjectDirectory Path/to/OutputFolder1 Path/to/OutputFolder2 Path/to/OutputFolder3 Path/to/OutputFolder4 Path/to/OutputFolderX ;

working examples of this syntax in whole, 

