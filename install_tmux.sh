#!/bin/bash

# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $HOME/local/bin.
# It's assumed that wget and a C/C++ compiler are installed.
# gcc, g++, make

# exit on error
set -e

TMUX_VERSION=2.8

# create our directories
if [ ! -d "$HOME/local" ]; then
    echo "Creating a local directory in $HOME"
    mkdir -p $HOME/local
fi
mkdir -p $HOME/tmux_tmp
cd $HOME/tmux_tmp

# download source files for tmux, libevent, and ncurses
wget -O tmux-${TMUX_VERSION}.tar.gz https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
wget https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz
# extract files, configure, and compile

############
# libevent #
############
tar -xvzf libevent-2.1.8-stable.tar.gz
cd libevent-2.1.8-stable
./configure --prefix=$HOME/local --disable-shared
make
make install
cd ..

############
# ncurses  #
############
tar -xvzf ncurses-6.0.tar.gz
cd ncurses-6.0
sed -i 's/preprocessor=\"$1 -DNCURSES_INTERNALS -I..\/include\"/preprocessor=\"$1 -P -DNCURSES_INTERNALS -I..\/include\"/g' ./ncurses/base/MKlib_gen.sh
./configure --prefix=$HOME/local
make
make install
cd ..

############
# tmux     #
############
tar -xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}
./configure CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include"
CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib" make
cp tmux $HOME/local/bin
cd ..

# cleanup
rm -rf $HOME/tmux_tmp

echo "$HOME/local/bin/tmux is now available. You can optionally add $HOME/local/bin to your PATH."
