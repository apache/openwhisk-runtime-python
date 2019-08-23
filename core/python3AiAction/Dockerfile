#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Dockerfile for python AI actions, overrides and extends ActionRunner from actionProxy
FROM tensorflow/tensorflow:1.11.0-py3

ENV FLASK_PROXY_PORT 8080
ENV PYTHONIOENCODING "UTF-8"

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
        gcc \
        libc-dev \
        libxslt-dev \
        libxml2-dev \
        libffi-dev \
        libssl-dev \
        zip \
        unzip \
        vim \
        && rm -rf /var/lib/apt/lists/*

RUN apt-cache search linux-headers-generic

# PyTorch
RUN pip3 install http://download.pytorch.org/whl/cpu/torch-0.4.1-cp35-cp35m-linux_x86_64.whl \
    && pip3 install torchvision==0.2.1
# Caffe
# RUN apt-get update && apt-get upgrade -y \
#     && apt-get install -y \
#     build-essential cmake git pkg-config \
#     libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler \
#     && apt-get install -y --no-install-recommends libboost-all-dev

RUN curl -L https://downloads.rclone.org/rclone-current-linux-amd64.deb -o rclone.deb \
    && dpkg -i rclone.deb \
    && rm rclone.deb

COPY requirements.txt requirements.txt
RUN pip3 install --upgrade pip six && pip3 install --no-cache-dir -r requirements.txt

RUN mkdir -p /actionProxy
ADD https://raw.githubusercontent.com/apache/openwhisk-runtime-docker/dockerskeleton%401.3.3/core/actionProxy/actionproxy.py /actionProxy/actionproxy.py

RUN mkdir -p /pythonAction
COPY pythonrunner.py /pythonAction/pythonrunner.py

CMD ["/bin/bash", "-c", "cd /pythonAction && python -u pythonrunner.py"]
