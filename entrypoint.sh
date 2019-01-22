#!/bin/bash

echo "root:${ROOT_PASSWD}" |chpasswd

/usr/sbin/sshd -D

python3 /opt/ehForwarderBot/main.py
