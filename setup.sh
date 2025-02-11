#!/bin/bash

### Follow arch installation guide until chroot
##  Only install essentials and microcode

# check if root
if [[ "$UID" -ne 0 ]]; then
	echo "Must run as root!" >&2
	exit 3
fi

### Config options
locale="en_US.UTF-8"
keymap="us"
timezone="America/Chicago"
hostname="fellsedge"
username="fell"

# update hostname

new_hostname=""
read -p "HOSTNAME=fellsedge -> keep hostname? [Y/n]: " new_hostname
if [ -n new_hostname ]; then
	hostname="$new_hostname"
fi

# time
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc

# localization & network
echo "UTF-8" > /etc/locale.gen
echo "$locale" >> /etc/locale.gen
echo "LANG=$locale" > locale.conf
echo "$hostname" > /etc/hostname

# root & user setup
echo "root password: "
passwd
useradd -m -G wheel "$username"
echo "$username password"
passwd "$username"

### Userspace setup

# package list (NOT INCLUDING ARCH INSTALL)
packages=(
	"sway"
	"swaybg"
	"waybar"
	"fuzzel"
	"ttf-font-awesome"
	"networkmanager"
	"pulseaudio"
	"brightnessctl"
	"vim"
	"neovim"
	"kitty"
	"sudo"
	"git"
	"firefox"
	"base-devel"
	"man-db"
	"efibootmgr"
)

# update packages
pacman -Sy

# install packages
for package in "${packages[@]}"; do
	pacman -S --noconfirm $package
done

# create mountpoints
mkdir -p /mnt/usb

# set sudo
cp sudoers /etc/sudoers

# switch to user
su "$username"

# load config files

cp -r config ~/.config   
cp bashrc ~/.bashrc

# remind BOOTLOADER
prinf "\nMAKE SURE YOU SET UP BOOTLOADER\n"

# git details
git config --global user.email "fell@fellsedge.com"
git config --global user.name "FellsEdge"
