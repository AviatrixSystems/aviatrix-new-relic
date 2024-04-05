#!/bin/bash

systemctl status mariadb.service| grep 'running' > /dev/null 2>&1
if [ $? == 0 ]; then
  echo "MariaDB is up. Shutting it down..."
  systemctl stop mariadb.service
else
  echo "MariaDB is already down."
fi