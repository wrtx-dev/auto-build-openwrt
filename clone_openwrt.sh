#!/bin/bash

[ -d openwrt ] && rm -rvf openwrt

if [ $# -ne 1 ]
then
    echo "Usage: $0 commit_id"
    exit 1
fi

commit_id=${1}

mkdir openwrt

cd openwrt

git init && git remote add origin https://git.openwrt.org/openwrt/openwrt.git && git fetch origin ${commit_id} && git reset --hard FETCH_HEAD || exit 1


echo -e "src-git passwalldep https://github.com/xiaorouji/openwrt-passwall-packages.git \nsrc-git passwall https://github.com/xiaorouji/openwrt-passwall2.git" >> feeds.conf.default || exit 1
