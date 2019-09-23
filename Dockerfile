#Dockerfile to run https://github.com/intelligentEarth/Bayeslands-basin-continental.git

#If you make use of this image, please acknowledge 
#Sydney Informatics Hub at the University of Sydney
#https://informatics.sydney.edu.au/

#Build with:
#sudo docker build . -t pybad 

#Or pull from DockerHub at
#docker pull nbutter/pybad

#Run with:
#sudo docker run -it -v `pwd`:/workspace pybad

#Typical commands to run ptBayeslands in the directory
#python ptBayeslands.py -p 1 -s 100 -r 10 -t 2 -swap 2 -b 0.25 -pt 0.5  -epsilon 0.5 -rain_intervals 4
#python visualise.py -p 1 -s 100 -r 10 -t 2 -swap 2 -b 0.25 -pt 0.5  -epsilon 0.5 -rain_intervals 4

#A version of Bayeslands-basin-continental is in /workspace/Bayeslands-basin-continental, 
#but you could bind in your local copy too (with -v flag

# Pull base image.
FROM badlandsmodel/pybadlands-dependencies

MAINTAINER Nathaniel Butterworth

#Update and install all required linux packages
RUN apt-get update -y
RUN apt-get install make libtiff4-dev libglu1-mesa-dev freeglut3-dev wget -y
RUN wget https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.3.tar.gz && \
	tar -xzvf ./openmpi-1.10.3.tar.gz && \
	cd openmpi-1.10.3 && \
	./configure --prefix=/usr/local/mpi && \
	make all && \
	make install

#Install additional Python modules
RUN pip install seaborn==0.8.1 tensorflow==1.9.0 lavavu==1.3

#Install bayeslands repo
WORKDIR /workspace
RUN git clone https://github.com/intelligentEarth/Bayeslands-basin-continental.git && \
	cd Bayeslands-basin-continental/pyBadlands/libUtils && \
	make all

#Add everything to your path as needed
WORKDIR /workspace
ENV PATH /usr/local/mpi/bin:$PATH
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/mpi/lib:/workspace/Bayeslands-basin-continental/pyBadlands/libUtils
ENV PYTHON_PATH $PYTHON_PATH:/workspace/Bayeslands-basin-continental/pyBadlands/libUtils

#And actuall install Bayeslands to python
RUN pip install -e Bayeslands-basin-continental/
WORKDIR /workspace/Bayeslands-basin-continental
