Docker/Singularity repo for pytorch and https://github.com/facebookresearch/SlowFast

If you have used this work, you must acknoledge SIH, e.g:
"The authors acknowledge the technical assistance provided by the Sydney Informatics Hub, a Core Research Facility of the University of Sydney."


To get this repo and scripts or to build
```
git clone https://github.com/natbutter/artemis-pytorch.git
sudo docker build  . -t pyslowfast 
#or
sudo singularity build pyslowfast.img pyslowfast.build
```

To run a Python script (e.g. testGPU.py) in the current directory mounting inside the container, with docker:
```
sudo docker run -v `pwd`:/build pyslowfast python testGPU.py`
```


To run with singularity in a PBS jobscript:
```
#!/bin/bash
#PBS -P <yourproject> 
#PBS -N myrun 
#PBS -l select=1:ncpus=1:mem=1gb:ngpus=1
#PBS -l walltime=00:01:00
#PBS -q defaultQ

module load singularity

cd $PBS_O_WORKDIR

#Mount the current directory in the container at /project, change directories and run your script
singularity exec -B $PBS_O_WORKDIR:/project $PBS_O_WORKDIR/pyslowfast.img cd /project && python testGPU.py 
```
 
