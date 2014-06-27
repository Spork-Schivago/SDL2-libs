#!/bin/sh -e
# SDL2_IMAGE-2.0.0.sh by unknown (Updated by Spork Schivago)

SDL2_IMAGE=SDL2_image-2.0.0

## Download the source code.
if [ ! -f ${SDL2_IMAGE}.tar.gz ]; then wget --continue http://www.libsdl.org/projects/SDL_image/release/${SDL2_IMAGE}.tar.gz; fi

## Unpack the source code.
rm -Rf ${SDL2_IMAGE} && tar -xvzf ${SDL2_IMAGE}.tar.gz && cd ${SDL2_IMAGE}

## Patch the source code if a patch exists.
if [ -f ../../patches/${SDL2_IMAGE}.patch ]; then
  echo "patching ${SDL2_IMAGE}..."
  cat ../../patches/${SDL2_IMAGE}.patch | patch -p1;
fi

## Create the build directory.
mkdir build-ppu && cd build-ppu

## Configure the build.
CPPFLAGS="-I${PSL1GHT}/ppu/include/SDL -I${PS3DEV}/portlibs/ppu/include -I${PS3DEV}/portlibs/ppu/include/freetype2" \
CFLAGS="-I${PSL1GHT}/ppu/include/SDL -I${PS3DEV}/portlibs/ppu/include -I${PS3DEV}/portlibs/ppu/include/freetype2" \
LDFLAGS="-L${PSL1GHT}/ppu/lib -L${PS3DEV}/portlibs/ppu/lib -lrt -llv2" \
PKG_CONFIG_PATH="${PS3DEV}/portlibs/ppu/lib/pkgconfig" \
../configure --prefix="${PS3DEV}/portlibs/ppu" --host=powerpc64-ps3-elf \
	--disable-sdltest \
	--with-sdl-exec-prefix="${PS3DEV}/portlibs/ppu" \
	--disable-shared \
	LIBPNG_CFLAGS="`${PS3DEV}/portlibs/ppu/bin/libpng-config --cflags`" \
	LIBPNG_LIBS="`${PS3DEV}/portlibs/ppu/bin/libpng-config --libs`" 

## Compile and install.
${MAKE:-make} -j4 && ${MAKE:-make} install
