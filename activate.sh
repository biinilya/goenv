#!/bin/bash

platform='unknown'
pversion='unknown'
unamestr=`uname`
MACH="amd64"
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   platform='freebsd'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='darwin'
   pversion=$(sw_vers | grep ProductVersion | awk '{print $2;}')
   #if [[ "$pversion" == '10.9' ]]; then
     pversion="10.8"
   #fi
fi

GO_VERSION=1.2

goenv_download() {
  # DOWNLOADING GO section
  if [ ! -f $GO_DOWNLOAD_FILE ]; then
  	echo $GO_URL
  	curl $GO_URL > $GO_DOWNLOAD_FILE
  	mkdir -p $GO_DIR
  	tar -xvzf $GO_DOWNLOAD_FILE -C $GO_DIR || rm -rf $GO_DOWNLOAD_FILE
  fi
}

goenv_setup() {
  # SETTING VARIABLES UP
  GO_URL="https://go.googlecode.com/files/go${GO_VERSION}.${platform}-${MACH}.tar.gz"
  if [ $(expr ${GO_VERSION} \>= 1.2) -eq 1 ]; then
    if [[ "$platform" == 'darwin' ]]; then
      GO_URL="https://go.googlecode.com/files/go${GO_VERSION}.${platform}-${MACH}-osx${pversion}.tar.gz"
    fi
  fi
  GOENV_HOME="${HOME}/.goenv"
  mkdir -p $GOENV_HOME
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

  for FPATH in $(pwd)/src $(pwd)/src/gitlab.ostrovok.ru/ostrovok $(pwd)/src/gitlab.ostrovok.ru/ostrovok/i.biin; do
    mkdir -p $FPATH
    ln -sf $(pwd)/ $FPATH/${GOENV_NAME}
  done

  CUR_PATH=$PATH
  export PATH="${GOROOT}/bin:$GOBIN"
  for p in ${CUR_PATH//:/ }; do [[ ! "$p" =~ 'goenv' ]] && export PATH="$PATH:$p"; done;
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
    go get github.com/mattn/gom
    rm -rf vendor
    ln -sf $GOENV_PATH vendor
  fi
  $GOBIN/gom $@
}

gocode() {
  if [[ -z $GOENV_PATH ]]; then
    echo "You should init goenv before using gocode"
    return
  fi
  if [ ! -f $GOBIN/gocode ]; then
    $GOBIN/go get github.com/nsf/gocode
  fi
  $GOBIN/gocode $@
}
