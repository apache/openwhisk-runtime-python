<!--
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
-->

# Apache OpenWhisk runtimes for Python
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)
[![Build Status](https://travis-ci.org/apache/incubator-openwhisk-runtime-python.svg?branch=master)](https://travis-ci.org/apache/incubator-openwhisk-runtime-python)


### Give it a try today
To use as a docker action using python 3
```
wsk action update myAction myAction.py --docker openwhisk/python3action:1.0.2
```
Replace `python3action` with `python2action` to use python 2.


### To use on deployment that contains the rutime as a kind
To use as a kind action using python 3
```
wsk action update myAction myAction.py --kind python:3
```
Replace `python:3` with `python:2` to use python 2.


### Python 3 AI Action
This action enables developers to create AI Services with OpenWhisk. It comes with preinstalled libraries useful for running machine learning and deep learning inferences. See more about [python3aiaction](./core/python3AiAction).

### Local development
```
./gradlew core:pythonAction:distDocker
```
This will produce the image `whisk/python3action`

Build and Push image
```
docker login
./gradlew core:pythonAction:distDocker -PdockerImagePrefix=$prefix-user -PdockerRegistry=docker.io
```
Replace `core:pythonAction` with `core:python2Action` to build python 2 instead.

Deploy OpenWhisk using ansible environment that contains the kind `python:3` and `python:2`
Assuming you have OpenWhisk already deploy localy and `OPENWHISK_HOME` pointing to root directory of OpenWhisk core repository.

Set `ROOTDIR` to the root directory of this repository.

Redeploy OpenWhisk
```
cd $OPENWHISK_HOME/ansible
ANSIBLE_CMD="ansible-playbook -i ${ROOTDIR}/ansible/environments/local"
$ANSIBLE_CMD setup.yml
$ANSIBLE_CMD couchdb.yml
$ANSIBLE_CMD initdb.yml
$ANSIBLE_CMD wipe.yml
$ANSIBLE_CMD openwhisk.yml
```

Or you can use `wskdev` and create a soft link to the target ansible environment, for example:
```
ln -s ${ROOTDIR}/ansible/environments/local ${OPENWHISK_HOME}/ansible/environments/local-python
wskdev fresh -t local-python
```

To use as docker action push to your own dockerhub account
```
docker tag whisk/python3action $user_prefix/python
docker push $user_prefix/python3action
```
Then create the action using your the image from dockerhub
```
wsk action update myAction myAction.py --docker $user_prefix/python3action
```
The `$user_prefix` is usually your dockerhub user id.
Replace `python3action` with `python2action` to use python 2

### Testing
Install dependencies from the root directory on $OPENWHISK_HOME repository
```
./gradlew install
```

Using gradle for the ActionContainer tests you need to use a proxy if running on Mac, if Linux then don't use proxy options
You can pass the flags `-Dhttp.proxyHost=localhost -Dhttp.proxyPort=3128` directly in gradle command.
Or save in your `$HOME/.gradle/gradle.properties`
```
systemProp.http.proxyHost=localhost
systemProp.http.proxyPort=3128
```
Using gradle to run all tests
```
./gradlew :tests:test
```
Using gradle to run some tests
```
./gradlew :tests:test --tests *ActionContainerTests*
```
Using IntelliJ:
- Import project as gradle project.
- Make sure working directory is root of the project/repo
- Add the following Java VM properties in ScalaTests Run Configuration, easiest is to change the Defaults for all ScalaTests to use this VM properties
```
-Dhttp.proxyHost=localhost
-Dhttp.proxyPort=3128
```

# Disclaimer

Apache OpenWhisk Runtime Python is an effort undergoing incubation at The Apache Software Foundation (ASF), sponsored by the Apache Incubator. Incubation is required of all newly accepted projects until a further review indicates that the infrastructure, communications, and decision making process have stabilized in a manner consistent with other successful ASF projects. While incubation status is not necessarily a reflection of the completeness or stability of the code, it does indicate that the project has yet to be fully endorsed by the ASF.
