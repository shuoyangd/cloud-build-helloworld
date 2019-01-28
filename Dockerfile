FROM debian:stable

MAINTAINER Shuoyang Ding <dings@jhu.edu>
LABEL description=""

# update debian
RUN apt-get update
RUN apt-get install apt-utils -y
RUN apt-get update && apt-get -y upgrade

# install java
RUN apt-get install default-jre -y

# get ducttape
RUN apt-get install wget -y
RUN wget http://www.cs.jhu.edu/~sding/downloads/ducttape.tar
RUN tar -xvf ducttape.tar
RUN chmod +x ducttape
RUN mv ducttape ducttape.jar bin/
