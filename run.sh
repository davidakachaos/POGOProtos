#!/bin/bash

cd /src/pogoprotos/
python compile.py python
tar -zcvf out.tar.gz out
cp out.tar.gz /tmp/

cd out
cp -Rf pogoprotos ../../pgoapi/pgoapi/protos
cd /src
tar -zcvf pgoapi.tar.gz pgoapi
cp pgoapi.tar.gz /tmp/