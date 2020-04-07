
# Install build dependencies

sudo apt install python3-pip python3-setuptools dbus debhelper desktop-file-utils dh-exec dh-python docbook-xml docbook-xsl dpkg-dev gettext gtk-doc-tools libdbus-1-dev libelf-dev libffi-dev libmount-dev libpcre3-dev libselinux1-dev libxml2-utils linux-libc-dev pkg-config python3 python3-dbus python3-gi shared-mime-info tzdata xsltproc xterm zlib1g-dev

sudo python3 -m pip install meson ninja

# Download sources

wget -q "https://download.gnome.org/sources/glib/2.64/glib-2.64.1.tar.xz"

tar -xJf  glib-2.59.3.tar.xz
cd glib-2.59.3

# Build

meson _build
ninja -C _build
mkdir -p ./install
mkdir -p "build_environment"
sudo ninja -C _build install | grep ^"Installing" | awk '{print "cp -v --parents",$4"/$(basename "$2") ./build_environment"}' | sh

# Compress and  copy to workspace

tar -cvzf glib-2.0.tar.gz build_environment/*
mv glib-2.0.tar.gz $GITHUB_WORKSPACE/
