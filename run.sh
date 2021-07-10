#!/bin/bash

# piups_exporter
# Copyright (c) 2021, Brendon Matheson
#
# http://brendonmatheson.com/
#
# This work is offered under the terms of the MIT license.  See the LICENSE file for details.

sudo docker run \
	-it --rm \
	--device /dev/i2c-1 \
	-p 9469:9469 \
	brendonmatheson/piups_exporter:latest

