# install docker machine on your local computer#
if [ ! -f /usr/local/bin/docker-machine ]; then
    echo "installing docker-machine"
    export base=https://github.com/docker/machine/releases/download/v0.16.2
    curl -L ${base}/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine
    sudo mv /tmp/docker-machine /usr/local/bin/docker-machine
    chmod +x /usr/local/bin/docker-machine
else
    echo "docker-machine installed"
fi

# vboxmanage
sudo apt install virtualbox
