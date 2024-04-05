#!/bin/bash

echo "MariaDB - starting to configure."
systemctl status mariadb.service | grep 'dead' > /dev/null 2>&1
if [ $? != 0 ] ; then
  echo "MariaDB is running when configure is called. Skipping configuration assuming it has already been done. If this is not correct then stop the DB before invoking this."
else
  echo "[mariadb-configure]: Configuring MariaDB..." >> /tmp/terraform-provisioner.log
  # When MySQL is up `systemctl status mariadb` returns `Active: active (running)`
  systemctl start mariadb.service

  echo "[mariadb-configure]: Fetching and running creation script from /tmp/creation-script.sql..." >> /tmp/terraform-provisioner.log
  sed -i s/catalogue_user/${1}/ /tmp/creation-script.sql
  sed -i s/catalogue_pass/${2}/ /tmp/creation-script.sql
  #cat /tmp/creation-script.sql >> /tmp/terraform-provisioner.log
  mysql -u root < /tmp/creation-script.sql
fi
