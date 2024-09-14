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

# Python 3 OpenWhisk Runtime Container

## 1.20.0
 - Dependabot Fixes (#159)
 - Update virtualenv for python:3.9 to fix tests. (#161)
 - Update scalafmt plugin version to fix build break (#162)
 - Update go proxy to 1.23@1.25.0 (#163)
 -  Upgrade gradle to 6.9.3 (#164)

## 1.19.0
  - Add Python 3.12 Runtime (#152)
  - Update python:3.11 and python:3.10 runtimes to Debian bookworm (#146)
  - Update go proxy to 1.21@1.23.0 (#148)
  - Drop support for Python 3.7 (EOL June 2023) (#147)

## 1.18.0
  - Add Python 3.10 runtime. (#128)
  - Add Python 3.11 Runtime (#140)
  - Remove Python 3.6 based runtime (#143)
  - Support array result include sequence action (#129)
  - Install zip in docker images (#122)
  - Build proxy from 1.22.0 release of openwhisk-runtime-go using GoLang 1.20
  - Added script to build docker images locally (#135)

## 1.17.0
 - Build actionloop from 1.16@1.18.0 (#113)
 - Support for python-3.9 (#111)
 - Support for generating actions with virtualenvs resolving requirements.txt (#111)

## 1.16.0
  - Introduce tutorial to deploy python runtimes locally (#101)
  - Use 1.17.0 release of openwhisk-runtime-go (#98)
  - Remove Python2
  - Remove non-actionloop runtimes

## 1.15.0
  - Build proxy from 1.16.0 release of openwhisk-runtime-go
  - Update to golang:1.15 and buster. (#90)
  - Ambiguous name changed to python3ActionLoop (#89)
  - Updated Python runtimes to use "Action Loop" Proxy with new async handshake (#82)

