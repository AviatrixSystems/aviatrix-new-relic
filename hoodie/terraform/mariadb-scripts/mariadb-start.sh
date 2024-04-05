#!/bin/bash

systemctl status mariadb.service| grep 'running' > /dev/null 2>&1
if [ $? == 0 ]; then
  echo "MariaDB is up. All is well with the world."
else
  echo "MariaDB is down. Starting it..."
  systemctl start mariadb.service
fi