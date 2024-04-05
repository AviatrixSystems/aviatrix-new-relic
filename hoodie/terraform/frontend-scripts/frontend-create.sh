#!/bin/bash

echo "Hoodie Frontend - starting install."
FRONTEND_LOCATION=~/hoodie/app
test -d "$FRONTEND_LOCATION" && FRONTEND_EXISTS="already"

FRONTEND_URL="https://artifactory.cloudsoftcorp.com/artifactory/libs-release-local/io/cloudsoft/packs/catalogue-frontend-v3.tar.gz"

if [ "$FRONTEND_EXISTS" ]; then
  echo "[frontend-create]: Hoodie Frontend already installed." | tee -a /tmp/terraform-provisioner.log
else
  cd ~/
  mkdir -p hoodie
  cd hoodie
  echo "[frontend-create]: Hoodie Frontend is being copied from ${FRONTEND_URL}" | tee -a /tmp/terraform-provisioner.log
  curl -L -k -f -o catalogue-frontend.tar.gz "${FRONTEND_URL}" && FRONTEND_DOWNLOADED="ok"
  if [ "$FRONTEND_DOWNLOADED" ]; then
    echo "[frontend-create]: Hoodie Frontend was copied!" | tee -a /tmp/terraform-provisioner.log
  else
    echo "[frontend-create]: Hoodie Frontend was NOT copied! Frontend will fail!" | tee -a /tmp/terraform-provisioner.log
  fi
  tar xvf catalogue-frontend.tar.gz
  test -d "$FRONTEND_LOCATION" && FRONTEND_EXISTS="installed."
  echo "[frontend-create]: Hoodie Frontend installed?  ${FRONTEND_EXISTS}" | tee -a /tmp/terraform-provisioner.log
fi
