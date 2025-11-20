dpkg --configure -a # needed to install pkg-config without an error, according to the error message that I got

sudo echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections # set the /libraries/restart-without-asking config to true for all packages (hence the *), accomplished via debconf-set-selections, which is just a tool that allows easy modification of the underlying config files for scripting.
sudo apt update && sudo apt install -y wget unzip git build-essential libtool git-core autoconf automake cmake

if [ ! -d "mbpoll" ]; then
	sudo git clone https://github.com/epsilonrt/mbpoll.git
fi
if [ ! -d "libmodbus" ]; then
	sudo git clone https://github.com/stephane/libmodbus.git
fi

cd libmodbus
sudo git checkout v3.1.6
sudo ./autogen.sh
sudo ./configure
sudo make
sudo make install

cd ..
sudo apt install -y pkg-config
cd mbpoll
sudo mkdir -p build
cd build
sudo cmake ..

sudo make
sudo make install
sudo ldconfig
