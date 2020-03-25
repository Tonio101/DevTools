#!/bin/bash

echo "Requirements:"
echo "- Clang or GCC version 4.4+"
echo "- CMake version 2.8.12+, with TLS/SSL Support"

read -p "Do you have root permissions in this server? [y/n] " RESPONSE

get_neovim_repo() {
  git clone https://github.com/neovim/neovim.git
  cd neovim
}

build_neovim() {
  if [ ! -d "$HOME/local/neovim" ]; then
    echo "Creating a local directory in $HOME/local/neovim"
    mkdir -vp $HOME/local/neovim
  fi
  get_neovim_repo
  make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/local/neovim"
  make install
  echo "Add the following to your PATH environment variable:"
  echo "export PATH=\$HOME/local/neovim/bin:\$PATH"
  cd ../
  rm -rf ./neovim

}

case $RESPONSE in
  "y")
    sudo apt-get install ninja-build gettext libtool libtool-bin \
      autoconf automake cmake g++ pkg-config unzip -y
    build_neovim
  ;;
  "n")
    echo "You need to install the following packages:"
    echo "ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip."
    read -p "Do you wish to continue installing neovim without the packages mentioned above? [y/n]" RESPONSE_CONTINUE
    case $RESPONSE_CONTINUE in
      "y")
        build_neovim
      ;;
      "n")
        exit 0
      ;;
      *)
        echo "Invalid input"
      esac
  ;;
  *)
    echo "Invalid input!"
  ;;
esac
