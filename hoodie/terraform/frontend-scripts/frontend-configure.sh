echo "Hoodie Frontend - starting configuration."
REACT_APP_BACKEND_URL=${1}

FRONTEND_LOCATION=~/hoodie/app

if ( which node ) ; then
  echo "[frontend-configure]: Node already installed." | tee -a /tmp/terraform-provisioner.log
else
  echo "[frontend-configure]: Installing node." | tee -a /tmp/terraform-provisioner.log
  while fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/{lock,lock-frontend} >/dev/null 2>&1; do
      echo 'Waiting for release of dpkg/apt locks...';
      sleep 5
  done
  echo "[frontend-configure]: Upgrading system" | tee -a /tmp/terraform-provisioner.log
  sudo apt update && sudo apt upgrade --assume-yes

  echo "[frontend-configure]: Installing nodejs 16 " | tee -a /tmp/terraform-provisioner.log
  curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

cd $FRONTEND_LOCATION
echo "[frontend-configure]: Run npm ci & npm cache clean -- force" | tee -a /tmp/terraform-provisioner.log
npm ci && npm cache clean --force | tee -a /tmp/terraform-provisioner.log

npm install serve
npm install forever

echo "[frontend-configure]: Hoodie Frontend ${FRONTEND_LOCATION} configuring with backend ${REACT_APP_BACKEND_URL}..." | tee -a /tmp/terraform-provisioner.log
echo "REACT_APP_BACKEND_URL=${REACT_APP_BACKEND_URL}" > .env.production
npm run build | tee -a /tmp/terraform-provisioner.log

