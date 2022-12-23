# install Docker and docker-machine on Ubuntu server

## try to run the following auto installer 
if it does not returns any errors: you installed Docker successfully on the
remote machine, its docker service API listens on port 2376, authenticated by
cert files `$HOME/.docker/machine/certs` (in your local computer).

````bash
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
````

## install Docker Engine on Ubuntu

[URL](https://docs.docker.com/engine/install/ubuntu/)

## config docker engine API listen open port 2376

* `systemctl edit docker.service`
* edit the config to
  ````bash
  [Service]
  ExecStart=
  ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock --storage-driver overlay2 --tlsverify --tlscacert /etc/docker/ca.pem --tlscert /etc/docker/server.pem --tlskey /etc/docker/server-key.pem --label provider=generic 
  Environment=
  ````
  (notice when edit: "lines below this comment will be discarded")
* `systemctl daemon-reload`
* `systemctl restart docker.service`
