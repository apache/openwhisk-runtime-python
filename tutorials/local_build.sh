#!/bin/bash
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

helperInstructions()
{
   echo ""
   echo "Usage: $0 -r runtimeParameter -t dockerImageTag"
   echo -e "\t-r Specific runtime image folder name to be built, it can be one of python3Action, python36AiAction, python39Action or python310Action"
   echo -e "\t-t The name for docker image and tag used for building the docker image. Example: action-python-v3.7:1.0-SNAPSHOT"
   exit 1 #Exit script
}

while getopts "r:t:" opt
do
   case "$opt" in
      r) runtimeParameter="$OPTARG" ;;
      t) dockerImageTag="$OPTARG" ;;
      [?]) helperInstructions ;; # Print helperInstructions in case parameter is not found
   esac
done

# Print helperInstructions in case parameters are empty
if [ -z "$runtimeParameter" ] || [ -z "$dockerImageTag" ] || ( [[ "$runtimeParameter" != "python3Action" ]] && [[ "$runtimeParameter" != "python36AiAction" ]] && [[ "$runtimeParameter" != "python39Action" ]] && [[ "$runtimeParameter" != "python310Action" ]] )
 then
   echo "Runtime parameter is empty or not supported";
   helperInstructions
fi

# For every runtime 1. copy the required dependent folders 2. build the docker image 3. delete the copied folder
if [[ "$runtimeParameter" == "python3Action" ]]
 then
    echo "Building docker for python3Action."
    cp $(pwd)/core/requirements_common.txt $(pwd)/core/python3Action/requirements_common.txt
    docker build -t "$dockerImageTag" $(pwd)/core/python3Action
    rm $(pwd)/core/python3Action/requirements_common.txt
elif [[ "$runtimeParameter" == "python36AiAction" ]]
  then
    echo "Building docker for python36AiAction."
    cp $(pwd)/core/requirements_common.txt $(pwd)/core/python36AiAction/requirements_common.txt
    cp -r $(pwd)/core/python3Action/bin $(pwd)/core/python36AiAction/bin
    cp -r $(pwd)/core/python3Action/lib $(pwd)/core/python36AiAction/lib
    docker build -t "$dockerImageTag" $(pwd)/core/python36AiAction
    rm $(pwd)/core/python36AiAction/requirements_common.txt
    rm -r $(pwd)/core/python36AiAction/bin
    rm -r $(pwd)/core/python36AiAction/lib
elif [[ "$runtimeParameter" == "python39Action" ]]
  then
    echo "Building docker for python39Action."
    cp $(pwd)/core/requirements_common.txt $(pwd)/core/python39Action/requirements_common.txt
    cp -r $(pwd)/core/python3Action/bin $(pwd)/core/python39Action/bin
    cp -r $(pwd)/core/python3Action/lib $(pwd)/core/python39Action/lib
    docker build -t "$dockerImageTag" $(pwd)/core/python39Action
    rm $(pwd)/core/python39Action/requirements_common.txt
    rm -r $(pwd)/core/python39Action/bin
    rm -r $(pwd)/core/python39Action/lib
elif [[ "$runtimeParameter" == "python310Action" ]]
  then
    echo "Building docker for python310Action."
    cp $(pwd)/core/requirements_common.txt $(pwd)/core/python310Action/requirements_common.txt
    cp -r $(pwd)/core/python3Action/bin $(pwd)/core/python310Action/bin
    cp -r $(pwd)/core/python3Action/lib $(pwd)/core/python310Action/lib
    docker build -t "$dockerImageTag" $(pwd)/core/python310Action
    rm $(pwd)/core/python310Action/requirements_common.txt
    rm -r $(pwd)/core/python310Action/bin
    rm -r $(pwd)/core/python310Action/lib
fi
