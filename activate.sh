#!/bin/bash

ENV_NAME=$1
GO_VERSION=$2
if [ -z "${ENV_NAME}" ]; then
  echo "Goenv name is required"
  return
fi

if [ -z "${GO_VERSION}" ]; then
  GO_VERSION="1.1.1"
  return
fi


platform='unknown'
unamestr=`uname`
MACH="amd64"
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   platform='freebsd'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='darwin'
fi

# DOWNLOADING GO section
GO_URL="https://go.googlecode.com/files/go${GO_VERSION}.${platform}-${MACH}.tar.gz"
GOENV_CORE="${HOME}/.goenv"
GOENV_HOME="${HOME}/.goenv/${GO_VERSION}"
mkdir -p $GOENV_CORE
mkdir -p $GOENV_HOME
GOENV_PATH="${GOENV_HOME}/${ENV_NAME}"
mkdir -p ${GOENV_PATH}
mkdir -p ${GOENV_PATH}/src
mkdir -p ${GOENV_PATH}/pkg
GO_DOWNLOAD_FILE="${GOENV_HOME}/go${GO_VERSION}.tar.gz"
GO_DIR="${GOENV_HOME}/go-${GO_VERSION}"
if [ ! -f $GO_DOWNLOAD_FILE ]; then
	curl $GO_URL > $GO_DOWNLOAD_FILE
fi
if [ ! -d $GO_DIR ]; then
	mkdir -p $GO_DIR
	tar -xvzf $GO_DOWNLOAD_FILE -C $GO_DIR
fi

# SETTING VARIABLES UP
export GOROOT="${GO_DIR}/go"
export GOBIN="${GOROOT}/bin"
GO_IN_PATH=$(echo ":${PATH}:" | grep -q ":${GOBIN}:" | wc -l)
if [[ $GO_IN_PATH -eq 0 ]]; then
	export PATH="${GOBIN}:${PATH}"
fi

export GOPATH="${GOENV_PATH}:$(pwd)"

