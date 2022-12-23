# install Docker and docker-machine on Ubuntu server

## try to run the following auto installer 

[docker_machine_install_remote.sh](docker_machine_install_remote.sh)

if it does not returns any errors: you installed Docker successfully on the
remote machine, its docker service API listens on port 2376, authenticated by
cert files `$HOME/.docker/machine/certs` (in your local computer).

## install Docker Engine on Ubuntu

<https://docs.docker.com/engine/install/ubuntu/>

## copy docker-machine certificates to remote machine

````bash
export MACHINE0=examplemachine0

docker-machine regenerate-certs ${MACHINE0}

docker-machine scp $HOME/.docker/machine/machines/${MACHINE0}/ca.pem ${MACHINE0}:/etc/docker/
docker-machine scp $HOME/.docker/machine/machines/${MACHINE0}/server.pem ${MACHINE0}:/etc/docker/
docker-machine scp $HOME/.docker/machine/machines/${MACHINE0}/server-key.pem ${MACHINE0}:/etc/docker/
````

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
