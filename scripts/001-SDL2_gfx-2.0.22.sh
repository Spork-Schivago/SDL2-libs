#!/bin/sh -e
# SDL2_gfx-1.0.0.sh by unknown (Updated by Spork Schivago)

SDL2_GFX=SDL2_gfx-1.0.1

## Download the source code.
if [ ! -f ${SDL2_GFX}.tar.gz ]; then wget --continue http://sourceforge.net/projects/sdl2gfx/files/${SDL2_GFX}.tar.gz/download -O ${SDL2_GFX}.tar.gz; fi

## Unpack the source code.
rm -Rf ${SDL2_GFX} && tar -xvzf ${SDL2_GFX}.tar.gz && cd ${SDL2_GFX}

## Patch the source code if a patch exists.
if [ -f ../../patches/${SDL2_GFX}.patch ]; then
  echo "patching ${SDL2_GFX}..."
  cat ../../patches/${SDL2_GFX}.patch | patch -p1;
fi

## Create the build directory.
mkdir build-ppu && cd build-ppu

## Configure the build.
CFLAGS="-I${PSL1GHT}/ppu/include/SDL -I${PS3DEV}/portlibs/ppu/include/ -I${PS3DEV}/portlibs/ppu/include/freetype2" \
LDFLAGS="-L${PSL1GHT}/ppu/lib -L${PS3DEV}/portlibs/ppu/lib -lrt -llv2" \
PKG_CONFIG_PATH="${PS3DEV}/portlibs/ppu/lib/pkgconfig" \
../configure --prefix="${PS3DEV}/portlibs/ppu" --host=powerpc64-ps3-elf \
	--with-sdl-exec-prefix="${PS3DEV}/portlibs/ppu" \
	--disable-sdltest --disable-mmx --enable-option-checking

## Compile and install.
${MAKE:-make} -j4 $aclocal_kluge && ${MAKE:-make} $aclocal_kluge install
