FROM ubuntu:18.04

ADD app/ app/

RUN apt-get update -y

#Python3 and packages
RUN apt-get install -y python3.8
RUN echo "alias python3=python3.8" >> ~/.bashrc
RUN apt-get install -y python3-biopython

#Blast and muscle
RUN tar -zxvf app/ncbi-blast.tar.gz
RUN cp -r ncbi-blast-2.12.0+ app/
RUN rm -r ncbi-blast-2.12.0+

#IQtree
RUN tar -zxvf app/iqtree-1.6.12-Linux.tar.gz
RUN cp -r iqtree-1.6.12-Linux app/
RUN rm -r iqtree-1.6.12-Linux

RUN echo "Hello from inside"

ENV PATH "$PATH:/app/ncbi-blast-2.12.0+/bin/:app/iqtree-1.6.12-Linux/bin"