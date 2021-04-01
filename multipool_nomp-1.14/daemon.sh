#!/usr/bin/env bash
#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
source /etc/multipool.conf
source $STORAGE_ROOT/nomp/.nomp.conf

echo -e " Installing BitCoin PPA...$COL_RESET"
if [ ! -f /etc/apt/sources.list.d/bitcoin.list ]; then
  hide_output sudo add-apt-repository -y ppa:bitcoin/bitcoin
fi
echo -e "$GREEN Done...$COL_RESET"

echo -e " Installing additional system files required for daemons...$COL_RESET"
hide_output sudo apt-get update
apt_install build-essential libtool autotools-dev \
automake pkg-config libssl-dev libevent-dev bsdmainutils git libboost-all-dev libminiupnpc-dev \
libqt5gui5 libqt5core5a libqt5webkit5-dev libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev \
protobuf-compiler libqrencode-dev libzmq3-dev
echo -e "$GREEN Done...$COL_RESET"

cd $STORAGE_ROOT/nomp/nomp_setup/tmp

echo -e " Building Berkeley 4.8, this may take several minutes...$COL_RESET"
sudo mkdir -p $STORAGE_ROOT/berkeley/db4/
hide_output sudo wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
hide_output sudo tar -xzvf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix/
hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$STORAGE_ROOT/berkeley/db4/
hide_output sudo make install
cd $STORAGE_ROOT/nomp/nomp_setup/tmp
sudo rm -r db-4.8.30.NC.tar.gz db-4.8.30.NC
echo -e "$GREEN Done...$COL_RESET"

echo -e " Building Berkeley 5.1, this may take several minutes...$COL_RESET"
sudo mkdir -p $STORAGE_ROOT/berkeley/db5/
hide_output sudo wget 'http://download.oracle.com/berkeley-db/db-5.1.29.tar.gz'
hide_output sudo tar -xzvf db-5.1.29.tar.gz
cd db-5.1.29/build_unix/
hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$STORAGE_ROOT/berkeley/db5/
hide_output sudo make install
cd $STORAGE_ROOT/nomp/nomp_setup/tmp
sudo rm -r db-5.1.29.tar.gz db-5.1.29
echo -e "$GREEN Done...$COL_RESET"

echo -e " Building Berkeley 5.3, this may take several minutes...$COL_RESET"
sudo mkdir -p $STORAGE_ROOT/berkeley/db5.3/
hide_output sudo wget 'http://anduin.linuxfromscratch.org/BLFS/bdb/db-5.3.28.tar.gz'
hide_output sudo tar -xzvf db-5.3.28.tar.gz
cd db-5.3.28/build_unix/
hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$STORAGE_ROOT/berkeley/db5.3/
hide_output sudo make install
cd $STORAGE_ROOT/nomp/nomp_setup/tmp
sudo rm -r db-5.3.28.tar.gz db-5.3.28
echo -e "$GREEN Done...$COL_RESET"

echo -e " Building OpenSSL 1.0.2g, this may take several minutes...$COL_RESET"
cd $STORAGE_ROOT/nomp/nomp_setup/tmp
hide_output wget https://www.openssl.org/source/openssl-1.0.2g.tar.gz --no-check-certificate
hide_output tar -xf openssl-1.0.2g.tar.gz
cd openssl-1.0.2g
hide_output ./config --prefix=$STORAGE_ROOT/openssl --openssldir=$STORAGE_ROOT/openssl shared zlib
hide_output make
hide_output sudo make install
cd $STORAGE_ROOT/nomp/nomp_setup/tmp
sudo rm -r openssl-1.0.2g.tar.gz openssl-1.0.2g
echo -e "$GREEN Done...$COL_RESET"

echo -e " Building bls-signatures, this may take several minutes...$COL_RESET"
cd $STORAGE_ROOT/nomp/nomp_setup/tmp
hide_output sudo wget 'https://github.com/codablock/bls-signatures/archive/v20181101.zip'
hide_output sudo unzip v20181101.zip
cd bls-signatures-20181101
hide_output sudo cmake .
hide_output sudo make install
cd $STORAGE_ROOT/nomp/nomp_setup/tmp
sudo rm -r v20181101.zip bls-signatures-20181101
echo -e "$GREEN Done...$COL_RESET"

echo -e "$GREEN Daemon setup completed...$COL_RESET"

cd $HOME/multipool/nomp
