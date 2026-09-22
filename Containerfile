FROM ghcr.io/ublue-os/bluefin:stable

# 1. 软件源与系统配置（对应 script 模块）
RUN dnf -y copr enable zhullyb/v2rayA \
    && echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/99-ip-forward.conf

# 2. 系统软件包分层安装（对应 rpm-ostree 模块）
# rpm-ostree 环境下建议安装后清理元数据以减小体积
RUN rpm-ostree install \
    btop \
    fastfetch \
    flameshot \
    fuse \
    gedit \
    git \
    htop \
    ipset \
    iptables \
    kwrite \
    meld \
    open-vm-tools \
    open-vm-tools-desktop \
    pluma \
    trojan \
    v2raya \
    vim \
    wget \
    && ostree container commit

# 3. 启用系统服务（对应 systemd 模块）
RUN systemctl enable v2raya.service vmtoolsd.service

# 4. 配置系统预装 Flatpak
RUN mkdir -p /etc/flatpak/install.d \
    && printf "%s\n" \
       "com.google.Chrome" \
       "com.dropbox.Client" \
       "com.visualstudio.code" \
       "org.mozilla.firefox" \
       "com.github.tchx84.Flatseal" \
       "io.missioncenter.MissionCenter" \
       "com.jianguoyun.Nutstore" \
       "io.github.peazip.PeaZip" \
       "net.nokyan.Resources" \
       "org.telegram.desktop" \
       "com.xnview.XnViewMP" \
       > /etc/flatpak/install.d/custom-flatpaks.txt

