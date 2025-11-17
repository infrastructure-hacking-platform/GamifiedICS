echo "--------------------CREATING USER/GROUP ENVIRONMENT VARIABLES--------------------"
user=$(whoami)
group=$(id -gn)



echo "--------------------CREATING 'GamifiedICS' PROJECT FOLDER--------------------"
sudo mkdir -p /home/$user/Desktop/GamifiedICS/

echo "--------------------MOVING PROJECT FILES TO PROJECT FOLDER AND ASSIGNING OWNERSHIP TO CURRENT USER--------------------"
sudo mv wordpress-data_Power-plant.tar init OpenPLC-Setup docker-compose.yaml scripts /home/$user/Desktop/GamifiedICS/
sudo chown -R $user:$group /home/$user/Desktop/GamifiedICS/

echo "--------------------CREATING DOCKER COMPOSE 'user' VARIABLE FOR PATH MOUNTING--------------------"
echo "user=$(whoami)" > /home/$user/Desktop/GamifiedICS/.env

echo "--------------------CREATING WORDPRESSDATA FOLDER--------------------"
sudo mkdir -p /home/$user/Desktop/GamifiedICS/wordpressData/

echo "--------------------EXTRACTING WORDPRESS .TAR FILES TO WORDPRESSDATA--------------------"
sudo tar -xf wordpress-data_Power-plant.tar -C /home/$user/Desktop/GamifiedICS/wordpressData/



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



echo "--------------------EXPORTING GUACAMOLE DB INITIALIZATION FILE--------------------"
sudo docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql | sudo tee /home/$user/Desktop/GamifiedICS/init/initdb.sql > /dev/null



echo "--------------------BUILDING OPENPLC IMAGE--------------------"
sudo docker build -t openplc-docker /home/$user/Desktop/GamifiedICS/OpenPLC-Setup/



echo "--------------------UNZIPPING OPENPLC 'OPENPLC_V3' FOLDERS--------------------"
sudo tar -xzf /home/$user/Desktop/GamifiedICS/init/OpenPLC/EV-charger/Communications/openplc/OpenPLC_v3.tar.gz -C /home/$user/Desktop/GamifiedICS/init/OpenPLC/EV-charger/Communications/openplc/OpenPLC_v3/
sudo tar -xzf /home/$user/Desktop/GamifiedICS/init/OpenPLC/EV-charger/Inverter/openplc/OpenPLC_v3.tar.gz -C /home/$user/Desktop/GamifiedICS/init/OpenPLC/EV-charger/Inverter/openplc/OpenPLC_v3/




echo "--------------------CHANGING LINE ENDINGS TO UNIX-STYLE--------------------"
sudo find /home/$user/Desktop/GamifiedICS/ -type f \( -name "*.sh" -o -name "*.py" \) -exec dos2unix {} +

echo "--------------------STARTING UP CONTAINERS--------------------"
sudo docker compose up -d