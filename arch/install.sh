#!/bin/bash

# Update and install necessary packages
sudo pacman -Syu
sudo pacman -S --noconfirm alacritty tmux fish neovim vmware-horizon-client nodejs npm protobuf libusb webkit2gtk gtk3 git minikube kubectl docker

# Install yay
if ! command -v yay &> /dev/null; then
    echo "yay not found, installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Install NvChad
git clone https://github.com/NvChad/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# Create alacritty toml file
touch ~/.config/alacritty/alacritty.toml

# create tmux config
touch ~/.tmux.conf

# Install Visual Studio Code using yay
yay -S --noconfirm visual-studio-code-bin

# Install Rust using rustup
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y

# Configure the current shell to use Rust
source $HOME/.cargo/env

# Add Rust configuration to shell startup scripts
echo 'source $HOME/.cargo/env' >> ~/.bashrc
echo 'source $HOME/.cargo/env' >> ~/.zshrc
echo 'source $HOME/.cargo/env' >> ~/.config/fish/config.fish

# Verify Rust installation
rustc --version

# Install Fisher plugin manager for Fish shell
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# Install Fish plugins using Fisher
fisher install jorgebucaran/nvm.fish
fisher install PatrickF1/fzf.fish

# Install buf modules
npm i -g @bufbuild/connect-web @bufbuild/connect @bufbuild/buf @bufbuild/protobuf

# Install Helm 
echo "Installing Helm..."
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
echo "Helm installed successfully."

# Download and install Nerd Font
FONT_DIR="$HOME/Downloads"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Monaspace.tar.xz"
FONT_FILE="$FONT_DIR/Monaspace.tar.xz"

echo "Downloading Nerd Font to $FONT_DIR..."
curl -L $FONT_URL -o $FONT_FILE

# Create and write to the udev rules file with the specified content
sudo bash -c 'cat > /etc/udev/rules.d/50-zsa.rules' <<EOF
# Rules for Oryx web flashing and live training
KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

# Legacy rules for live training over webusb (Not needed for firmware v21+)
# Rule for all ZSA keyboards
SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
# Rule for the Moonlander
SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
# Rule for the Ergodox EZ
SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
# Rule for the Planck EZ
SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"

# Wally Flashing rules for the Ergodox EZ
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

# Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
# Keymapp Flashing rules for the Voyager
SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
EOF

# Print completion message for udev rules
echo "Udev rules file created and content added successfully!"

# Download and install Oryx
ORYX_DIR="$HOME/"
ORYX_URL="https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.tar.gz"
ORYX_FILE="$ORYX_DIR/keymapp-latest.tar.gz"

echo "Downloading Oryx keyboard config to $ORYX_DIR..."
curl -L $ORYX_URL -o $ORYX_FILE

# Extract Oryx tar.gz file
echo "Extracting Oryx keyboard config..."
tar -xzf $ORYX_FILE -C $ORYX_DIR

# Set executable permissions for the extracted files (if needed)
chmod -R +x $ORYX_DIR/keymapp

# Clean up tar file
rm $ORYX_FILE

# install exa
cargo install exa

# install Rust repo
cd ~/Documents/
git clone https://github.com/rust-lang/rust.git

# Print completion message
echo "Installation completed successfully!"
