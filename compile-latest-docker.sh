#!/usr/bin/env bash

# https://github.com/docker/docker/archive/v1.12.3.zip

REF_UN=$(git ls-remote --tags git://github.com/docker/docker.git |\
   grep -v "\-rc" | \
   sort -t '/' -k 3 -V | \
   grep "refs/tags/v"  | \
   tail -n 1)

REF_HASH=$(echo $REF_UN|awk '{print $1}')
REF=$(echo $REF_UN|awk '{print $2}')

VERSION=${REF#refs/tags/}
DOWNLOAD="${VERSION}.zip"


if [ ! -f $DOWNLOAD ]; then
  echo "Downloading Docker-$VERSION "
  curl -L https://github.com/docker/docker/archive/$DOWNLOAD -o $DOWNLOAD
else
  echo "Docker-$VERSION already downloaded."
fi

if [ ! -d ./docker-${VERSION#v} ]; then
  unzip $DOWNLOAD
fi
cd docker-${VERSION#v}

export DOCKER_GITCOMMIT=$REF_HASH 
export AUTO_GOPATH=1
./hack/make.sh dynbinary


