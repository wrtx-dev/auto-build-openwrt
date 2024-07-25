#!/bin/bash

if [[ $# -lt 3 ]]
then
    echo "Usage: ${0} path_of_rootfs path_of_wrtx_bin version"
    exit 1
fi

cur_dir=$(pwd)
install_dir="/usr/local/wrtx"

args=("$@")
images_arr=("${args[@]:0: $((${#args[@]} - 2 ))}")
wrtx_bin=${args[$((${#args[@]} - 2))]}
wrtx_base_dir="wrtx_deb"
wrtx_debian_dir="${wrtx_base_dir}/DEBIAN"
wrtx_root="${wrtx_base_dir}${install_dir}"
# wrtx_conf_dir="${wrtx_root}/conf"
wrtx_bin_dir="${wrtx_root}/bin"
wrtx_arch=$(uname -p)
if [ ${wrtx_arch} = "x86_64" ]
then
    cpu_arch="amd64"
else
    cpu_arch=${wrtx_arch}
fi

version="unknown"
if [ ${args[$((${#args[@]} - 1))]}"ttt" != "ttt" ]
then
    version=${args[$((${#args[@]}-1))]}
fi

wrtx_dirs=("bin" "conf" "images" "run" "instances")

mk_deb_dir() {
    test -d ${wrtx_base_dir} && rm -rvf ${wrtx_base_dir}
    mkdir -v ${wrtx_base_dir}
    mkdir -pv ${wrtx_root}
    
    
    for i in ${wrtx_dirs[@]}
    do
        mkdir -v ${wrtx_root}/${i}
    done
}

check_bin() {
    test -e ${wrtx_bin}
}

copy_files() {
    cp -v ${cur_dir}/postinst ${wrtx_debian_dir}
    chmod 755 ${wrtx_debian_dir}/postinst
    cp -v ${cur_dir}/postrm ${wrtx_debian_dir}
    chmod 755 ${wrtx_debian_dir}/postrm
    cp -v ${wrtx_bin} ${wrtx_bin_dir}
    for rootfs in ${images_arr[@]}
    do
	rootfs_name=$(basename ${rootfs})
	mkdir -v ${wrtx_root}/images/${rootfs_name/%_rootfs/}
        echo "cp -rvf ${rootfs}/* ${wrtx_root}/images/${rootfs_name/%_rootfs/}"
        cp -rvf ${rootfs}/* ${wrtx_root}/images/${rootfs_name/%_rootfs/}
    done

}


test -d build && rm -rvf build

check_bin || exit -1

mkdir build
cd build
mk_deb_dir
mkdir ${wrtx_debian_dir}
copy_files
cat >>${wrtx_debian_dir}/control<<EOF
Package: wrtX
Version: ${version}
Architecture: ${cpu_arch}
Maintainer: wrtX.dev <wrtx.dev@outlook.com>
Installed-Size: `du -ks wrtx_deb/usr|cut -f 1`
Pre-Depends:
Depends:
Recommends:
Suggests:
Section: devel
Priority: optional
Multi-Arch: foreign
Homepage: wrtx.dev
Description: run openwrt in simple namespace.

EOF


du -h -d 0

echo "dpkg -b ${wrtx_base_dir} wrtx-${wrtx_arch}-${version}.deb"
dpkg-deb -v -b ${wrtx_base_dir} wrtx-${wrtx_arch}-${version}.deb

mv wrtx-${wrtx_arch}-${version}.deb ../
