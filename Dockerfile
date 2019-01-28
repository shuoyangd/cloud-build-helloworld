FROM python:3.6-stretch
MAINTAINER Shuoyang Ding <dings@jhu.edu>
WORKDIR /root/
RUN apt-get update && apt-get install apt-utils -y && apt-get update && apt-get -y upgrade
RUN apt-get install default-jre wget git -y
RUN wget http://www.cs.jhu.edu/~sding/downloads/ducttape.tar && tar -xvf ducttape.tar && chmod +x ducttape && mv ducttape ducttape.jar /bin/
RUN python -m venv pytorch \
    && /bin/bash -c "source pytorch/bin/activate" \
    && pip install https://download.pytorch.org/whl/cpu/torch-1.0.0-cp36-cp36m-linux_x86_64.whl
RUN git clone https://github.com/shuoyangd/cloud-build-helloworld

# run the test
CMD cd cloud-build-helloworld && dducttape test.tape
