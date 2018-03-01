# Apache OpenWhisk runtimes for Python
[![Build Status](https://travis-ci.org/apache/incubator-openwhisk-runtime-python.svg?branch=master)](https://travis-ci.org/apache/incubator-openwhisk-runtime-python)


### Give it a try today
To use as a docker action using python 3
```
wsk action update myAction myAction.py --docker openwhisk/python3action:1.0.0
```
Replace `python3action` with `python2action` to use python 2.


### To use on deployment that contains the rutime as a kind
To use as a kind action using python 3
```
wsk action update myAction myAction.py --kind python:3
```
Replace `python:3` with `python:2` to use python 2.


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

# License
[Apache 2.0](LICENSE.txt)


