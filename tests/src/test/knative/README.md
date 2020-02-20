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

# Tests for OpenWhisk Python Runtime using Knative

## Test summary

<table cellpadding="8">
  <tbody>
    <tr valign="top" align="left">
      <th width="33%">Name / Description</th>
      <th width="33%">Knative Resource Templates</th>
      <th width="33%">Runtime Payload Data</th>
    </tr>
    <!-- HelloWorld -->
    <tr align="left" valign="top">
      <td>
        <a href="helloworld">helloworld</a>
        <p><sub>A simple "Hello world" function with no parameters.</sub></p>
      </td>
      <td>
        <ul>
          <li><sub>Baked in function: <a href="helloworld/builtin-service.yaml.tmpl">builtin-service.yaml.tmpl</a></sub></li>
          <li><sub>Stemcell: <a href="helloworld/stemcell-service.yaml.tmpl">stemcell-service.yaml.tmpl</a></sub></li>
        </ul>
      </td>
      <td>
        <ul>
          <li><sub>OpenWhisk /init data: <a href="helloworld/openwhisk-data-init.json">openwhisk-data-init.json</a></sub></li>
          <li><sub>OpenWhisk /run data: <a href="helloworld/openwhisk-data-run.json">openwhisk-data-data-run.json</a></sub></li>
          <li><sub>Knative init/run: <a href="helloworld/knative-data-init-run.json">knative-data-init-run.json</a></sub></li>
          <li><sub>Knative init: <a href="helloworld/knative-data-init.json">knative-data-init.json</a></sub></li>
          <li><sub>Knative run: <a href="helloworld/knative-data-run.json">knative-data-run.json</a></sub></li>
        </ul>
      </td>
    </tr>
    <!-- HelloWorld with Params -->
    <tr align="left" valign="top">
      <td>
        <a href="helloworldwithparams">helloworldwithparams</a>
        <p><sub>A simple "Hello world" function with <em>NAME</em> and <em>PLACE</em> parameters passed via <em>main</em> function args.</sub></p>
      </td>
      <td>
        <ul>
          <li><sub>Baked in function: <a href="helloworldwithparams/builtin-service.yaml.tmpl">builtin-service.yaml.tmpl</a></sub></li>
          <li><sub>Stemcell: <a href="helloworldwithparams/stemcell-service.yaml.tmpl">stemcell-service.yaml.tmpl</a></sub></li>
        </ul>
      </td>
      <td>
        <ul>
          <li><sub>OpenWhisk /init: <a href="helloworldwithparams/openwhisk-data-init.json">openwhisk-data-init.json</a></sub></li>
          <li><sub>OpenWhisk /run: <a href="helloworldwithparams/openwhisk-data-run.json">openwhisk-data-run.json</a></sub></li>
          <li><sub>Knative init/run: <a href="helloworldwithparams/knative-data-init-run.json">knative-data-init-run.json</a></sub></li>
          <li><sub>Knative init: <a href="helloworldwithparams/knative-data-init.json">knative-data-init.json</a></sub></li>
          <li><sub>Knative run: <a href="helloworldwithparams/knative-data-run.json">knative-data-run.json</a></sub></li>
        </ul>
      </td>
    </tr>
    <!-- webactionhelloworld -->
    <tr align="left" valign="top">
      <td>
        <a href="webactionhelloworld">webactionhelloworld</a>
        <p><sub>A Web Action that takes the HTTP request's query parameters and makes them available as arguments to
        the <em>main</em> function. In this case, the value for the <em>name</em> query parameter is used in a
        Hello World function.</sub></p>
      </td>
      <td>
        <ul>
          <li><sub>Baked in function: <a href="webactionhelloworld/builtin-service.yaml.tmpl">builtin-service.yaml.tmpl</a></sub></li>
          <li><sub>Stemcell: <a href="webactionhelloworld/stemcell-service.yaml.tmpl">stemcell-service.yaml.tmpl</a></sub></li>
        </ul>
      </td>
      <td>
        <ul>
          <li><sub>OpenWhisk /init: <a href="webactionhelloworld/openwhisk-data-init.json">openwhisk-data-init.json</a></sub></li>
          <li><sub>OpenWhisk /run: <a href="webactionhelloworld/openwhisk-data-run.json">openwhisk-data-run.json</a></sub></li>
          <li><sub>Knative init/run: <a href="webactionhelloworld/knative-data-init-run.json">knative-data-init-run.json</a></sub></li>
          <li><sub>Knative init: <a href="webactionhelloworld/knative-data-init.json">knative-data-init.json</a></sub></li>
          <li><sub>Knative run: <a href="webactionhelloworld/knative-data-run.json">knative-data-run.json</a></sub></li>
        </ul>
      </td>
    </tr>
  </tbody>
</table>

# Running the Tests

This is the typical process for running each of the tests under this directory.

## Pre-requisite
Set up a [Docker Hub](https://hub.docker.com/) account and set the environment variable `DOCKER_USERNAME` to your username on Docker Hub.
```bash
export DOCKER_USERNAME="myusername"
```
### Build the Docker Image
Build a Docker image `$DOCKER_USERNAME/action-python` and push it to Docker Hub:
```bash
docker build -t $DOCKER_USERNAME/action-python ../../../../core/pythonAction/Dockerfile && docker push $DOCKER_USERNAME/action-python
```
## Running the test cases
After this is set up, you run the remaining commands under the individual subdirectories.

### Configure and Deploy Service YAML
```bash
sed 's/DOCKER_USERNAME/'"$DOCKER_USERNAME"'/' builtin-service.yaml.tmpl > builtin-service.yaml
sed 's/DOCKER_USERNAME/'"$DOCKER_USERNAME"'/' stemcell-service.yaml.tmpl > stemcell-service.yaml
```
After that you will need to deploy either
for the code already baked into the container:
```bash
kubectl apply -f builtin-service.yaml
```
or for an undifferentiated stem cell:
```bash
kubectl apply -f stemcell-service.yaml
```
You may also change the environment variable `__OW_RUNTIME_PLATFORM` to `openwhisk`. Note that if this environment variable is not present, the runtime will default to `openwhisk` behaviors.

## Running the Test on different platforms

Depending on the value you set in *-service.yaml files above for the ```__OW_RUNTIME_PLATFORM``` environment variable, you will need to invoke different endpoints to execute the test.

Currently, the following platform (values) are supported:
- openwhisk
- knative

---

## Running with `__OW_RUNTIME_PLATFORM` set to "knative"

Under the Knative platform, the developer has 2 choices:
1. Use the Knative "builtin" service to "bake the function" into the runtime resulting in a dedicated runtime
(service) container for your running a specific function.
2. Use Knative "stemcell" service to create a "stem cell" runtime that allows some control plane to inject the function
dynamically.

However, as OW runtimes do not allow "re-initialization" at this time, once you send the "init data" once to the runtime you
cannot send it again or it will result in an error.

Below are some options for invoking the endpoint (route) manually using common developer tooling
in conjunction with prepared data:

#### Using the 'curl' command

Simply send the *"init-run"* data to the base *'/'* route on the runtime (service) endpoint. 

If your function requires no input data on the request:

```
curl -H "Host: <hostname>" -X POST http://localhost/
```

otherwise, you can supply the request data and ```Content-Type``` on the command and pass the JSON data to your function via data file:

```
curl -H "Host: <hostname>" -d "@data-init-run.json" -H "Content-Type: application/json" http://localhost/
```

please note that the *"activation"* data is also provided, but defaulted in most cases as these would
be provided by a control-plane which would manage pools of the runtimes and track Activations.

---

## Running with OW_RUNTIME_PLATFORM set to "openwhisk"

The standard OW methods used to run functions is done through calls to 2 separte endpoints.
In short, The control plane would:

1. first, invoke the */init* route with strictly the OW "init. data" (JSON format) including the funtional
code itself.
2. then, invoke */run* route which executes the function (i.e., Activates the function) with caller-provided
parameters via OW "value data" (JSON format) along with per-activation information which would normally be
provided and tracked by the control plane (default/dummy key-values provided for tests).

Below are some options for invoking these routes manually using common developer tooling
in conjunction with prepared data:

### Using the 'curl' command to run

#### Initialize the runtime

Initialize the runtime with the function and other configuration data using the ```/init``` endpoint.

```bash
curl -H "Host: <hostname>" -d "@data-init.json" -H "Content-Type: application/json" http://localhost/init
```

#### Run the function

Execute the function using the ```/run``` endpoint.

with no request data:

```bash
curl -H "Host: <hostname>" -X POST http://localhost/run
```

or with request data and its ```Content-Type```:

```bash
curl -H "Host: <hostname>" -d "@data-run.json" -H "Content-Type: <content-type>" -X POST http://localhost/run
```
