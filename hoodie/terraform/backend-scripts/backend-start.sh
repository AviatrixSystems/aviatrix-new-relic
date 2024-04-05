echo "Hoodie Backend - starting the Spring Boot app."
BACKEND_JAR=/opt/backend/catalogue-backend.jar

echo "[backend-start]: Hoodie Backend - trying to start app with ${BACKEND_JAR} --DB=${1} --DB_USER=${2} --DB_PASS=${3}" >> /tmp/terraform-provisioner.log

lsof -i:8082 && BOOT_STARTED="0"

if [ "$BOOT_STARTED" ]; then
  echo "Hoodie Backend already started." >> /tmp/terraform-provisioner.log
else
  echo "[backend-start]: Hoodie Backend ${BACKEND_JAR} starting with ${1} ..." >> /tmp/terraform-provisioner.log
  touch /opt/backend/server.log
  # Start the server
  nohup java -jar ${BACKEND_JAR} --DB=${1} --DB_USER=${2} --DB_PASS=${3} >> /opt/backend/server.log 2>&1 &
  sleep 5
  lsof -i:8082 && BOOT_STARTED="0"
  if [ ! "$BOOT_STARTED" ]; then
    echo "[backend-start]: Still waiting"
    sleep 15
    lsof -i:8082 && BOOT_STARTED="0"
  fi
  echo "[backend-start]: Hoodie Backend started? ${BOOT_STARTED}" >> /tmp/terraform-provisioner.log
  if [ "$BOOT_STARTED" ]; then
    echo "Woop, woop backend is up!"
  else
    echo "Backend has not started. Something went wrong!"
    exit 1
  fi
fi
