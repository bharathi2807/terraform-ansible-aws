#!/bin/bash
set -e

dnf update -y
dnf install -y nginx python3

systemctl start nginx
systemctl enable nginx

echo "Healthy - $(hostname)" > /usr/share/nginx/html/index.html