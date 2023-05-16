# diatestsuite

## Requirements

* bash
* docker

## Development

Prepare files:

1. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git --depth 1`
2. Copy modified files: `cp -Rf test-current/* diadata/`

Start and install:

> Make sure you are in the injected `diadata/` directory

1. Start the local cluster: `./scripts/minikubeStart.sh`
2. Build the containers into cluster: `./scripts/minikubeBuild.sh`
3. Install the platform by running the script: `./scripts/minikubeInstall.sh`

Stop and uninstall:

> Make sure you are in the injected `diadata/` directory

1. Uninstall the platform: `./scripts/minikubeUninstall.sh`
2. Now you can safely stop the cluster: `./scripts/minikubeStop.sh`

Clean and reset the env:

> Before cleaning the files, make sure all services are stopped

1. Remove the files: `rm -rf diadata/`
2. Delete the cluster: `minikube delete --profile="diadata"`
3. Prune all unused cluster resources: `minikube ssh --profile diadata -- docker system prune -af`
4. Prune all local docker resources: `docker system prune -af`

## Update data

docker pull registry.hub.docker.com/alex1a/diadata.postgres

https://hub.docker.com/r/alex1a/diadata.postgres

> Make sure you have a cronjob service on your local system, in this case we use [cronie](https://github.com/cronie-crond/cronie/)

1. Create a script that will dump the data and update the postgres image: `sudo nano /usr/local/sbin/diadata-postgres-cron.sh`
2. Give the correct permission for script: `sudo chmod +x /usr/local/sbin/diadata-postgres-cron.sh`

```
#!/bin/bash

# ...
```

3. Create the log directory: `sudo mkdir -p /var/log/diadata/`
4. Create a cronjob for everyday: `sudo nano /etc/cron.d/diadata-postgres`

```
0 0 * * * root /usr/local/sbin/diadata-postgres-cron.sh >> /var/log/diadata/postgres-cron.log 2>&1
```

5. Restart cronjob service: `sudo systemctl restart cronie`
6. Wait and see the output of cronjob: `tail -f /var/log/diadata/postgres-cron.log`