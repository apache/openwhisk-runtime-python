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
[![Build Status](https://travis-ci.com/apache/openwhisk-runtime-python.svg?branch=master)](https://travis-ci.com/apache/openwhisk-runtime-python)

## Build Runtimes

The runtimes are built using Gradle.
The file [settings.gradle](settings.gradle) lists the images that are build by default.
To build all those images, run the following command.

```
./gradlew distDocker
```

You can optionally build a specific image by modifying the Gradle command. For example:
```
./gradlew core:python3ActionLoop:distDocker
```

The build will produce Docker images such as `actionloop-python-v3.7`
and will also tag the same image with the `whisk/` prefix. The latter
is a convenience, which if you're testing with a local OpenWhisk
stack, allows you to skip pushing the image to Docker Hub.

The image will need to be pushed to Docker Hub if you want to test it
with a hosted OpenWhisk installation.

### Using Gradle to push to a Docker Registry

The Gradle build parameters `dockerImagePrefix` and `dockerRegistry`
can be configured for your Docker Registery. Make usre you are logged
in first with the `docker` CLI.

- Use the `docker` CLI to login. The following assume you will substitute `$DOCKER_USER` with an appropriate value.
  ```
  docker login --username $DOCKER_USER
  ```

- Now build, tag and push the image accordingly.
  ```
  ./gradlew distDocker -PdockerImagePrefix=$DOCKER_USER -PdockerRegistry=docker.io
  ```

### Using Your Image as an OpenWhisk Action

You can now use this image as an OpenWhisk action. For example, to use
the image `actionloop-python-v3.7` as an action runtime, you would run
the following command.

```
wsk action update myAction myAction.py --docker $DOCKER_USER/actionloop-python-v3.7
```

## Test Runtimes

There are suites of tests that are generic for all runtimes, and some that are specific to a runtime version.
To run all tests, there are two steps.

First, you need to create an OpenWhisk snapshot release. Do this from your OpenWhisk home directory.
```
./gradlew install
```

Now you can build and run the tests in this repository.
```
./gradlew tests:test
```

Gradle allows you to selectively run tests. For example, the following
command runs tests which match the given pattern and excludes all
others.
```
./gradlew :tests:test --tests *ActionLoopContainerTests*
```

## Python 3 AI Runtime
This action runtime enables developers to create AI Services with OpenWhisk. It comes with preinstalled libraries useful for running machine learning and deep learning inferences. [Read more about this runtime here](./core/python3AiActionLoop).

## Import Project into IntelliJ

Follow these steps to import the project into your IntelliJ IDE.
- Import project as gradle project.
- Make sure working directory is root of the project/repo.
