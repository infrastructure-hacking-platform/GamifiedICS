echo "--------------------CREATING WORDPRESSDATA FOLDER--------------------"
sudo mkdir wordpressData

echo "--------------------CHANGING OWNER TO 'KALI'--------------------"
sudo chown kali:kali ./wordpressData

echo "--------------------EXTRACTING WORDPRESS .TAR FILES TO WORDPRESSDATA--------------------"
sudo tar -xf wordpress-data_EV-charger.tar -C ./wordpressData
sudo tar -xf wordpress-data_Monorail.tar -C ./wordpressData
sudo tar -xf wordpress-data_Power-plant.tar -C ./wordpressData

echo "--------------------DELETING WORDPRESS .TAR FILES--------------------"
sudo rm wordpress-data_EV-charger.tar wordpress-data_Monorail.tar wordpress-data_Power-plant.tar



echo "--------------------UPDATING PACKAGE LIST--------------------"
sudo apt update

echo "--------------------INSTALLING DOCKER.IO--------------------"
sudo apt install -y docker.io

echo "--------------------INSTALLING CURL--------------------"
sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt install -y curl



echo "--------------------MAKING DOCKER INSTALL DIRECTORY--------------------"
sudo mkdir -p /usr/local/lib/docker/cli-plugins

echo "--------------------EXPORTING ARCH ENVIRONMENT VARIABLES--------------------"
ARCH=$(uname -m)

echo "--------------------DOWNLOADING DOCKER 2.0--------------------"
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$ARCH -o /usr/local/lib/docker/cli-plugins/docker-compose

echo "--------------------GRANTING DOCKER COMPOSE EXECUTE PERMISSIONS--------------------"
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose



echo "--------------------CDING INTO INIT--------------------"
cd init

echo "--------------------EXPORTING GUACAMOLE DB INITIALIZATION FILE--------------------"
sudo docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql | sudo tee initdb.sql > /dev/null



echo "--------------------CDING TO OPENPLC FOLDER--------------------"
cd ../OpenPLC-Setup

echo "--------------------BUILDING OPENPLC IMAGE--------------------"
sudo docker build -t openplc-docker .



echo "--------------------STARTING UP CONTAINERS--------------------"
sudo docker compose up -d