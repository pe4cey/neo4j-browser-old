#!/usr/bin/env bash

PORT=7474
if [ ! -z $1 ]
then
    PORT=$1
fi

http-server -p PORT
PID=$!
echo PID