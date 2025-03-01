# Ubuntu Custom Docker Image

Ubuntu container image với các package cơ bản được cài đặt sẵn cho Mikrotik RouterOS.

## Thông tin đăng nhập
- Username: sekuritim
- Password: tester

## Các package đã cài đặt
- SSH Server
- Nginx
- Python3
- Git
- Network tools (nmap, netcat, traceroute, etc.)
- System tools (htop, vim, nano, etc.)

## Sử dụng trên Mikrotik RouterOS

```bash
# Cấu hình container
/container config set registry-url=https://registry-1.docker.io tmpdir=disk1/tmp

# Tạo veth interface
/interface veth add name=veth1
/ip address add address=172.17.0.1/24 interface=veth1

# Pull và chạy container
/container add remote-image=yourusername/ubuntu-custom interface=veth1
/container start 0
