#!/usr/bin/env bash

electron-packager . Neo4jBrowser --ignore=standalone -out=standalone --platform=all --arch=x64 --version=0.36.4 --overwrite