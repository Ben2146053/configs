#!/bin/bash

echo "Please enter the path to your custom configuration directory located in ~home/:"
read -r USER_INPUT
echo "Please enter pacman pacakages would like to install "
read -r PACKAGES_INPUT
echo "Please enter git username "
read -r GIT_USER_INPUT
echo "Please enter git email address "
read -r GIT_EMAIL_INPUT


# <VARIABLES>
CONFIG_PATH=${USER_INPUT:-~/Documents/configs/}
PACKAGES=${PACKAGES_INPUT:-"git base-devel vmware-horizon-client"}
GIT_USER=$GIT_USER_INPUT
GIT_EMAIL=$GIT_EMAIL_INPUT
# </VARIABLES>


# <PACMAN>
sudo pacman -Syu
sudo pacman -S --noconfirm $PACKAGES
# </PACMAN>


# <FIREFOX>
sudo pacman -S --noconfirm firefox
profile_folder=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name "*default-release")
if [ -z "$profile_folder" ]; then
    echo "Firefox profile folder with 'default-release' not found."
    exit 1
fi
# Path to prefs.js file in the profile folder
prefs_js_path="$profile_folder/prefs.js"

# Enable toolkit.legacyUserProfileCustomizations.stylesheets
if ! grep -q 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' "$prefs_js_path"; then
    echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$prefs_js_path"
    echo "Enabled toolkit.legacyUserProfileCustomizations.stylesheets in prefs.js"
else
    echo "toolkit.legacyUserProfileCustomizations.stylesheets is already enabled"
fi

css_source=$CONFIG_PATH/firefox/chrome/userChrome.css
mkdir -p "$profile_folder/chrome"
cp "$css_source" "$profile_folder/chrome/userChrome.css"
# </FIREFOX>


# <GIT>
sudo pacman -S --noconfirm git
git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_EMAIL"
# </GIT>


# <DOCKER>
sudo pacman -S --noconfirm docker
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER
# </DOCKER>


# <NEOVIM>
sudo pacman -S --noconfirm neovim
git clone https://github.com/NvChad/starter ~/.config/nvim
rm -rf ~/.config/nvim/
for item in $CONFIG_PATH/nvim/*; do
    ln -s $item ~/.config/nvim/$(basename $item)
done
# </NEOVIM>


# <ALACRITTY>
sudo pacman -S --noconfirm alacritty
mkdir -p ~/.config/alacritty
ln -s $CONFIG_PATH/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
# </ALACRITTY>


# <TMUX>
sudo pacman -S --noconfirm tmux
ln -s $CONFIG_PATH/tmux/.tmux.conf ~/.tmux.conf
# </TMUX>


# <FISH>
sudo pacman -S --noconfirm fish
chsh -s /usr/bin/fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher install jorgebucaran/nvm.fish
fisher install PatrickF1/fzf.fish
ln -s $CONFIG_PATH/fish/fish.config ~/.config/fish/config.fish
# </FISH>


# <VSCODE>
cd ~/Downloads/
git clone https://aur.archlinux.org/visual-studio-code-bin.git
cd visual-studio-code-bin
makepkg -si
cd ..
rm -rf visual-studio-code-bin
reset
# </VSCODE>


# <RUST>
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y
cd ~/Documents/
git clone https://github.com/rust-lang/rust.git
reset
cargo install exa
cargo install cargo-tarpaulin
sudo pacman -S --noconfirm gdb git base-devel cmake
cd ~/Downloads/
git clone https://aur.archlinux.org/rr.git
cd rr
makepkg -si
cd ..
rm -rf rr
wget -P ~ https://git.io/.gdbinit
ln -s $CONFIG_PATH/gdb/.gdbinit ~/.gdbinit
reset
# </RUST>


# <NPM>
sudo pacman -S --noconfirm nodejs npm protobuf
sudo npm i -g @bufbuild/connect-web @bufbuild/connect @bufbuild/buf @bufbuild/protobuf
# </NPM>


# <MINIKUBE>
sudo pacman -S --noconfirm kubectl
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
# </MINIKUBE>


# <MONOSPACE>
FONT_DIR="$HOME/Downloads"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Monaspace.tar.xz"
FONT_FILE="$FONT_DIR/Monospace.tar.xz"
EXTRACT_DIR="$FONT_DIR/Monospace"
curl -L $FONT_URL -o $FONT_FILE
mkdir -p $EXTRACT_DIR
tar -xvf $FONT_FILE -C $EXTRACT_DIR
mkdir -p ~/.local/share/fonts
find $EXTRACT_DIR -name "*.otf" -exec cp {} ~/.local/share/fonts/ \;
fc-cache -fv
# </MONOSPACE>


# <MOONLANDER>
sudo pacman -S --noconfirm libusb webkit2gtk gtk3
sudo bash -c 'cat > /etc/udev/rules.d/50-zsa.rules' <<EOF
KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
EOF
ORYX_DIR="$HOME/"
ORYX_URL="https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.tar.gz"
ORYX_FILE="$ORYX_DIR/keymapp-latest.tar.gz"
curl -L $ORYX_URL -o $ORYX_FILE
tar -xzf $ORYX_FILE -C $ORYX_DIR
chmod -R +x $ORYX_DIR/keymapp
rm $ORYX_FILE
# </MOONLANDER>


# <MISC>
rm -r ~/Videos ~/Pictures ~/Templates ~/Public ~/Desktop
mkdir Apps
mv ~/keymapp ~/Apps/
sudo pacman -S --noconfirm base-devel vmware-horizon-client
# </MISC>


echo "Installation completed successfully!"