#!/bin/bash

echo "Hoodie Backend - starting install."
BACKEND_LOCATION=/opt/backend
test -d "$BACKEND_LOCATION" && BACKEND_EXISTS="0"

BACKEND_URL="https://artifactory.cloudsoftcorp.com/artifactory/libs-release-local/io/cloudsoft/packs/catalogue-backend-v3.jar"

if [ "$BACKEND_EXISTS" ]; then
  echo "Hoodie Backend already installed." >> /tmp/terraform-provisioner.log
else
  echo "[backend-create]: Hoodie Backend is being copied into ${BACKEND_LOCATION} from ${BACKEND_URL}" >> /tmp/terraform-provisioner.log
  mkdir /opt/backend
  cd /opt/backend
  curl -L -k -f -o catalogue-backend.jar "${BACKEND_URL}"
  test -f catalogue-backend.jar && BACKEND_EXISTS="0"
  if [ "$BACKEND_EXISTS" ]; then
      echo "[backend-create]: Hoodie Backend was copied!" >> /tmp/terraform-provisioner.log
    else
      echo "[backend-create]: Hoodie Backend was NOT copied! Backend will fail!" >> /tmp/terraform-provisioner.log
    fi
fi