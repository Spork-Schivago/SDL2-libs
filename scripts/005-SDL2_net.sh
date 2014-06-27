#!/bin/sh
# SDL2_NET-2.0.0.sh by unknown (Updated by Spork Schivago)

SDL2_NET="SDL2_net-2.0.0"

## Download the source code.
if [ ! -f ${SDL2_NET}.tar.gz ]; then
  wget --continue http://www.libsdl.org/projects/SDL_net/release/${SDL2_NET}.tar.gz
fi

## Unpack the source code.
rm -Rf ${SDL2_NET} && tar -zxvf ${SDL2_NET}.tar.gz && cd ${SDL2_NET}

## Patch the source code if a patch exists.
if [ -f ../../patches/${SDL2_NET}.patch ]; then
  echo "patching ${SDL2_NET}..."
  cat ../../patches/${SDL2_NET}.patch | patch -p1;
fi

## Create the build directory.
mkdir build-ppu && cd build-ppu

# this is seems like a bug in (the version of) PSL1GHT/ps3toolchain
# (that I happen to have installed)
# CFLAGS="$CFLAGS -I$PSL1GHT/ppu/include"
# export CFLAGS

## Configure the build.
CPPFLAGS="-I${PSL1GHT}/ppu/include" \
CFLAGS="-I${PSL1GHT}/ppu/include" \
LDFLAGS="-L${PSL1GHT}/ppu/lib -lnet -lsysmodule" \
../configure --prefix="$PS3DEV/portlibs/ppu" --host=powerpc64-ps3-elf \
	--with-sdl-exec-prefix="$PS3DEV/portlibs/ppu" \
	--disable-sdltest \
	--disable-shared \
	--disable-gui

## Compile and install.
${MAKE:-make} -j4 && ${MAKE:-make} install
