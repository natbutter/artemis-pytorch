#docker build -t gmtsing .

#To run this, with an interactive python temrinal, mounting your current host directory in the container directory at /workspace use:
#sudo docker run gmtsing python3 ptBayeslands_revamp.py -p 2 -s 1000 -r 10 -t 2 -swap 2 -b 0.25 -pt 0.5 -epsilon 0.5 -rain_intervals 4

# Pull base image.
FROM ubuntu:16.04
MAINTAINER Nathaniel Butterworth

#Create some directories to work with
WORKDIR /build
RUN mkdir /project && mkdir /scratch

#Install ubuntu libraires and packages
#RUN apt-get update -y

#Install GMT
RUN apt-get update -qq && apt-get dist-upgrade -y && \
    apt install vim gmt gmt-dcw gmt-gshhg netcdf-bin -y && \
    echo "cat /etc/motd" >> /root/.bashrc

#Install a bunch of depencies for python libraries
RUN apt-get update -y && \
	apt-get install libglew-dev python3-pip python3-dev libboost-dev libboost-thread-dev libboost-program-options-dev libboost-test-dev libboost-system-dev libqtgui4 libqt4-dev libgdal-dev libcgal-dev libproj-dev libqwt-dev libfreetype6-dev libfontconfig1-dev libxrender-dev libice-dev libsm-dev git wget -y
	

RUN apt-get install make libglu1-mesa-dev freeglut3-dev -y

RUN wget https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.3.tar.gz && \
	tar -xzvf ./openmpi-1.10.3.tar.gz && \
	cd openmpi-1.10.3 && \
	./configure --prefix=/usr/local/mpi && \
	make all && \
	make install

#Download conda python and install it
#RUN wget -O ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.7.10-Linux-x86_64.sh  && \
#     chmod +x ~/miniconda.sh && \
#     ~/miniconda.sh -b -p /opt/conda && \
#     rm ~/miniconda.sh 

#Set up the conda environemnt
#COPY environment.yml environment.yml
#RUN /opt/conda/bin/conda env create -f environment.yml

RUN pip3 install -U pip  # fixes AssertionError in Ubuntu pip
RUN pip3 install enum34
#RUN LLVM_CONFIG=llvm-config-3.6 pip3 install llvmlite==0.8.0
RUN pip3 install jupyter markupsafe zmq singledispatch backports_abc certifi jsonschema ipyparallel path.py matplotlib  pandas plotly
RUN apt-get install -y libnetcdf-dev python-mpltoolkits.basemap
RUN pip3 install Cython==0.20
RUN pip3 install h5py
RUN pip3 install scipy
RUN pip3 install numpy
#RUN pip3 install numba
RUN pip3 install gFlex
#RUN pip3 install netcdf4
RUN pip3 install colorlover
RUN pip3 install cmocean
RUN pip3 install scikit-fuzzy
RUN pip3 install pyevtk

RUN git clone https://github.com/intelligentEarth/Bayeslands_continental.git 
RUN apt-get install -y gfortran 
RUN cd /build/Bayeslands_continental/badlands/utils/ && make all
#And actuall install Bayeslands to python
RUN cd /build/Bayeslands_continental/ && pip3 install -e badlands/ 

RUN cd /build && \
	git clone https://github.com/phargogh/dbfpy3.git && \
	pip3 install dbfpy3/

RUN pip3 install plotly chart-studio

RUN apt-get install -y gdal-bin python-gdal python3-gdal

#Clean up Docker build and trim packages
RUN rm -rf /var/lib/apt/lists/*

#Set up GMT
COPY version /etc/motd

#Set up an empty working directory in the container
WORKDIR /workspace
CMD /bin/bash

#Add everything to your path as needed

ENV PATH /usr/local/mpi/bin:$PATH
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/mpi/lib:/build/Bayeslands_continental/badlands/utils
ENV PYTHON_PATH $PYTHON_PATH:/build/Bayeslands_continental/badlands/utils


