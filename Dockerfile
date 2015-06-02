FROM base/arch

MAINTAINER rijalati@gmail.com

RUN [ -d /etc/pacman.d ] || mkdir -p /etc/pacman.d

RUN pacman -Syy
RUN pacman -S --noconfirm archlinux-keyring
RUN pacman -Syu -y --needed --noconfirm --force
RUN pacman-db-upgrade
RUN pacman -Syu --noconfirm --needed \
    base-devel \
    python2 \
    python2-pip \
    salt-raet \
    emacs-nox \
    vim \
    vim-plugins \
    mksh \
    bash \
    sudo \
    git \
    wget \
    openbsd-netcat \
    socat \
    inetutils \
    wxgtk2.8 \
    wxpython2.8 \
    xorg-xauth \
    xorg-fonts \
    xorg-fonts-75dpi \
    xorg-fonts-100dpi \
    firefox \
    pass \
    fping \
    hping \
    autossh \
    nmap \
    traceroute \
    tmux

RUN pip2 install --upgrade pip setuptools 
RUN pip2 install \
    Paver \
    robotframework \
    robotframework-tools \
    robotframework-rfdoc \
    robotframework-selenium2library \
    robotframework-selenium2screenshots \
    robotframework-sshlibrary \
    robotframework-hub \
    robotframework-lint \
    robotframework-pageobjects \
    robotframework-pycurllibrary \
    robotframework-httplibrary \
    sphinxcontrib-robotframework \
    Pygments \
    pep8 \
    pylint \
    jedi \
    pyvmomi 
    
RUN pip2 install robotframework-databaselibrary     
RUN useradd -m -G wheel -U admin 
RUN echo 'admin:secret' | chpasswd
RUN echo 'admin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN pacman -R --noconfirm systemd-sysvcompat openssh autossh
USER admin
ENV HOME /home/admin
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
WORKDIR /home/admin
RUN wget -o aur.sh aur.sh
RUN mv index.html aur.sh
RUN chmod +x aur.sh
RUN ["/bin/sh", "/home/admin/aur.sh", "-si", "--noconfirm", "aura-bin"]
RUN sudo aura -A --noconfirm --force tm s6 selenium-server-standalone rc.local.d star rpm-org google-chrome openssh-hpn-git 

RUN git clone https://github.com/vmware/pyvmomi-community-samples.git
RUN git clone https://github.com/vmware/pyvmomi-tools.git
RUN git clone https://github.com/lamw/vghetto-scripts.git
RUN git clone https://github.com/robotframework/RIDE.git 
RUN git clone https://github.com/rijalati/dotfiles.git
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | /bin/bash
RUN bash --rcfile /home/admin/.bashrc -c "pyenv update"
RUN wget http://download.opensuse.org/repositories/home:/zhonghuaren/Fedora_21/x86_64/nmake-20110208-6.1.x86_64.rpm
RUN sudo rpm -ivh nmake-20110208-6.1.x86_64.rpm

RUN cp dotfiles/mkshrc ~/.mkshrc

CMD ["/usr/bin/mksh"]
