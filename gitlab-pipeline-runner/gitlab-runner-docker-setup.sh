#!/bin/bash
# --
# https://medium.com/@tonywooster/docker-in-docker-in-gitlab-runners-220caeb708ca

export REG_TOKEN=xxxx1G3WxxxxzoZxxxxr

/etc/docker/daemon.json
echo '{"storage-driver": "overlay2"}' > /etc/docker/daemon.json

mkdir -p /srv/gitlab-runner

echo '
concurrent = 6
check_interval = 0

[session_server]
  session_timeout = 1800
' > /srv/gitlab-runner/config.toml

echo "docker ps -a | awk '{print $1}' | xargs docker rm" >> /srv/gitlab-runner/daily
echo "docker volume prune -f" >> /srv/gitlab-runner/daily
echo "docker image ls | grep -E '\.ecr\..+.amazonaws\.com' | awk '{print $3}' | xargs docker rmi -f" >> /srv/gitlab-runner/daily

systemctl restart docker
docker network create gitlab-runner-net

docker run -d \
  --name docker \
  --privileged \
  --restart always \
  --network gitlab-runner-net \
  -v /var/lib/docker \
  -v /srv/gitlab-runner/daily:/etc/periodic/daily/clean \
  docker:17.06.0-ce-dind \
    --storage-driver=overlay2

docker run -d \
  --name gitlab-runner \
  --restart always \
  --network gitlab-runner-net \
  -v /srv/gitlab-runner/config.toml:/etc/gitlab-runner/config.toml \
  -e DOCKER_HOST=tcp://docker:2375 \
  gitlab/gitlab-runner:alpine

docker run -it --rm \
  -v /srv/gitlab-runner/config.toml:/etc/gitlab-runner/config.toml \
  gitlab/gitlab-runner:alpine \
    register --non-interactive --url https://gitlab.com/ --description docker --executor docker --docker-image ruby:2.4 --registration-token $REG_TOKEN \
    --executor docker \
    --docker-image docker:17.06.0-ce \
    --docker-volumes /var/run/docker.sock:/var/run/docker.sock


###
# 
#.docker-server-vars: &docker-vars
#  #DOCKER_HOST: tcp://docker:2375
#  #DOCKER_DRIVER: overlay2
#  CI_BRANCH: $CI_COMMIT_REF_NAME
