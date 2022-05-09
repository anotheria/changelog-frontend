#!/usr/bin/env bash

cp -r ../dist ./target
docker build -t anotheria/changelog-front .
rm -rf ./target
