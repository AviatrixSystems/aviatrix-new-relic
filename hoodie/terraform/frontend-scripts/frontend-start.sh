#!/bin/bash

echo "Hoodie Frontend - starting the NodeJs app."

FRONTEND_LOCATION=~/hoodie/app

lsof -i:3000 && FRONTEND_STARTED="already"

if [ "$FRONTEND_STARTED" ]; then
  echo "[frontend-start]: Hoodie Frontend already started." | tee -a /tmp/terraform-provisioner.log
else
   touch $FRONTEND_LOCATION/app.log

  # Start the server
  cd $FRONTEND_LOCATION
  echo "Attempting to start app at ${FRONTEND_LOCATION} with backend ${REACT_APP_BACKEND_URL}"
  npx forever start node_modules/serve/bin/serve.js -s build < /dev/null >> app.log 2>&1
  echo "[frontend-start]: 'serve.js' called writing to app.log." | tee -a /tmp/terraform-provisioner.log
  # for good measure, show the ps tree output
  ps -efj --forest | tee -a /tmp/terraform-provisioner.log
fi

