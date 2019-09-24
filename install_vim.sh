#!/bin/bash

read -p "Do you have root permissions in this server? [y/n] " RESPONSE

get_vim_repo() {
  git clone https://github.com/vim/vim.git
  cd vim
}

case $RESPONSE in
  "y")
    sudo apt-get update
    sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
      libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
      libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
      python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git -y
    get_vim_repo
    echo "Good time to grab a cup of coffee :)"
    sleep 5
    ./configure --with-features=huge
    make
    sudo make install
  ;;
  "n")
    if [ ! -d "$HOME/local" ]; then
      echo "Creating a local directory in $HOME"
      mkdir -p $HOME/local
    fi
    get_vim_repo
    echo "Good time to grab a cup of coffee :)"
    sleep 5
    #Need to install ncurses if not there
    #LDFLAGS=-L$HOME/local/lib ./configure --prefix=$HOME/local --with-features=huge
    #See install_tmux.sh
    ./configure --prefix=$HOME/local --with-features=huge
    make
    make install
    echo "Please add the following to your PATH variable:"
    echo "export PATH=$HOME/local/bin:$PATH"
    echo "Don't forget to: source ~/.bashrc"
  ;;
  *)
    echo "Invalid input!"
  ;;
esac
