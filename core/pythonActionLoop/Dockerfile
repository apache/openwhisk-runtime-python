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
FROM golang:1.11 as builder
ENV PROXY_SOURCE=https://github.com/apache/incubator-openwhisk-runtime-go/archive/golang1.11@1.13.0-incubating.tar.gz
RUN curl -L "$PROXY_SOURCE" | tar xzf - \
  && mkdir -p src/github.com/apache \
  && mv incubator-openwhisk-runtime-go-golang1.11-v1.13.0-incubating \
     src/github.com/apache/incubator-openwhisk-runtime-go \
  && cd src/github.com/apache/incubator-openwhisk-runtime-go/main \
  && CGO_ENABLED=0 go build -o /bin/proxy

FROM python:3.7-stretch

# Install common modules for python
RUN pip install \
    beautifulsoup4==4.6.3 \
    httplib2==0.11.3 \
    kafka_python==1.4.3 \
    lxml==4.2.5 \
    python-dateutil==2.7.3 \
    requests==2.19.1 \
    scrapy==1.5.1 \
    simplejson==3.16.0 \
    virtualenv==16.0.0 \
    twisted==18.7.0

RUN mkdir -p /action
WORKDIR /
COPY --from=builder /bin/proxy /bin/proxy
ADD pythonbuild.py /bin/compile
ADD pythonbuild.py.launcher.py /bin/compile.launcher.py
ENV OW_COMPILER=/bin/compile
ENTRYPOINT []
CMD ["/bin/proxy"]

