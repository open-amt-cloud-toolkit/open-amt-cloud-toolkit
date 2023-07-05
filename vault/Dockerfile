#*********************************************************************
# Copyright (c) Intel Corporation 2021
# SPDX-License-Identifier: Apache-2.0
#*********************************************************************/
FROM bash

RUN apk update \
    && apk add --no-cache --upgrade \
    curl \
    jq

WORKDIR /vault

COPY init.sh /vault/

CMD ["bash", "/vault/init.sh"]

