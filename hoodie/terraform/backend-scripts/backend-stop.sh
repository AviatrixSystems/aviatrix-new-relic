echo "Hoodie Shop - stopping the Spring Boot App"

PID=`sudo jps | grep backend | awk '{print $1;}'`

if [ -z "$PID" ]; then
  echo "[backend-stop] - Process not found. Application already not running."
else
  echo "[backend-stop] - Process found with PID: ${PID}. Attempting to stop the application."
  kill -9 $PID
  PID_EXISTS=`sudo jps | grep $PID`
  if [ -z "$PID_EXISTS"]; then
    echo "[backend-stop] - Process stopped successfully."
  else
    echo "[backend-stop] - Process with PID: ${PID} still exists."
  fi
fi