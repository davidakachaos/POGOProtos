#!/bin/bash

cd /src/pogoprotos/
python compile.py python --keep_proto_files
cd out
cp -Rf pogoprotos ../../pgoapi/pgoapi/protos
cd /src
tar -zcvf pgoapi.tar.gz pgoapi
cp pgoapi.tar.gz /tmp/