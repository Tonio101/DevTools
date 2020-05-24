#!/bin/bash

# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $TMUX_BUILD_DIR/bin.
# It's assumed that wget and a C/C++ compiler are installed.
# gcc, g++, make

# exit on error
set -e

TMUX_VERSION=3.0a
TMUX_BUILD_DIR=$HOME/local/TMUX

# create our directories
if [ ! -d "$TMUX_BUILD_DIR" ]; then
    echo "Creating a local directory in $TMUX_BUILD_DIR"
    mkdir -p $TMUX_BUILD_DIR
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
./configure --prefix=$TMUX_BUILD_DIR --disable-shared
make
make install
cd ..

############
# ncurses  #
############
tar -xvzf ncurses-6.0.tar.gz
cd ncurses-6.0
sed -i 's/preprocessor=\"$1 -DNCURSES_INTERNALS -I..\/include\"/preprocessor=\"$1 -P -DNCURSES_INTERNALS -I..\/include\"/g' ./ncurses/base/MKlib_gen.sh
./configure --prefix=$TMUX_BUILD_DIR
make
make install
cd ..

############
# tmux     #
############
tar -xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}
./configure CFLAGS="-I$TMUX_BUILD_DIR/include -I$TMUX_BUILD_DIR/include/ncurses" LDFLAGS="-L$TMUX_BUILD_DIR/lib -L$TMUX_BUILD_DIR/include/ncurses -L$TMUX_BUILD_DIR/include"
CPPFLAGS="-I$TMUX_BUILD_DIR/include -I$TMUX_BUILD_DIR/include/ncurses" LDFLAGS="-static -L$TMUX_BUILD_DIR/include -L$TMUX_BUILD_DIR/include/ncurses -L$TMUX_BUILD_DIR/lib" make
cp tmux $TMUX_BUILD_DIR/bin
cd ..

# cleanup
rm -rf $HOME/tmux_tmp

echo "\$TMUX_BUILD_DIR/bin/tmux is now available. You can optionally add $TMUX_BUILD_DIR/bin to your PATH."
