<!--
#
# Licensed to the Apache Software Foundation (ASF) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for additional
# information regarding copyright ownership.  The ASF licenses this file to you
# under the Apache License, Version 2.0 (the # "License"); you may not use this
# file except in compliance with the License.  You may obtain a copy of the License
# at:
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
-->

# Apache OpenWhisk runtimes for Python

[![Build Status](https://travis-ci.org/apache/incubator-openwhisk-runtime-python.svg?branch=master)](https://travis-ci.org/apache/incubator-openwhisk-runtime-python)

## Give it a try today

To use as a docker action using python 3

```
wsk action update myAction myAction.py --docker openwhisk/python3action:1.0.0
```

Replace `python3action` with `python2action` to use python 2.

## To use on deployment that contains the runtime as a kind

To use as a kind action using python 3

```
wsk action update myAction myAction.py --kind python:3
```

Replace `python:3` with `python:2` to use python 2.

## Building and hacking

This runtime has been converted to a multi-architecture build.  For details on
building it, see
[here](https://github.com/apache/incubator-openwhisk/blob/master/docs/runtimes-building.md)

# License

[Apache 2.0](LICENSE.txt)


