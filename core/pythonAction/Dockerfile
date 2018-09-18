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

# Dockerfile for python actions, overrides and extends ActionRunner from actionProxy
FROM openwhisk/dockerskeleton:latest

RUN apk add --no-cache \
        bzip2-dev \
        gcc \
        libc-dev \
        libxslt-dev \
        libxml2-dev \
        libffi-dev \
        linux-headers \
        openssl-dev

# Install common modules for python
RUN pip install \
    beautifulsoup4==4.5.3 \
    httplib2==0.10.3 \
    kafka_python==1.3.4 \
    lxml==3.7.3 \
    python-dateutil==2.6.0 \
    requests==2.13.0 \
    scrapy==1.3.3 \
    simplejson==3.10.0 \
    virtualenv==15.1.0 \
    twisted==17.1.0

ENV FLASK_PROXY_PORT 8080

RUN mkdir -p /pythonAction
ADD pythonrunner.py /pythonAction/
RUN rm -rf /action

CMD ["/bin/bash", "-c", "cd pythonAction && python -u pythonrunner.py"]
