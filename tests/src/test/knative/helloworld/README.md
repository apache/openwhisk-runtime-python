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

# Hello World Test for OpenWhisk Python Runtime using Knative

## Prerequisite
In the service Yaml files you need to replace `DOCKER_USERNAME` with your docker hub username.

## Running the test using the "Curl" command

Depending on the value you set for the ```__OW_RUNTIME_PLATFORM``` parameter, you will need to invoke different endpoints to execute the test.

### Running with OW_RUNTIME_PLATFORM set to "knative"

#### Invoke / endpoint on the Service

```
curl -H "Host: python-helloworld-builtin.default.example.com" -X POST -d @knative-data-run.json http://localhost/
```

#### Initialize the runtime

You have an option to initialize the runtime with the function and other configuration data if its not initialized (i.e. deployed using [stemcell-service.yaml](stemcell-service.yaml))

```
curl -H "Host: python-helloworld-stemcell.default.example.com" -d "@knative-data-init.json" -H "Content-Type: application/json" http://localhost/

{"OK":true}
```

#### Run the function

Execute the function.

```
curl -H "Host: python-helloworld-stemcell.default.example.com" -d "@knative-data-run.json" -H "Content-Type: application/json" -X POST http://localhost/

{"payload":"Hello World!"};
```
