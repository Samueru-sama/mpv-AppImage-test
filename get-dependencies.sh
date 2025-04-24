#!/bin/sh

set -ex

sed -i 's/DownloadUser/#DownloadUser/g' /etc/pacman.conf

if [ "$(uname -m)" = 'x86_64' ]; then
	PKG_TYPE='x86_64.pkg.tar.zst'
else
	PKG_TYPE='aarch64.pkg.tar.xz'
fi
LIBXML_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/libxml2-iculess-$PKG_TYPE"
FFMPEG_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/ffmpeg-mini-$PKG_TYPE"
OPUS_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/opus-nano-$PKG_TYPE"
LLVM_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/llvm-libs-nano-$PKG_TYPE"
MESA_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/mesa-mini-$PKG_TYPE"
VULKAN_RADEON_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/vulkan-radeon-mini-$PKG_TYPE"
VULKAN_INTEL_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/vulkan-intel-mini-$PKG_TYPE"
VULKAN_NOUVEAU_url="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/vulkan-nouveau-mini-$PKG_TYPE"
VULKAN_PANFROST_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/vulkan-panfrost-mini-$PKG_TYPE"
VULKAN_FREEDRENO_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/vulkan-freedreno-mini-$PKG_TYPE"
VULKAN_BROADCOM_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/vulkan-broadcom-mini-$PKG_TYPE"

echo "Installing build dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	alsa-lib \
	base-devel \
	desktop-file-utils \
	ffmpeg \
	git \
	glibc \
	hicolor-icon-theme \
	jack \
	lcms2 \
	libarchive \
	libass \
	libbluray \
	libcdio \
	libcdio-paranoia \
	libdrm \
	libdvdnav \
	libdvdread \
	libegl \
	libgl \
	libglvnd \
	libjpeg-turbo \
	libplacebo \
	libpulse \
	libsixel \
	libva \
	libvdpau \
	libx11 \
	libxext \
	libxkbcommon \
	libxpresent \
	libxrandr \
	libxss \
	libxv \
	luajit \
	mesa \
	meson \
	nasm \
	patchelf \
	libpipewire \
	rubberband \
	openal \
	strace \
	uchardet \
	vulkan-headers \
	vulkan-icd-loader \
	vulkan-radeon \
	wayland \
	wayland-protocols \
	wget \
	xorg-server-xvfb \
	zlib \
	zsync


echo "Installing debloated pckages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$LIBXML_URL"          -O ./libxml2-iculess.pkg.tar.zst
wget --retry-connrefused --tries=30 "$FFMPEG_URL"          -O ./ffmpeg-mini.pkg.tar.zst
wget --retry-connrefused --tries=30 "$OPUS_URL"            -O ./opus-nano.pkg.tar.zst
wget --retry-connrefused --tries=30 "$LLVM_URL"            -O ./llvm-libs.pkg.tar.zst
wget --retry-connrefused --tries=30 "$MESA_URL"            -O ./mesa.pkg.tar.zst
wget --retry-connrefused --tries=30 "$VULKAN_RADEON_URL"   -O ./vulkan-radeon.pkg.tar.zst
wget --retry-connrefused --tries=30 "$VULKAN_NOUVEAU_URL"  -O ./vulkan-radeon.pkg.tar.zst

if [ "$(uname -m)" = 'x86_64' ]; then
	wget --retry-connrefused --tries=30 "$VULKAN_INTEL_URL"     -O ./vulkan-intel.pkg.tar.zst
else
	wget --retry-connrefused --tries=30 "$VULKAN_PANFROST_URL"  -O ./vulkan-panfrost.pkg.tar.zst
	wget --retry-connrefused --tries=30 "$VULKAN_FREEDRENO_URL" -O ./vulkan-freedreno.pkg.tar.zst
	wget --retry-connrefused --tries=30 "$VULKAN_BROADCOM_URL"  -O ./vulkan-broadcom.pkg.tar.zst
fi

pacman -U --noconfirm ./*.pkg.tar.zst
rm -f ./*.pkg.tar.zst

# Remove vapoursynth since ffmpeg-mini doesn't link to it
pacman -Rsndd --noconfirm vapoursynth

echo "All done!"
echo "---------------------------------------------------------------"
