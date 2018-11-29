# ccat
ccat_url=https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz
wget "$ccat_url" /tmp/ccat.tar.gz
tar xzf -C /tmp
cp /tmp/linux-amd64-1.1.0/ccat ~/.local/bin

# universal-ctags
git clone git@github.com:universal-ctags/ctags.git
./autogen.sh
./configure --prefix=$HOME/.local # defaults to /usr/local
make -j7
make install # may require extra privileges depending on where to install

# global
