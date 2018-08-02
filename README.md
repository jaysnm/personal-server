# Personal Server

This repository contains the docker containers and `docker-compose.yml`'s required to launch my personal server. Applications hosted by this server can be found at [apps.samabbott.co.uk](https://apps.samabbott.co.uk), although the server is designed to serve users from [samabbott.co.uk](https://www.samabbott.co.uk/#projects).

Modification to another use case should be straightforward. Any suggestions for improvements are welcome.

## Set-up

The server can be launched using the following `bash` commands (implemented in the `set-up-server.sh` bash script) once the secrets folder has been setup as required.

- Clone this repository into a docker and docker-compose enabled environment.

```bash
git clone https://github.com/seabbs/personal-server.git
```
-  Add required secrets to the `secrets` folder. Subdirectories are named based on the container they provide secrets for. Required container secrets are listed in `containers/docker-compose.yml`

- Add docker network

```bash
docker network create shinyproxy-net
```

- Pull all images.

```bash
 docker-compose -f containers/docker-compose.yml pull --ignore-pull-failures
```

- Build all images.

```bash
 docker-compose -f containers/docker-compose.yml build
```

- Change permissions for Jenkins

```bash
sudo chown -R 1000:1000 secrets/jenkins
```

- Launch all services

```bash
 docker-compose up -d
```

There should now be a shinyproxy instance at `8080` , a jenkins instance at `9090`, and an Rstudio instance at `8888`.


## Scheduled jobs

The Jenkins instance (found at `localhost:9090`) is used to run scheduled docker containers. Currently these jobs are;

- Run the [`h2o` StackOverflow Twitter bot](https://github.com/seabbs/h2o_tweets) every 15 minutes (`H/15 * * * *`) with,

```bash
cd ..
sudo docker-compose -f personal-server/containers/docker-compose.yml run h2o_tweets bash bin/run_h2o_bot.sh
```

- Run the second [summary `h2o` StackOverflow Twitter bot](https://github.com/seabbs/h2o_tweets) every month (`H 0 01 * *`) with,

```bash
cd ..
sudo docker-compose -f personal-server/containers/docker-compose.yml run h2o_tweets bash bin/run_h2o_monthly_bot.sh
```

- Run the [Rstudio Cheatsheet Twitter Bot](https://github.com/seabbs/TweetRstudioCheatsheets) once a day (`H 0 * * *`) with,

```bash
cd ..
sudo docker-compose -f personal-server/containers/docker-compose.yml run tweetrstudiocheatsheets Rscript bot.R
```

- Back up the server storage once a day (`H 1 * * *`) to a Google bucket with,

```bash
cd ..
bash personal-server/push_to_bucket.sh
```

## Connecting to the server

If properly configured the Shinyproxy instance can be found at [apps.samabbott.co.uk](https://apps.samabbott.co.uk), with the Rstudio instance at [rstudio.samabbott.co.uk](https://rstudio.samabbott.co.uk) (password controlled via `secrets`). In order to access the Jenkins server connect over ssh, forwarding `9090`. Similarly both the ShinyProxy instance and the Rstudio instance may also be accessed using port forwarding (`8080` and `8888` respectively).

## Future developments

Below are the current aims for this repo, any suggestions for improvements are welcome.

- [ ] Automated tear down and restarting of Rstudio Server on R release.
- [ ] Jupyter Notebook hosting.
- [ ] Transition to Kubernetes (using Google Cloud managed service).
- [ ] Transition to Shinyproxy `2.0.0` after key bugs are fixed.
- [ ] Shinyproxy default to public access with some restricted apps.
- [ ] Shinyproxy logging
- [ ] Link to database service for persistent data storage.
