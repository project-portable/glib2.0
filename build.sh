#!/bin/bash

  sudo sed -i 's|^# deb-src|deb-src|g' /etc/apt/sources.list
  sudo apt update  2>&1 > /dev/null
  sudo apt install curl
  sudo apt build-dep gtk+2.0 2>&1 > /dev/null

  wget -q https://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.32.tar.xz
  tar -xf gtk+-2.24.32.tar.xz
  cd gtk+-2.24.32/
  patch -Np1 -i ../xid-collision-debug.patch
  patch -Np1 -i ../gtk2-filechooser-icon-view.patch
  sed -i '1s/python$/&2/' gtk/gtk-builder-convert
  ./configure \
    --prefix=/usr \
    --sysconfdir=/etc \
    --localstatedir=/var \
    --with-xinput=yes \
    --disable-gtk-doc
  make
  sudo make install 

cp /usr/lib/libgdk-x11-2.0.so.0.2400.32 .
cp /usr/lib/libgtk-x11-2.0.so.0.2400.32 .

wget https://raw.githubusercontent.com/probonopd/uploadtool/master/upload.sh

bash upload.sh libgdk-x11-2.0.so.0.2400.32 libgtk-x11-2.0.so.0.2400.32
