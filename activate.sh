#!/bin/bash

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

GO_VERSION=1.1.2

goenv_download() {
  # DOWNLOADING GO section
  if [ ! -f $GO_DOWNLOAD_FILE ]; then
  	curl $GO_URL > $GO_DOWNLOAD_FILE
  	mkdir -p $GO_DIR
  	tar -xvzf $GO_DOWNLOAD_FILE -C $GO_DIR || rm -rf $GO_DOWNLOAD_FILE
  fi
}

goenv_setup() {
  # SETTING VARIABLES UP
  GO_URL="https://go.googlecode.com/files/go${GO_VERSION}.${platform}-${MACH}.tar.gz"
  GOENV_HOME="${HOME}/.goenv"
  GOENV_TOOLS="${GOENV_HOME}/tools"
  mkdir -p $GOENV_HOME
  mkdir -p $GOENV_TOOLS
  GOENV_PATH="${GOENV_HOME}/${GOENV_NAME}"
  mkdir -p ${GOENV_PATH}
  mkdir -p ${GOENV_PATH}/src
  mkdir -p ${GOENV_PATH}/pkg
  mkdir -p ${GOENV_PATH}/bin
  GO_DOWNLOAD_FILE="${GOENV_HOME}/go${GO_VERSION}.tar.gz"
  GO_DIR="${GOENV_HOME}/go-${GO_VERSION}"

  export GOROOT="${GO_DIR}/go"
  export GOBIN="${GOENV_PATH}/bin"
  export GOPATH="${GOENV_PATH}:$(pwd)"

  ln -sf ${GOROOT}/bin/go $GOBIN/go
  ln -sf ${GOROOT}/bin/gofmt $GOBIN/gofmt
  ln -sf ${GOROOT}/bin/godoc $GOBIN/godoc
  export PATH="$GOBIN:$PATH"
}

goclean() {
  rm -rf ${GOENV_PATH}/pkg || true
}

gopurge() {
  goclean
  rm -rf ${GOENV_PATH} || true
}

goversion() {
  if [[ ! -z $1 ]]; then
    GO_VERSION=$1
    goenv_setup
    goenv_download
  else
    echo $GO_VERSION
  fi
  goclean
}

goon() {
  GOENV_NAME=$(basename `pwd`)
  if [[ ! -z $1 ]]; then
    GOENV_NAME=$1
  fi
  goenv_setup
  goenv_download
  goclean
}

gom() {
  if [[ -z $GOENV_PATH ]]; then
    echo "You should init goenv before using gom"
    return
  fi
  if [ ! -f $GOBIN/gom ]; then
    $GOBIN/go get github.com/mattn/gom
    rm -rf vendor
    ln -sf $GOENV_PATH vendor
  fi
  $GOBIN/gom $@
}
