#!/bin/bash
set -xe

useradd build
mkdir -p /build/packages /build/srcpackages /build/repo /home/build /build/aursrc
chown -R build:build /build  /home/build/

echo 'PACKAGER="oott123 <archlinux-repo@public.oott123.com>"' >> /etc/makepkg.conf
echo 'PKGDEST=/build/packages' >> /etc/makepkg.conf
echo 'SRCPKGDEST=/build/srcpackages' >> /etc/makepkg.conf

pacman --noconfirm -Syu base base-devel git sudo

source /archtown/aur/packages

for pkgName in "${BUILD_AUR_PACKAGES[@]}"; do
  echo "=== Building ${pkgName} ==="
  /archtown/bin/buildaur "${pkgName}" || echo "Failed to build AUR ${pkgName}, continue for now ..."
done

echo '=== Building Repo ==='
repo-add -R -p /build/repo/archtown.db.tar.gz /build/packages/*
mv /build/packages/* /build/repo
