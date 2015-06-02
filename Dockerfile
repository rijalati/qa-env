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
RUN mkdir -p /opt/ast/bin
WORKDIR /opt/ast
ENV PATH $HOME/.pyenv/bin:$PATH:/opt/ast/bin
RUN wget -O - http://www.research.att.com/sw/download/package > bin/package
RUN chmod +x bin/package
RUN package authorize "I accept www.opensource.org/licenses/eclipse" password "." flat setup binary http://www.research.att.com/sw/download ast-cql
RUN package flat install /opt/ast ast-cql
RUN useradd -m -G wheel -U admin 
RUN echo 'admin:secret' | chpasswd
RUN echo 'admin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN pacman -R --noconfirm systemd-sysvcompat
USER admin
ENV HOME /home/admin
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
WORKDIR /home/admin
RUN wget -o aur.sh aur.sh
RUN mv index.html aur.sh
RUN chmod +x aur.sh
RUN ["/bin/sh", "/home/admin/aur.sh", "-si", "--noconfirm", "aura-bin"]
RUN sudo aura -A --noconfirm --force tm s6 selenium-server-standalone rc.local.d star google-chrome openssh-hpn-git 
RUN sudo pacman -S --noconfirm openntpd
RUN git clone https://github.com/vmware/pyvmomi-community-samples.git
RUN git clone https://github.com/vmware/pyvmomi-tools.git
RUN git clone https://github.com/lamw/vghetto-scripts.git
RUN git clone https://github.com/robotframework/RIDE.git 
RUN git clone https://github.com/rijalati/dotfiles.git
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | /bin/bash
RUN bash -c "source .bashrc && if [[ -x /home/admin/.bash_profile ]]; then source ./.bash_profile && pyenv update; fi;"

RUN cp dotfiles/mkshrc ~/.mkshrc
RUN cp dotfiles/kshrc ~/.kshrc

#CMD ["/usr/bin/bash"]
#CMD ["/usr/bin/mksh"]
#CMD ["/bin/sh"]
CMD ["/opt/ast/bin/ksh"]
