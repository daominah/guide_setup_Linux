#!/usr/bin/env bash

set -x
set -e

export nodeIPs=(123.123.123.123 123.123.123.124)  # change this to real IPs
export sshKey="${HOME}/.ssh/id_rsa"
export machinePrefix=examplecluster

for i in ${!nodeIPs[@]}
do
    echo "setting up docker on ${machinePrefix}${i}"
    docker-machine --debug --native-ssh create --driver generic \
        --generic-ip-address=${nodeIPs[i]} \
        --generic-ssh-port=22 \
        --generic-ssh-user=root \
        --generic-ssh-key ${sshKey} \
        ${machinePrefix}${i}

    # creating machine will fail SSH because docker-machine is out dated, so:
    # * install docker manually
    # * config docker engine API listen open port 2376
    # then run `docker-machine regenerate-certs ${machinePrefix}${i}`.
    # later segment will show how to do these steps.

    # allow non root docker if needed
    # docker-machine ssh ${machinePrefix}${i} sudo usermod -aG docker $USER

    # gen a ssh key, it usually is used for git auth
    docker-machine ssh ${machinePrefix}${i} 'ssh-keygen -f ~/.ssh/id_rsa -P ""'
    docker-machine ssh ${machinePrefix}${i} 'cat ~/.ssh/id_rsa.pub'

    # common packages
    docker-machine ssh ${machinePrefix}${i} sudo apt install -qy git
    docker-machine ssh ${machinePrefix}${i} "ssh-keyscan -p 22 github.com >> ~/.ssh/known_hosts"
done

set +e
set +x
