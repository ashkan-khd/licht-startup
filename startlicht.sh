#!/bin/bash


input_from_user () {
    while true
    do
     echo "$1 [Y|n]"
     read inp
     inp=$(echo "$inp" | tr '[:upper:]' '[:lower:]')
     if [[ $inp == "y" ]] || [[ $inp == "n" ]] || [[ $inp == "" ]];
     then
      if [[ $inp == "n" ]];
      then
       ret=0
      else
       ret=1
      fi
      break
     else
      echo "WRONG INPUT"
     fi
    done
    return $ret
}


yn_input () {
    input_from_user "Do you want to proceed (No to skip)?"
    ret=$?
    return $ret
}

phase1_chrome () {
    echo "Phase1: Install Chrome"
    yn_input
    yn=$?
    if [[ $yn == 0 ]];
    then
     echo "Phase1: Skiped"
     return
    fi
    cd ~/Downloads
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    cd
}

phase2_git () {
    echo "Phase2: Git"
    yn_input
    yn=$?
    if [[ $yn == 0 ]];
    then
     echo "Phase2: Skiped"
     return
    fi
    cd
    sudo apt update
    sudo apt -y install git
    ssh-keygen
    cat .ssh/id_rsa.pub
    echo ""
    echo "Phase2: Copy the above and add it to your github account. This is needed for further phases!"
    echo "Github add new ssh key: https://github.com/settings/ssh/new"
}

phase3_qv2ray () {
    echo "Phase3: Install Qv2ray"
    yn_input
    yn=$?
    if [[ $yn == 0 ]];
    then
     echo "Phase3: Skiped"
     return
    fi
    cd
    mkdir Qv2ray
    cd Qv2ray
    sudo apt -y install libfuse2
    wget "https://github.com/Qv2ray/Qv2ray/releases/download/v2.7.0/Qv2ray-v2.7.0-linux-x64.AppImage"
    chmod +x "Qv2ray-v2.7.0-linux-x64.AppImage"
    wget "https://github.com/XTLS/Xray-core/releases/download/v1.7.5/Xray-linux-64.zip"
    unzip Xray-linux-64.zip -d Xray
    rm Xray-linux-64.zip
    wget "https://github.com/ashkan-khd/licht-startup/releases/download/0.0.3/vless.txt"
    echo "Phase3: Remember to setup Qv2ray"
    cd
}

phase4_necessary_apps () {
    echo "Phase4: Install Terminator, Openconnect, Snap, Proxychains, Curl, Okular"
    yn_input
    yn=$?
    if [[ $yn == 0 ]];
    then
     echo "Phase4: Skiped"
     return
    fi
    cd
    sudo apt update
    sudo apt-get -y install openconnect network-manager-openconnect network-manager-openconnect-gnome
    sudo apt -y install terminator
    sudo apt -y install snapd
    sudo apt -y install proxychains
    # changing default port to 1089 (works for qv2ray)
    sed -i 's/9050/1089/g' proxychains.conf
    sudo apt -y install okular
    sudo apt -y install curl
    wget "https://github.com/ashkan-khd/licht-startup/releases/download/0.0.2/vpn.sh" -O ".vpn.sh"
}

phase5_applications() {
    echo "Phase5: Install Pycharm, Telegram, VLC, VS Code"
    yn_input
    yn=$?
    if [[ $yn == 0 ]];
    then
     echo "Phase5: Skiped"
     return
    fi
    cd
    input_from_user "Phase4: Do you want to use proxychains for better speed?"
    use_proxy=$?
    inst_pych="sudo snap install pycharm-professional --channel=2021.1/stable --classic"
    inst_teleg="sudo snap install telegram-desktop"
    inst_vlc="sudo snap install vlc"
    inst_vs_code="sudo snap install code --classic"
    if [[ $yn == 1 ]];
    then
      sudo snap set system proxy.http="http://127.0.0.1:8889"
      sudo snap set system proxy.https="http://127.0.0.1:8889"
    fi
    
    eval $inst_pych
    # for eval resetting pycharm
    wget "https://github.com/ashkan-khd/licht-startup/releases/download/0.0.2/ide-eval-resetter-2.1.9.jar"
    eval $inst_teleg
    eval $inst_vlc
    eval $inst_vs_code
    
    if [[ $yn == 1 ]];
    then
      sudo snap unset system proxy.http
      sudo snap unset system proxy.https
    fi
    
    echo "Phase5: Remember to install ide-eval-resetter on pycharm!"
}

phase6_python () {
    echo "Phase6: Python3.8"
    yn_input
    yn=$?
    if [[ $yn == 0 ]];
    then
     echo "Phase6: Skiped"
     return
    fi
    cd
    echo "Phase6: This method comes from here: https://www.linuxcapable.com/install-python-3-8-on-ubuntu-linux/"
    echo "May God Bless Him."
    echo "Phase6: Make sure Qv2ray is running!"
    sudo apt update
    sudo apt upgrade
    sudo apt install ca-certificates apt-transport-https software-properties-common lsb-release -y
    sudo gpg --list-keys
    sudo gpg --no-default-keyring --keyring /usr/share/keyrings/deadsnakes.gpg --keyserver keyserver.ubuntu.com --recv-keys F23C5A6CF475977595C89F51BA6932366A755776
    echo "deb [signed-by=/usr/share/keyrings/deadsnakes.gpg] https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/python.list
    sudo proxychains apt update
    sudo proxychains apt install python3.8
    sudo proxychains apt install python3.8-full
    wget https://bootstrap.pypa.io/get-pip.py
    python3.8 get-pip.py
    python3.8 -m pip install --upgrade pip
    rm get-pip.py
}

phase7_docker () {
    echo "Phase7: Docker engine"
    echo "Warning! Your Qv2ray must be runnnig for this part!"
    yn_input
    yn=$?
    if [[ $yn == 0 ]];
    then
     echo "Phase7: Skiped"
     return
    fi
    cd
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo proxychains sh get-docker.sh
    sudo usermod -aG docker $(whoami)
    echo "alias docker-compose='docker compose'" >> .bashrc
    rm get-docker.sh
    echo "Phase 7: Please restart your computer"
}


phase8_pip_packages () {
    echo "Phase8: install numpy, matplotlib, jupyter"
    yn_input
    yn=$?
    if [[ $yn == 0 ]];
    then
     echo "Phase8: Skiped"
     return
    fi
    cd
    sudo apt install python3.8-dev
    pip install -U psutil
    pip install Pillow
    pip install numpy
    pip install matplotlib
    pip install notebook
    echo "alias jn='jupyter notebook'" >> .bashrc
}

phase9_install_zsh () {
    echo "Phase9: install ZSH & OH MY ZSH"
    echo "Warning! Your Qv2ray must be runnnig for this part!"
    yn_input
    yn=$?
    if [[ $yn == 0 ]];
    then
     echo "Phase9: Skiped"
     return
    fi
    cd
    sudo proxychains apt update
    sudo proxychains apt install zsh
    echo "Phase9: Installed ZSH"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    $SHELL --version
    echo "Phase9: Installed OH MY ZSH"
}

phase10_configure_zsh () {
    echo "Phase10: configure ZSH"
    yn_input
    yn=$?
    if [[ $yn == 0 ]];
    then
     echo "Phase10: Skiped"
     return
    fi
    cd
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
    exec zsh
    sudo rm -rf ~/powerlevel10k 
}

from=$1
if [[ $from == "" ]];
then
 from=1
fi

array=("phase1_chrome" "phase2_git" "phase3_qv2ray" "phase4_necessary_apps" "phase5_applications" "phase6_python" "phase7_docker" "phase8_pip_packages" "phase9_configure_zsh" "phase10_configure_zsh")

curr=0
for i in "${array[@]}"; do
    let curr++
    if [[ $curr -ge $from ]];
    then
     eval $i
    fi 
done

