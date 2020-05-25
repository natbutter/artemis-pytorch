#!/bin/bash

#A singularity script to run the repo
#https://github.com/natbutter/artemis-pytorch.git
#Developed in the docker cotainer
#If you use this script you must acknowledge SIH 
#"The authors acknowledge the technical assistance provided by the Sydney Informatics Hub, a Core Research Facility of the University of Sydney."

#PBS -P CCSIH
#PBS -N myrun
#PBS -l select=1:ncpus=1:mem=1gb:ngpus=1
#PBS -l walltime=00:01:00
#PBS -q defaultQ

module load singularity
module load cuda/10.1.105

cd $PBS_O_WORKDIR

#Mount the current directory in the container at /project, change directories and execute your script
singularity exec --nv -B $PBS_O_WORKDIR:/project $PBS_O_WORKDIR/pyslowfast.img /bin/bash -c "cd /project/CCSIH/artemis-pytorch && python testGPU.py"
