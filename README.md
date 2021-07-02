<p align="center">
  <img src="https://raw.githubusercontent.com/wiki/globocom/huskyCI/images/huskyCI-logo.png" align="center" height="" />
</p>

**WARNING**: this is a fork repository, feel free to use it and contribute here but I recommend to try the [official repository](https://github.com/globocom/huskyCI) first.

## Introduction

Please look at the official [documentation page](https://huskyci.opensource.globo.com/docs/quickstart/overview).

## Getting Started

Follow this steps to setting up huskyCI using Docker Compose.

1. Clone this repository

```
git clone https://github.com/rogeriobastos/huskyCI.git
cd huskyCI/
echo "export HUSKYCI_PATH='${PWD}'" > .env
echo "export HUSKYCI_SCRIPTS='${PWD}/deployments/scripts'" >> .env
source .env
```

1. Create certificates

This certificates are used to protect the communication between huskyCI and docker daemon.

```
echo "export HUSKYCI_CERT_PATH='${HUSKYCI_PATH}/certs'" >> $HUSKYCI_PATH/.env
echo "export HUSKYCI_CERT_PASSPHRASE='mypassword'" >> $HUSKYCI_PATH/.env
echo "export HUSKYCI_DOCKERAPI_HOST='address.to.dockerapi.host'" >> $HUSKYCI_PATH/.env
echo "export HUSKYCI_DOCKERAPI_ADDR='1.2.3.4'" >> $HUSKYCI_PATH/.env
echo "export HUSKYCI_HOST='address.to.huskyci.host'" >> $HUSKYCI_PATH/.env
source $HUSKYCI_PATH/.env
make create-certs
```

1. Configure the docker daemon

HuskyCI requires a docker daemon listening on a TCP port to start the security test containers. You can use the local docker daemon or a remote one (in a VM for example). For security reasons we also configure docker to only allows connections from clients authenticated by a certificate signed by that CA generated above. For more details about this configuration look at docker documentation [here](https://docs.docker.com/engine/install/linux-postinstall/#configure-where-the-docker-daemon-listens-for-connections) and [here](https://docs.docker.com/engine/security/protect-access/#use-tls-https-to-protect-the-docker-daemon-socket).

Use the command `systemctl edit docker.service` to open an override file for docker.service in a text editor.

Add the following lines.

```
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --tlsverify --tlscacert=/path/to/certs/docker/ca.pem --tlscert=/path/to/certs/docker/server-cert.pem --tlskey=/path/to/certs/docker/server-key.pem -H fd:// -H tcp://0.0.0.0:2376
```

Reload systemd and restart docker.

```
systemctl daemon-reload
systemctl restart docker.service
```

1. Configure MongoDB

Set up MongoDB init file.

```
echo "export HUSKYCI_DATABASE_DB_NAME='huskyCIDB'" >> $HUSKYCI_PATH/.env
echo "export HUSKYCI_DATABASE_DB_USERNAME='huskyCIUser'" >> $HUSKYCI_PATH/.env
echo "export HUSKYCI_DATABASE_DB_PASSWORD='huskyCIPassword'" >> $HUSKYCI_PATH/.env
source $HUSKYCI_PATH/.env
make prepare-local-mongodb
```

1. Configure HuskyCI

```
echo "export HUSKYCI_API_DEFAULT_USERNAME='huskyCIUser'" >> $HUSKYCI_PATH/.env
echo "export HUSKYCI_API_DEFAULT_PASSWORD='huskyCIPassword'" >> $HUSKYCI_PATH/.env
echo "export HUSKYCI_API_ALLOW_ORIGIN_CORS='\"*\"'" >> $HUSKYCI_PATH/.env
source $HUSKYCI_PATH/.env
```

1. Build and run HuskyCI and MongoDB containers

Docker compose will start up mongodb and huskyCI and you can reach uskyCI API at `http://localhost:8888/`.

```
make compose-up
```

## License

huskyCI is licensed under the [BSD 3-Clause "New" or "Revised" License](https://github.com/globocom/huskyCI/blob/master/LICENSE.md).
