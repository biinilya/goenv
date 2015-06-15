#!/bin/bash
OLD_UMASK=$(umask)
umask 0000

ge_go_env_contains () {
	WHAT=$1;shift
	for IDX in $@; do
		if [ "$IDX" = "$WHAT" ]; then
			return 0
		fi
	done
	return 1
}

ge_md5 () {
	perl -MDigest::MD5=md5_hex -e "print md5_hex(<>)"|cut -b 1-8
}

ge_bye () {
	echo Failed
	exit 1
}

ge_dump_env () {
	export GOENV_UPDATED=$(echo $(env|grep -o '[^=]*'))
	env|grep -vE "ge_|PWD"|sed -Ee 's/([^=]*)=(.*)$/export \1="\2"/g'
}

ge_pkg_install() {
	ge_PKGID=$ge_HOME/pkg_$1
	if [[ ! -f $ge_PKGID ]]; then
		echo "Installing $1"
		go install $2 && touch $ge_PKGID
	fi
}

ge_prepare_env() {
	mkdir -p $ge_HOME
	echo "Activating gvm"
	. $GVM_ROOT/scripts/gvm-default || ge_bye

	if ! ge_go_env_contains $ge_GO_VERSION $(gvm list|grep -Eo "go[^ ]*$"); then
		TERM=linux gvm install $ge_GO_VERSION --prefer-binary || ge_bye
	fi

	if [ -z $(echo $GOROOT|grep -E "/$ge_GO_VERSION$") ]; then
		gvm use $ge_GO_VERSION || ge_bye
	fi

	if [[ ! -z $VIRTUAL_ENV ]]; then 
		PRJ=$(basename $VIRTUAL_ENV)
		gvm pkgset create $PRJ 2>/dev/null
		gvm pkgset use $PRJ
	fi

	export GOBIN=$ge_HOME/bin
	export PATH=$GOBIN:$PATH

	if [[ ! -d $GOBIN ]]; then
		mkdir -p $GOBIN
	fi

	if [[ ! -z $GOEXTRA ]]; then
		GOPATH=$GOPATH:$GOEXTRA
	fi

	if [[ ! -z $GOENV_CONTRIB ]]; then
		GOPATH=$GOPATH:$GOENV_CONTRIB
	fi

	ge_pkg_install errcheck github.com/kisielk/errcheck
	ge_pkg_install godep github.com/tools/godep
	ge_pkg_install goimports golang.org/x/tools/cmd/goimports
	ge_pkg_install golint github.com/golang/lint/golint
	ge_pkg_install pkgreflect github.com/ungerik/pkgreflect
	ge_pkg_install digraph golang.org/x/tools/cmd/digraph
	ge_pkg_install eg golang.org/x/tools/cmd/eg
	ge_pkg_install callgraph golang.org/x/tools/cmd/callgraph
	ge_pkg_install gb github.com/constabulary/gb

	find $ge_HOME -iname "__env.*" -mtime +1 -exec rm {} \;
	ge_dump_env > $ge_ORIGINS
}

ge_HOME=$GOENV_DIR/.goenv
ge_GO_VERSION=go1.4.2
ge_OHASH=$( (env;cat $0)|ge_md5 )
ge_ORIGINS=$ge_HOME/__env.$ge_OHASH

if [[ ! -f $ge_ORIGINS ]]; then
	if [[ -z "$@" ]]; then
		ge_prepare_env
	else
		ge_prepare_env 1>/dev/null
	fi
fi

if [[ $1 == "activate" ]]; then
	exec cat $ge_ORIGINS
fi

umask $OLD_UMASK
. $ge_ORIGINS
exec "$@"
