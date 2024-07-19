#!/bin/bash

[ -d openwrt ] && rm -rvf openwrt

mkdir openwrt

cd openwrt

git init && git remote add origin https://git.openwrt.org/openwrt/openwrt.git && git fetch origin 715634e6d1443eacdcb84b04d1028c1564b08dbf && git reset --hard FETCH_HEAD || exit 1


echo -e "src-git passwalldep https://github.com/xiaorouji/openwrt-passwall-packages.git \nsrc-git passwall https://github.com/xiaorouji/openwrt-passwall2.git" >> feeds.conf.default || exit 1

echo "copy .config file"
cp -v ../x86_64-config ./ || exit -1
