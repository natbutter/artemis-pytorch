#docker build -t pyfastslow .

#To run this, with an interactive python temrinal, mounting your current host directory in the container directory at /workspace use:
#sudo docker -it run pyfastslow python

# Pull base image.
FROM nvidia/cuda:10.1-devel-ubuntu16.04 
MAINTAINER Nathaniel Butterworth USYD SIH

#Create some directories to work with on Artmeis
RUN mkdir /project && mkdir /scratch

#Install ubuntu libraires and packages
RUN apt-get update -y && \
	apt-get install git curl -y && \
	rm -rf /var/lib/apt/lists/*
	
#Set some environemnt variables we will need
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
ENV PYTHONPATH $PYTHONPATH:/build/slowfast/slowfast

WORKDIR /root

#Install Python3.6 we can use
RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-4.3.27.1-Linux-x86_64.sh &&\
	mkdir /root/.conda && \
	bash Miniconda3-4.3.27.1-Linux-x86_64.sh -b &&\
	rm -rf /Miniconda3-4.3.27.1-Linux-x86_64.sh

WORKDIR /build

#Install packages
RUN conda install pip
RUN pip install --upgrade pip
RUN conda install pytorch=1.5.0 torchvision=0.6.0 cudatoolkit=10.1 -c pytorch
RUN pip install simplejson==3.17.0 av==8.0.1 psutil==5.7.0 opencv-python==4.2.0.34 && \
	pip install Cython==0.29.19 && \
	pip install pycocotools==2.0.0
RUN pip install -U 'git+https://github.com/facebookresearch/fvcore.git' 
RUN git clone https://github.com/facebookresearch/detectron2 detectron2_repo && \
	pip install -e detectron2_repo
RUN git clone https://github.com/facebookresearch/slowfast &&\
	cd slowfast && python setup.py build develop

#Run the container	
CMD /bin/bash




