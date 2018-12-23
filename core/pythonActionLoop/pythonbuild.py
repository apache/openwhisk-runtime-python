#!/usr/bin/env python3
"""Python Action Compiler
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
"""

from __future__ import print_function
import os
import sys
import codecs
import subprocess


def copy(src, dst):
    with codecs.open(src, 'r', 'utf-8') as s:
        body = s.read()
        with codecs.open(dst, 'w', 'utf-8') as d:
            d.write(body)

# if there is an exec copy to main__.py
# else if there is a __main__.py copy to main__.py
# (exec prevails over __main__.py)
# then copy the launcher in exec__.py replacing the main function
def sources(launcher, source_dir, main):
    # source and dest
    src = "%s/exec" % source_dir
    dst = "%s/main__.py" % source_dir
    # copy exec to main__.py
    if os.path.isfile(src):
        copy(src,dst)
    else:
        # renaming __main__ to main__
        src = "%s/__main__.py" % source_dir
        if os.path.isfile(src):
            copy(src, dst)

    # copy a launcher
    starter = "%s/exec__.py" % source_dir
    with codecs.open(launcher, 'r', 'utf-8') as s:
        with codecs.open(starter, 'w', 'utf-8') as d:
            body = s.read()
            body = body.replace("from main__ import main as main",
                                "from main__ import %s as main" % main)
            d.write(body)
    return starter

# build the launcher but only if there is the main
def build(source_dir, target_file, launcher):
    main = "%s/main__.py" % source_dir
    cmd = "#!/bin/bash"
    if os.path.isfile(main):
        cmd += """
cd %s
exec python %s "$@"
""" % (source_dir, launcher)
    else:
        cmd += """
echo "Zip file does not include mandatory files."
"""
    with codecs.open(target_file, 'w', 'utf-8') as d:
        d.write(cmd)
    os.chmod(target_file, 0o755)

def compile(argv):
    if len(argv) < 4:
        sys.stdout.write("usage: <main-function> <source-dir> <target-dir>\n")
        sys.exit(1)

    main = argv[1]
    source_dir = os.path.abspath(argv[2])
    target_file = os.path.abspath("%s/exec" % argv[3])
    launcher = os.path.abspath(argv[0]+".launcher.py")
    starter = sources(launcher, source_dir, main)
    build(source_dir, target_file, starter)
    sys.stdout.flush()
    sys.stderr.flush()
    return target_file


if __name__ == '__main__':
    p = subprocess.Popen([compile(sys.argv), "exit"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE)
    (o, e) = p.communicate()
    if isinstance(o, bytes) and not isinstance(o, str):
        o = o.decode('utf-8')
    if isinstance(e, bytes) and not isinstance(e, str):
        e = e.decode('utf-8')
    if o:
        sys.stdout.write(o)
        sys.stdout.flush()

    if e:
        sys.stderr.write(e)
        sys.stderr.flush()

