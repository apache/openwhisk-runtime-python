#!/usr/bin/env python
"""Python Hello virtualenv test.

/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
"""
from random_user_agent.user_agent import UserAgent
from random_user_agent.params import HardwareType, OperatingSystem

def main(args):
    user_agent_rotator = UserAgent(limit=100,
        hardware_types=[HardwareType.COMPUTER.value],
        operating_systems=[OperatingSystem.LINUX.value])
    return {"agent": user_agent_rotator.get_random_user_agent()}

def naim(args):
    return main(args)
