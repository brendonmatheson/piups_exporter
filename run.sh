#!/bin/bash

sudo docker run \
	-it --rm \
	--device /dev/i2c-1 \
	-p 9469:9469 \
	brendonmatheson/piups_exporter:latest

