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

# build go proxy from source
FROM golang:1.15 AS builder_source
ARG GO_PROXY_GITHUB_USER=apache
ARG GO_PROXY_GITHUB_BRANCH=master
RUN git clone --branch ${GO_PROXY_GITHUB_BRANCH} \
   https://github.com/${GO_PROXY_GITHUB_USER}/openwhisk-runtime-go /src ;\
   cd /src ; env GO111MODULE=on CGO_ENABLED=0 go build main/proxy.go && \
   mv proxy /bin/proxy

# or build it from a release
FROM golang:1.15 AS builder_release
ARG GO_PROXY_RELEASE_VERSION=1.15@1.16.0
RUN curl -sL \
  https://github.com/apache/openwhisk-runtime-go/archive/{$GO_PROXY_RELEASE_VERSION}.tar.gz\
  | tar xzf -\
  && cd openwhisk-runtime-go-*/main\
  && GO111MODULE=on go build -o /bin/proxy

FROM python:2.7-alpine
# select the builder to use
ARG GO_PROXY_BUILD_FROM=release

# Upgrade and install basic Python dependencies
RUN apk add --no-cache \
        bash \
        bzip2-dev \
        gcc \
        libc-dev \
        libxslt-dev \
        libxml2-dev \
        libffi-dev \
        linux-headers \
        openssl-dev \
        python-dev

# Install common modules for python
RUN pip install --no-cache-dir --upgrade pip setuptools six \
 && pip install --no-cache-dir \
        gevent==1.3.6 \
        flask==1.0.2 \
        beautifulsoup4==4.6.3 \
        httplib2==0.11.3 \
        kafka_python==1.4.3 \
        lxml==4.2.5 \
        python-dateutil==2.7.3 \
        requests==2.19.1 \
        scrapy==1.5.1 \
        simplejson==3.16.0 \
        virtualenv==16.0.0 \
        twisted==18.7.0 \
        signalfx_lambda==0.2.1

RUN mkdir -p /action
WORKDIR /
COPY --from=builder_source /bin/proxy /bin/proxy_source
COPY --from=builder_release /bin/proxy /bin/proxy_release
RUN mv /bin/proxy_${GO_PROXY_BUILD_FROM} /bin/proxy

ADD bin/compile /bin/compile
ADD lib/launcher.py /lib/launcher.py
# the compiler script
ENV OW_COMPILER=/bin/compile
# log initialization errors
ENV OW_LOG_INIT_ERROR=1
# the launcher must wait for an ack
ENV OW_WAIT_FOR_ACK=1
# using the runtime name to identify the execution environment
ENV OW_EXECUTION_ENV=openwhisk/action-python-v2.7
ENTRYPOINT ["/bin/proxy"]
