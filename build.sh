#!/bin/bash
set -xe

BUILD_DATE=`date`

docker rm -f build || true
docker run --name=build -v `pwd`:/archtown -d archlinux sleep 72h
docker exec build bash /archtown/build-in-container.sh
docker cp build:/build/repo .
docker rm -f build

rm -f repo/*.old

git -C repo init
git -C repo config --local user.email "action@github.com"
git -C repo config --local user.name "GitHub Action"
git -C repo add .
git -C repo commit -m "Automatically Build at ${BUILD_DATE}"
