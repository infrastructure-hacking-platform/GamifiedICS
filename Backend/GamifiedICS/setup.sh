echo "--------------------CREATING USER/GROUP ENVIRONMENT VARIABLES--------------------"
user=$(whoami)
group=$(id -gn)
install_path="$PWD" # could just use $PWD directly but keeping it like this in case I need to change this path (ex: change to [install path]/init/...)



#echo "--------------------CREATING 'GamifiedICS' PROJECT FOLDER--------------------"
#sudo mkdir -p /home/$user/Desktop/GamifiedICS/

#echo "--------------------MOVING PROJECT FILES TO PROJECT FOLDER AND ASSIGNING OWNERSHIP TO CURRENT USER--------------------"
#sudo mv init OpenPLC-Setup scripts .env docker-compose.yaml "VM Setup Guide.docx" /home/$user/Desktop/GamifiedICS/

echo "--------------------ASSIGNING PROJECT FOLDER OWNERSHIP TO CURRENT USER--------------------"
sudo chown -R $user:$group "$install_path"

#echo "--------------------CREATING DOCKER COMPOSE 'user' VARIABLE FOR PATH MOUNTING--------------------" no longer needed since I can reference the same path with "./" (we're already in the install path) but I'm keeping these lines here so I can remember how to add usable variables to Compose files (use of .env file).
#echo "user=$(whoami)" > "$install_path/.env"
#echo "install_path=$(pwd)" > "$install_path/.env"

#echo "--------------------CREATING WORDPRESSDATA FOLDER--------------------"
#sudo mkdir -p /home/$user/Desktop/GamifiedICS/wordpressData/

#echo "--------------------EXTRACTING WORDPRESS .TAR FILES TO WORDPRESSDATA--------------------"
#sudo tar -xf wordpress-data_Power-plant.tar -C /home/$user/Desktop/GamifiedICS/wordpressData/



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
sudo docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql | sudo tee "$install_path/init/initdb.sql" > /dev/null



echo "--------------------BUILDING OPENPLC IMAGE--------------------"
sudo docker build -t openplc-docker "$install_path/OpenPLC-Setup/"



echo "--------------------UNZIPPING OPENPLC 'OPENPLC_V3' FOLDERS--------------------"
sudo tar -xzf "$install_path/init/OpenPLC/EV-charger/Communications/openplc/OpenPLC_v3.tar.gz" -C "$install_path/init/OpenPLC/EV-charger/Communications/openplc/OpenPLC_v3/"
sudo tar -xzf "$install_path/init/OpenPLC/EV-charger/Inverter/openplc/OpenPLC_v3.tar.gz" -C "$install_path/init/OpenPLC/EV-charger/Inverter/openplc/OpenPLC_v3/"




echo "--------------------CHANGING LINE ENDINGS TO UNIX-STYLE--------------------"
sudo find "$install_path" -type f \( -name "*.sh" -o -name "*.py" \) -exec dos2unix {} +

echo "--------------------STARTING UP CONTAINERS--------------------"
sudo docker compose -f "$install_path/docker-compose.yaml" up -d # do -f to specify the absolute location of the 'docker-compose.yaml' file