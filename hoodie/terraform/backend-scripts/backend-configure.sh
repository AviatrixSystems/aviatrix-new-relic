echo "Hoodie Backend - starting configuration."

apt-get update || echo could not apt-get update, will continue configure anyway
apt update || echo could not apt update, will continue configure anyway

# sometimes needed for add-apt-repository
apt --assume-yes install software-properties-common lsof

if ( which java ) ; then
  echo "Java already installed." >> /tmp/terraform-provisioner.log
else
  echo "[backend-configure]: Installing java." >> /tmp/terraform-provisioner.log
  # occasionally AWS comes up without this repo
  add-apt-repository -y ppa:openjdk-r/ppa || echo could not add repo, will continue trying java install anyway
  apt-get update || echo could not apt-get update, will continue trying java install anyway
  apt update || echo could not apt-get update, will continue trying java install anyway

  apt --assume-yes install openjdk-8-jdk-headless
  apt --assume-yes install openjdk-8-jre-headless
  echo "[backend-configure]: Java 8 installed." >> /tmp/terraform-provisioner.log
fi

