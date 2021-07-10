# piups_exporter
# Copyright (c) 2021, Brendon Matheson
#
# http://brendonmatheson.com/
#
# This work is offered under the terms of the MIT license.  See the LICENSE file for details.

FROM ricoberger/script_exporter:latest as build


FROM python:alpine3.10

RUN apk add --no-cache --update curl ca-certificates
COPY --from=build /bin/script_exporter /bin/script_exporter
EXPOSE 9469

USER root
RUN mkdir scripts

COPY files/config.yaml /
COPY files/piups.py /scripts
COPY files/requirements.txt /scripts

RUN apk add build-base
RUN apk add linux-headers
RUN pip install --no-cache-dir -r scripts/requirements.txt

ENTRYPOINT [ "/bin/script_exporter" ]
