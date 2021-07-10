#!/bin/bash

# piups_exporter
# Copyright (c) 2021, Brendon Matheson
#
# http://brendonmatheson.com/
#
# This work is offered under the terms of the MIT license.  See the LICENSE file for details.

sudo docker rmi brendonmatheson/piups_exporter:latest

sudo docker image prune
