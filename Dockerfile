FROM ubuntu:18.04

LABEL description="ubuntu with ssh and vnc" \
      author="wenkb" \
      create_date="2018-10-17" \
      build_cmd="docker build --rm -t wenkb/docker-ubuntu-ssh-vnc:v1.1 ."

# envrionment
ENV DEBIAN_FRONTEND=noninteractive \
    VNC_DISPLAY=:0 \
    VNC_PORT=5900 \
    VNC_GEOMETRY=1360x768 \
    ROOT_PW=password \
    TZ=Asia/Shanghai \
    LANG=zh_CN.UTF-8

USER root
WORKDIR /root

# change root password
RUN echo "root:$ROOT_PW" | chpasswd

# install software
RUN apt-get -y update \
 # tools
 && apt-get install -y wget net-tools locales bzip2 iputils-ping traceroute firefox firefox-locale-zh-hans ttf-wqy-microhei gedit ibus-pinyin \
 && locale-gen zh_CN.UTF-8 \
 # ssh
 && apt-get install -y openssh-server \
 && sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
 && mkdir /var/run/sshd \
 && mkdir /root/.ssh \
 # TigerVNC
 && wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.9.0.x86_64.tar.gz | tar xz --strip 1 -C / \
 && mkdir -p /root/.vnc \
 && echo $ROOT_PW | vncpasswd -f > /root/.vnc/passwd \
 && chmod 600 /root/.vnc/passwd \
 # xfce
 && apt-get install -y xfce4 xfce4-terminal \
 && apt-get purge -y pm-utils xscreensaver* \
 # sublime text 3
 && wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add - \
 && apt-get install -y apt-transport-https \
 && echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list \
 && apt-get -y update \
 && apt-get -y install sublime-text \
 # clean
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# create upload and download dir
RUN mkdir -p /home/upload \
 && mkdir -p /home/download

# xfce config
ADD ./xfce/ /root/

# copy bash file
COPY startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

EXPOSE 22 $VNC_PORT

CMD ["/root/startup.sh"]

