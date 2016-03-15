#!/bin/bash

USERNAME=zope
GROUPNAME=zope

USERID=$(stat -c '%u' $ZOPE_HOME)
GROUPID=$(stat -c '%g' $ZOPE_HOME)

groupadd -r $GROUPNAME -g $GROUPID
useradd -r -g $GROUPNAME -u $USERID $USERNAME

exec "$@"
