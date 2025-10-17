echo "--------------------CREATING USER/GROUP ENVIRONMENT VARIABLES--------------------"
user=$(whoami)
group=$(id -gn)



echo "--------------------CREATING 'GamifiedICS' PROJECT FOLDER AND CHANGING OWNER OF ALL FILES TO LOGGED IN USER--------------------"
sudo mkdir -p GamifiedICS
sudo chown $user:$group -R ./GamifiedICS

echo "--------------------MOVING PROJECT FILES TO PROJECT FOLDER--------------------"
sudo mv wordpress-data_Power-plant.tar init OpenPLC-Setup docker-compose.yaml scripts ./GamifiedICS
cd GamifiedICS

echo "--------------------CREATING WORDPRESSDATA FOLDER--------------------"
sudo mkdir -p wordpressData

echo "--------------------EXTRACTING WORDPRESS .TAR FILES TO WORDPRESSDATA--------------------"
sudo tar -xf wordpress-data_Power-plant.tar -C ./wordpressData



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



echo "--------------------UNZIPPING OPENPLC 'OPENPLC_V3' FOLDERS--------------------"
cd ../init/OpenPLC/EV-charger/Communications/openplc
sudo tar -xzf OpenPLC_v3.tar.gz -C ./OpenPLC_v3
cd ..
cd ../Inverter/openplc
sudo tar -xzf OpenPLC_v3.tar.gz -C ./OpenPLC_v3




echo "--------------------STARTING UP CONTAINERS--------------------"
cd /home/kali/Desktop/GamifiedICS
sudo docker compose up -d
