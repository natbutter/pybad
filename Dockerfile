#Dockerfile to install an interactive GPLATES 2.1 instance
#This uses OpenGL and if you have an NVIDIA card you will
#need to allow the GUI to run on the NVIDIA drivers.
#Hence, the weird choice of base image being from NVIDIA opengl.
#If you make use of this image, please acknoledge 
#Sydney Informatics Hub at the University of Sydney
#https://informatics.sydney.edu.au/

#Build with:
#sudo docker build . -t dockplates

#Run with:
#sudo nvidia-docker run --rm -it -v `pwd`:/workspace -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY dockplates

# Pull base image.
FROM badlandsmodel/pybadlands-dependencies

MAINTAINER Nathaniel Butterworth

RUN apt-get update -y

RUN apt-get install make libtiff4-dev libglu1-mesa-dev freeglut3-dev wget -y

RUN wget https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.3.tar.gz && \
	tar -xzvf ./openmpi-1.10.3.tar.gz && \
	cd openmpi-1.10.3 && \
	./configure --prefix=/usr/local/mpi && \
	make -j all && \
	make install

RUN pip install seaborn==0.8.1 tensorflow==1.9.0 lavavu==1.3

WORKDIR /workspace
RUN git clone https://github.com/intelligentEarth/Bayeslands-basin-continental.git && \
	cd Bayeslands-basin-continental/pyBadlands/libUtils && \
	make all

WORKDIR /workspace

ENV PATH /usr/local/mpi/bin:$PATH
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/mpi/lib:/workspace/Bayeslands-basin-continental/pyBadlands/libUtils
ENV PYTHON_PATH $PYTHON_PATH:/workspace/Bayeslands-basin-continental/pyBadlands/libUtils

RUN pip install -e Bayeslands-basin-continental/



#
#