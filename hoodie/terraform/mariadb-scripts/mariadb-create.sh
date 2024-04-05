#!/bin/bash

echo "MariaDb - starting install."

MARIADB_CFG=/etc/mysql/mysql.conf.d/
test -d "$MARIADB_CFG" && MARIADB_EXISTS="0"

if [ "$MARIADB_EXISTS" ]; then
  echo "[mariadb-create]: MariaDb already installed." >> /tmp/terraform-provisioner.log
else
  while fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/{lock,lock-frontend} >/dev/null 2>&1; do
    echo 'Waiting for release of dpkg/apt locks...';
    sleep 5
  done
  echo "[mariadb-create]: Upgrading system" >> /tmp/terraform-provisioner.log
  apt update
  apt upgrade --assume-yes
  apt update
  echo "[mariadb-create]: Installing MariaDb." >> /tmp/terraform-provisioner.log
  apt install mariadb-server --assume-yes || {
    echo "First mariadb install failed, waiting then will retry as sometimes ubuntu is funny like that"
    sleep 15
    apt update
    apt upgrade --assume-yes
    apt update
    apt install mariadb-server --assume-yes
    echo "[mariadb-create]: Installing MariaDb." >> /tmp/terraform-provisioner.log
  }
fi

systemctl status mariadb.service| grep 'running' > /dev/null 2>&1
if [ $? == 0 ]; then
  echo "[mariadb-create]: MariaDB installed and started." >> /tmp/terraform-provisioner.log
  systemctl stop mariadb.service
  cat >/tmp/zz-bind-address.cnf <<ENDOFTEXT
[mysqld]
bind-address = 0.0.0.0
ENDOFTEXT
  echo "[mariadb-create]: MariaDB zz-bind-address.cnf copied." >> /tmp/terraform-provisioner.log
  mv /tmp/zz-bind-address.cnf /etc/mysql/mariadb.conf.d/
  chown root:root /etc/mysql/mariadb.conf.d/zz-bind-address.cnf
  echo "[mariadb-create]: MariaDB installed." >> /tmp/terraform-provisioner.log
else
  echo "[mariadb-create]: MariaDB NOT installed.Something went wrong!" >> /tmp/terraform-provisioner.log
fi


