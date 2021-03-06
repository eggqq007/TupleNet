#!/usr/bin/env bash

if [ "$1" == "-use-vendor" ];then
    USE_VENDOR="-mod=vendor"
fi

cd $(dirname $0)

COMMIT=$(git rev-parse HEAD)
TAGGING=$(git name-rev --tags --name-only ${COMMIT})
BUILD_TIME=$(date '+%F %T %Z')

go test ${USE_VENDOR} ./{tpctl,tpcnm,tpcni,logicaldev,controllers/...} || echo "WARNING: test case failed !!!"

GOBIN=$(pwd)/bin GOOS=linux GOARCH=amd64 go install ${USE_VENDOR} -ldflags "-X main.commit=${COMMIT} -X main.tag=${TAGGING} -X \"main.buildTime=${BUILD_TIME}\"" ./{tpctl,tpcnm,tpcni,tpmpa} || exit 1
