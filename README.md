Docker repo for gmt and python bayselands


```
cd /project/Training/NAT
git clone https://github.com/intelligentEarth/Bayeslands_continental.git
qsub sing.pbs
```

#To get this repo and scripts or to build
```
git clone https://github.com/natbutter/gmtsing.git
sudo docker build gmtsing .
#or
sudo singularity build gmtsing.img singbayes.build
```

To run with docker:
```
sudo docker run --rm -v `pwd`:/workspace gmtsing python3 ptBayeslands_revamp.py -p 2 -s 10 -r 10 -t 2 -swap 2 -b 0.25 -pt 0.5 -epsilon 0.5 -rain_intervals 4
```

To run with singularity in a PBS jobscript:
```
#!/bin/bash
#PBS -P Training
#PBS -N mybadlandsrun
#PBS -l select=1:ncpus=10:mem=60gb
#PBS -l walltime=24:00:00
#PBS -q defaultQ

module load singularity

cd $PBS_O_WORKDIR/Bayeslands_continental

singularity exec -B $PBS_O_WORKDIR/Bayeslands_continental/:/project $PBS_O_WORKDIR/gmtsing.img python3 ptBayeslands_revamp.py -p 2 -s 10 -r 10 -t 2 -swap 2 -b 0.25 -pt 0.5 -epsilon 0.5 -rain_intervals 4
singularity exec -B $PBS_O_WORKDIR/Bayeslands_continental/:/project $PBS_O_WORKDIR/gmtsing.img python3 visualise.py -p 2 -s 10 -r 10 -t 2 -swap 2 -b 0.25 -pt 0.5 -epsilon 0.5 -rain_intervals 4
```
 
