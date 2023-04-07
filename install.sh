# set some colors
CNT="[\e[1;36mNOTE\e[0m]"
COK="[\e[1;32mOK\e[0m]"
CER="[\e[1;31mERROR\e[0m]"
CAT="[\e[1;37mATTENTION\e[0m]"
CWR="[\e[1;35mWARNING\e[0m]"
CAC="[\e[1;33mACTION\e[0m]"
INSTLOG="install.log"

#clear the screen
clear

# set some expectations for the user
echo -e "$CNT - get fkn ready for some sweet hyprland action!! c:\n"

sleep 3

read -n1 -rep $'[\e[1;33mACTION\e[0m] - u ready? (y,n) ' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
    echo -e "$COK - starting install script"
else
    echo -e "$CNT - kbye" 
    exit
fi

sleep 3

#### check for yay ####
ISYAY=/sbin/yay
if [ -f "$ISYAY" ]; then 
    echo -e "$COK - yay was located, moving on"
else 
    echo -e "$CWR - install yay first you great buffoon"
    read -n1 -rep $'[\e[1;33mACTION\e[0m] - u wanna install yay? (y,n) ' INSTYAY
    if [[ $INSTYAY == "Y" || $INSTYAY == "y" ]]; then
        git clone https://aur.archlinux.org/yay-git.git &>> $INSTLOG
        cd yay-git
        makepkg -si --noconfirm &>> ../$INSTLOG
        cd ..
        
    else
        echo -e "$CER - Yay is required for this script, now exiting"
        exit
    fi
fi


### install pacakges ####
read -n1 -rep $'[\e[1;33mACTION\e[0m] - wanna install the packages? (y,n) ' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
    # update the DB first
    echo -e "$COK - updating yay database..."
    yay -Suy --noconfirm &>> $INSTLOG
    
    #Stage 1
    echo -e "\n$CNT - installing many stuff... brb"
    for SOFTWR in xdg-user-dirs hyprland hyprpicker ttf-ubuntu-font-family ttf-ubuntu-nerd thunar thunar-archive-plugin file-roller xfce4-terminal swaybg swaylock-effects wofi wlogout mako polkit-gnome python-requests swappy grim slurp pamixer brightnessctl gvfs bluez bluez-utils xfce4-settings xdg-desktop-portal-hyprland-git sddm-git noise-suppression-for-voice wl-clipboard wf-recorder noto-fonts-cjk brave-bin bibata-cursor-theme-bin catppuccin-gtk-theme-mocha papirus-icon-theme waybar-hyprland-git nwg-look kitty noto-fonts-emoji sddm-config-editor-git plymouth-git sddm-catppuccin-git qt5-wayland geany pavucontrol sddm-git pipewire pipewire-{alsa,jack,pulse} 
    do
        #First lets see if the package is there
        if yay -Qs $SOFTWR > /dev/null ; then
            echo -e "$COK - $SOFTWR is already installed"
        else
            echo -e "$CNT - now installing $SOFTWR ..."
            yay -S --noconfirm $SOFTWR &>> $INSTLOG
            if yay -Qs $SOFTWR > /dev/null ; then
                echo -e "$COK - $SOFTWR was installedn"
            else
                echo -e "$CER - $SOFTWR install failed, check the install.log"
                exit
            fi
        fi
    done

    # Enable the sddm login manager service
    echo -e "$CNT - enabling sddm service..."
    sudo systemctl enable sddm &>> $INSTLOG
	xdg-user-dirs-update
    sleep 2
    
    # Clean out other portals
    echo -e "$CNT - cleaning out conflicting xdg portals..."
    yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk &>> $INSTLOG
fi

### Copy Config Files ###
read -n1 -rep $'[\e[1;33mACTION\e[0m] - do u want these fine af configs? (y,n) ' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
    echo -e "$CNT - Copying config files..."
    for DIR in hypr mako swaylock waybar wlogout wofi
    do 
        DIRPATH=~/.config/$DIR
        if [ -d "$DIRPATH" ]; then 
            echo -e "$CAT - Config for $DIR located, backing up."
            mv $DIRPATH $DIRPATH-back &>> $INSTLOG
            echo -e "$COK - Backed up $DIR to $DIRPATH-back."
        fi
        echo -e "$CNT - Copying $DIR config to $DIRPATH."  
        cp -R $DIR ~/.config/ &>> $INSTLOG
    done

    # Set some files as executable
    echo -e "$CNT - setting some file as executable" 
    chmod +x ~/.config/waybar/scripts/waybar-wttr.py

### Script is done ###
echo -e "$CNT - omg we done!!"
read -n1 -rep $'[\e[1;33mACTION\e[0m] - jump to hyprland now? (y,n) ' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
    exec sudo systemctl start sddm &>> $INSTLOG
else
    exit
fi

