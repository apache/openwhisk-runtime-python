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
   echo -e "\t-r Specific runtime image folder name to be built, it can be one of python39Action, python310Action, or python311Action"
   echo -e "\t-t The name for docker image and tag used for building the docker image. Example: action-python-v3.11:1.0-SNAPSHOT"
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
if [ -z "$runtimeParameter" ] || [ -z "$dockerImageTag" ] || ( [[ "$runtimeParameter" != "python39Action" ]] && [[ "$runtimeParameter" != "python310Action" ]] && [[ "$runtimeParameter" != "python311Action" ]] )
 then
   echo "Runtime parameter is empty or not supported";
   helperInstructions
fi

# For every runtime 1. copy the required dependent folders 2. build the docker image 3. delete the copied folder
if [[ "$runtimeParameter" == "python39Action" ]]
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
elif [[ "$runtimeParameter" == "python311Action" ]]
  then
    echo "Building docker for python311Action."
    cp $(pwd)/core/requirements_common.txt $(pwd)/core/python311Action/requirements_common.txt
    cp -r $(pwd)/core/python3Action/bin $(pwd)/core/python311Action/bin
    cp -r $(pwd)/core/python3Action/lib $(pwd)/core/python311Action/lib
    docker build -t "$dockerImageTag" $(pwd)/core/python311Action
    rm $(pwd)/core/python311Action/requirements_common.txt
    rm -r $(pwd)/core/python311Action/bin
    rm -r $(pwd)/core/python311Action/lib
fi
