#!/usr/bin/env bash

CGO_ENABLED=0 GOOS=linux /usr/local/go/bin/go build -o webhostname.bin -a -ldflags '-extldflags "-static"' /Users/yannicklorenzati/w/terraform_devoxx/goapp/webhostname.go
chmod +x webhostname.bin
