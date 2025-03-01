FROM ubuntu:latest

# Tránh tương tác trong quá trình cài đặt
ENV DEBIAN_FRONTEND=noninteractive

# Cập nhật và cài đặt các package cơ bản
RUN apt update && apt install -y \
    openssh-server \
    sudo \
    curl \
    wget \
    vim \
    nano \
    net-tools \
    iputils-ping \
    dnsutils \
    iptables \
    tcpdump \
    htop \
    nginx \
    python3 \
    python3-pip \
    git \
    ufw \
    zip \
    unzip \
    screen \
    nmap \
    netcat \
    telnet \
    traceroute \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Tạo user và cấu hình SSH
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 sekuritim
RUN echo 'sekuritim:tester' | chpasswd

# Cấu hình SSH
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Cấu hình timezone
RUN ln -fs /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

# Tạo thư mục làm việc
RUN mkdir -p /workspace
WORKDIR /workspace

# Mở port SSH và HTTP
EXPOSE 22 80

# Script khởi động
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
