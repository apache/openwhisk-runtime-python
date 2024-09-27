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

# Building Python runtime locally

## Pre-requisites
- [Docker](https://www.docker.com/)
- [curl](https://curl.se/), [wget](https://www.gnu.org/software/wget/), or [Postman](https://www.postman.com/)


## Clone repo
```
git clone https://github.com/apache/openwhisk-runtime-python
cd openwhisk-runtime-python
```

## Build the docker image

Build docker image using Python 3.11 (recommended). This tutorial assumes you're building with python 3.11.
Run `local_build.sh` to build docker. This script takes two parameters as input
- `-r` Specific runtime image folder name to be built, it can be one of `python39Action`, `python310Action`, or `python311Action`
- `-t` The name for docker image and tag used for building the docker image. Example: `action-python-v3.11:1.0-SNAPSHOT`

```
cd tutorials
chmod 755 local_build.sh
cd ..
./tutorials/local_build.sh -r python311Action -t action-python-v3.11:1.0-SNAPSHOT
```

### Verify docker image

Check docker `IMAGE ID` (3rd column) for repository `action-python-v3.11`
```
docker images
```
If the `local_build.sh` script is sucessful, you should see an image that looks something like:
```
action-python-v3.11         1.0-SNAPSHOT ...
```

### (Optional) Tag docker image

This is required if you’re pushing your docker image to a registry e.g. dockerHub
```
docker tag <docker_image_ID> <dockerHub_username>/action-python-v3.11:1.0-SNAPSHOT
```

## Run docker image

Run docker on localhost with either the following commands:
```
docker run -p 127.0.0.1:80:8080/tcp --name=bloom_whisker --rm -it action-python-v3.11:1.0-SNAPSHOT
```
Or run the container in the background (Add -d (detached) to the command above)
```
docker run -d -p 127.0.0.1:80:8080/tcp --name=bloom_whisker --rm -it action-python-v3.11:1.0-SNAPSHOT
```
**Note:** If you run your docker container in the background you'll want to stop it with:
```
docker stop <container_id>
```
Where `<container_id>` is obtained from `docker ps` command bellow

List all running containers
```
docker ps
```
or
```
docker ps -a
```
You should see a container named `bloom_whisker` being run and a <container_id> associated with it in the first column.

## Test docker image
Docker image can be tested by creating functions. This documents lists creating three types of functions

- [Functions without arguments](#Functions-without-arguments)
- [Functions with arguments](#Functions-with-arguments)
- [Advanced functions](#Advanced-functions)

## Functions without arguments
### Create function
Create a function (Each container can only hold one function). In this first example we'll be creating a very simple Helloworld function. Create a json file called `python-data-init-run.json` which will contain the function that looks something like the following:

**NOTE:** value of code is the actual payload and must match the syntax of the target runtime language, in this case `python`
```json
{
   "value": {
      "name" : "python-helloworld",
      "main" : "main",
      "binary" : false,
      "code" : "def main(args): return {'payload': 'Hello World!'}"
   }
}
```
### Test function
#### Initialize function
To issue the action against the running runtime, we must first make a request against the `init` API
We need to issue `POST` requests to init our function
This step can be run using either [curl](https://curl.se/), [wget](https://www.gnu.org/software/wget/), or [Postman](https://www.postman.com/)

- Using curl

  The option `-d` signifies we're issuing a POST request in curl

      curl -d "@python-data-init-run.json" -H "Content-Type: application/json" http://localhost/init

- Using wget

  The option `--post-file` signifies we're issuing a POST request in wget

      wget --post-file=python-data-init-run.json --header="Content-Type: application/json" http://localhost/init

- Using postman

  The above can also be achieved with [Postman](https://www.postman.com/) by setting the headers and body accordingly

##### Expected response of Initialize function step
Clientresponse should be as below
```
{"ok":true}
```
Server will remain silent in this case

#### Run function
Now we can invoke/run our function agains the `run` API with:
- Using curl
   - `POST` request

         curl -d "@python-data-init-run.json" -H "Content-Type: application/json" http://localhost/run

   - `GET` request

         curl --data-binary "@python-data-init-run.json" -H "Content-Type: application/json" http://localhost/run

- Using wget
   - `POST` request

      The `-O-` is to redirect `wget` response to `stdout`.

         wget -O- --post-file=python-data-init-run.json --header="Content-Type: application/json" http://localhost/run

   - `GET` request

         wget -O- --body-file=python-data-init-run.json --method=GET --header="Content-Type: application/json" http://localhost/run

- Using postman

   The above can also be achieved with [Postman](https://www.postman.com/) by setting the headers and body accordingly.

#### (Recommended) Run function
The same file `python-data-init-run.json` from function initialization request is used to trigger(run) the function. It is not necessary nor recommended. To trigger a function we only need to pass the parameters of the function. Hence, instead in the above example, it is prefered to create a file called `python-data-params.json` that looks like the following:

```json
{
   "value": {}
}
```
And trigger/run the function with the following:
```
curl --data-binary "@python-data-params.json" -H "Content-Type: application/json" http://localhost/run
```
This also works with wget and postman equivalents. Make sure you have the correct request type set and the respective body. Also set the correct headers key value pairs, which for us is "Content-Type: application/json"

##### Expected response of Run function step

After you trigger the function with one of the above commands you should expect the following client response:
```
{"payload": "Hello World!"}
```
And Server expected response:
```
XXX_THE_END_OF_A_WHISK_ACTIVATION_XXX
XXX_THE_END_OF_A_WHISK_ACTIVATION_XXX
```

## Functions with arguments

### Create function

**Note:** If your container still running from the previuous example you must stop it and re-run it before proceding. Remember that each python runtime can only hold one function (which cannot be overrided due to security reasons).

Create a json file called `python-data-init-params.json` which will contain the function to be initialized that looks like the following:
```json
{
   "value": {
      "name": "python-helloworld-with-params",
      "main" : "main",
      "binary" : false,
      "code" : "def main(args): return {'payload': 'Hello ' + args.get('name') + ' from ' + args.get('place') + '!!!'}"
   }
}
```
Also create a json file `python-data-run-params.json` which will contain the parameters to the function used to trigger it. Notice here we're creating 2 separate file from the beginning since this is good practice to make the disticntion between what needs to be send via the `init` API and what needs to be sent via the `run` API:
```json
{
   "value": {
      "name": "UFO",
      "place": "Mars"
   }
}
```
### Test function
#### Initialize function
To initialize the function make sure the python runtime container is running. If not, spin the container by following [Run docker image](#Run-docker-image) step.
Issue a `POST` request against the `init` API with the following command:
- Using curl

      curl -d "@python-data-init-params.json" -H "Content-Type: application/json" http://localhost/init

- Using wget

      wget --post-file=python-data-init-params.json --header="Content-Type: application/json" http://localhost/init

- Using postman

  The above can also be achieved with [Postman](https://www.postman.com/) by setting the headers and body accordingly


#### Expected response of Initialize function
Client response should be as below
```
{"ok":true}
```
Server will remain silent in this case

#### Run function
To run/trigger the function issue requests against the `run` API with the following command:

- Using curl
   - `POST` request

         curl -d "@python-data-run-params.json" -H "Content-Type: application/json" http://localhost/run

   - `GET` request

         curl --data-binary "@python-data-run-params.json" -H "Content-Type: application/json" http://localhost/run

- Using wget
   - `POST` request

      The `-O-` is to redirect `wget` response to `stdout`.

         wget -O- --post-file=python-data-run-params.json --header="Content-Type: application/json" http://localhost/run

   - `GET` request

         wget -O- --body-file=python-data-run-params.json --method=GET --header="Content-Type: application/json" http://localhost/run

- Using postman

   The above can also be achieved with [Postman](https://www.postman.com/) by setting the headers and body accordingly.

#### Expected response of Run function step
After you trigger the function with one of the above commands you should expect the following client response:
```
{"payload": "Hello UFO from Mars!!!"}
```

And Server expected response:
```
XXX_THE_END_OF_A_WHISK_ACTIVATION_XXX
XXX_THE_END_OF_A_WHISK_ACTIVATION_XXX
```

## Advanced functions
### Create function
This function will calculate the nth Fibonacci number. It calculates the nth number of the Fibonacci sequence recursively in `O(n)` time.

```python
def fibonacci(n, mem):
   if (n == 0 or n == 1):
      return 1
   if (mem[n] == -1):
      mem[n] = fibonacci(n-1, mem) + fibonacci(n-2, mem)
   return mem[n]

def main(args):
   n = int(args.get('fib_n'))
   mem = [-1 for i in range(n+1)]
   result = fibonacci(n, mem)
   key = 'Fibonacci of n == ' + str(n)
   return {key: result}
```

Create a json file called `python-fib-init.json` to initialize our fibonacci function and insert the following. (It’s the same code as above but since we can’t have a string span multiple lines in JSON we need to put all this code in one line and this is how we do it. It’s ugly but not much we can do here)
```json
{
   "value": {
      "name": "python-recursive-fibonacci",
      "main" : "main",
      "binary" : false,
      "code" : "def fibonacci(n, mem):\n\tif (n == 0 or n == 1):\n\t\treturn 1\n\tif (mem[n] == -1):\n\t\tmem[n] = fibonacci(n-1, mem) + fibonacci(n-2, mem)\n\treturn mem[n]\n\ndef main(args):\n\tn = int(args.get('fib_n'))\n\tmem = [-1 for i in range(n+1)]\n\tresult = fibonacci(n, mem)\n\tkey = 'Fibonacci of n == ' + str(n)\n\treturn {key: result}"
   }
}
```
Create a json file called `python-fib-run.json` which will be used to run/trigger our function with the appropriate argument:
```json
{
   "value": {
      "fib_n": "40"
   }
}
```
### Test function
#### Initialize function
To initialize the function make sure the python runtime container is running. If not, spin the container by following [Run docker image](#Run-docker-image) step.
Initialize our fibonacci function by issuing a `POST` request against the `init` API with the following command:

- Using curl

      curl -d "@python-fib-init.json" -H "Content-Type: application/json" http://localhost/init

- Using wget

      wget --post-file=python-fib-init.json --header="Content-Type: application/json" http://localhost/init

- Using postman

  The above can also be achieved with [Postman](https://www.postman.com/) by setting the headers and body accordingly

#### Expected response of Initialize function
Client response should be as below
```
{"ok":true}
```
You've noticed by now that `init` API always returns `{"ok":true}` for a successful initialized function. And the server, again, will remain silent

#### Run function
Trigger/run the function with a request against the `run` API with the following command:

- Using curl
   - `POST` request

         curl -d "@python-fib-run.json" -H "Content-Type: application/json" http://localhost/run

   - `GET` request

         curl --data-binary "@python-fib-run.json" -H "Content-Type: application/json" http://localhost/run

- Using wget
   - `POST` request

      The `-O-` is to redirect `wget` response to `stdout`.

         wget -O- --post-file=python-fib-run.json --header="Content-Type: application/json" http://localhost/run

   - `GET` request

         wget -O- --body-file=python-fib-run.json --method=GET --header="Content-Type: application/json" http://localhost/run

- Using postman

   The above can also be achieved with [Postman](https://www.postman.com/) by setting the headers and body accordingly.

#### Expected response of Run function step
After you trigger the function with one of the above commands you should expect the following client response:
```
{"Fibonacci of n == 40": 165580141}
```

And Server expected response:
```
XXX_THE_END_OF_A_WHISK_ACTIVATION_XXX
XXX_THE_END_OF_A_WHISK_ACTIVATION_XXX
```

#### Additonal testing

- Yyou can edit `python-fib-run.json` and try other `fib_n` values. Save `python-fib-run.json` and trigger the function again. Notice that here we're just modifying the parameters of our function; therefore, there's no need to re-run/re-initialize our container that contains our Python runtime.

- You can also automate most of this process through [docker actions](https://github.com/apache/openwhisk/tree/master/tools/actionProxy) by using `invoke.py`
