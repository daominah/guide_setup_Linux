#!/usr/bin/env bash

set -x

apt remove --purge docker docker-engine docker.io containerd runc
apt remove --purge docker-ce docker-ce-cli containerd.io docker-compose-plugin

export SERVICE_NAME="containerd.service"
systemctl stop ${SERVICE_NAME}
systemctl disable ${SERVICE_NAME}
rm -rf /etc/systemd/system/${SERVICE_NAME}
rm -rf /etc/systemd/system/${SERVICE_NAME} # and symlinks that might be related
rm -rf /usr/lib/systemd/system/${SERVICE_NAME}
rm -rf /usr/lib/systemd/system/${SERVICE_NAME} # and symlinks that might be related

export SERVICE_NAME="docker.service.d"
systemctl stop ${SERVICE_NAME}
systemctl disable ${SERVICE_NAME}
rm -rf /etc/systemd/system/${SERVICE_NAME}
rm -rf /etc/systemd/system/${SERVICE_NAME} # and symlinks that might be related
rm -rf /usr/lib/systemd/system/${SERVICE_NAME}
rm -rf /usr/lib/systemd/system/${SERVICE_NAME} # and symlinks that might be related

systemctl daemon-reload
systemctl reset-failed

set +x
