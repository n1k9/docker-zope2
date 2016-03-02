#!/bin/sh

mkdir -p `pwd`/data
docker run -it --rm --name zope2 -p 8081:8080 -v `pwd`/data:/zope zope2
