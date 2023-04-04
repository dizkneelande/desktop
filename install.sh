#!/bin/bash 

## -- Confirm yay is installed ---- ##
ISYAY=/sbin/yay
if [ -f "$ISYAY" ]; then
	echo -e "yay! found yay\n"
	yay -Syu
else
	echo -e "install yay first you great buffoon\n" 
	exit
fi

## -- Install packages ---- ##
read -n1 -rep 'install desktop? it gonna take a while... (y,n)' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
	yay -S --noconfirm hyprland-bin hyprpicker ttf-ubuntu-font-family ttf-ubuntu-nerd thunar thunar-archive-plugin xfce4-terminal swaybg swaylock-effects wofi wlogout mako polkit-gnome python-requests swappy grim slurp pamixer brightnessctl gvfs bluez bluez-utils xfce4-settings xdg-desktop-portal-hyprland-git sddm-git noise-suppression-for-voice wl-clipboard wf-recorder noto-fonts-cjk brave-bin bibata-cursor-theme-bin catppuccin-gtk-theme-mocha papirus-icon-theme waybar-hyprland nwg-look kitty noto-fonts-emoji sddm-config-editor-git plymouth-git sddm-catppuccin-git qt5-wayland geany pavucontrol sddm-git pipewire pipewire-{alsa,jack,pulse}
	
	# enable sddm
	echo -e "enabling sddm service...\n"
	sudo systemctl enable --now sddm.service
	
	# remove conflicting portals
	echo -e "removing conflicting portals... \n"
	yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk
	
	# copy configs
	echo -e "copying configs...\n"
	cp -R catppuccin-wallpapers ~/Pictures
	cp -R hypr ~/.config/
	cp -R wofi ~/.config/
	cp -R waybar ~/.config/
	cp -R wlogout ~/.config/
	cp -R mako ~/.config/
	cp -R swaylock ~/.config/
	chmod +x ~/.config/waybar/scripts/waybar-wttr.py
fi
