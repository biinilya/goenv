package main

import (
	_ "github.com/golang/lint/golint"
	_ "github.com/kisielk/errcheck"
	_ "github.com/tools/godep"
	_ "github.com/ungerik/pkgreflect"
	_ "golang.org/x/tools/cmd/callgraph"
	_ "golang.org/x/tools/cmd/digraph"
	_ "golang.org/x/tools/cmd/eg"
	_ "golang.org/x/tools/cmd/goimports"
	_ "golang.org/x/tools/cmd/vet"
	_ "golang.org/x/tools/cmd/vet/whitelist"
)

func main() {

}
