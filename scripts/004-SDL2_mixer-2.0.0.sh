#!/bin/sh -e
# SDL2_MIXER-2.0.0.sh by unknown (Updated by Spork Schivago)

SDL2_MIXER=SDL2_mixer-2.0.0
LIBMIKMOD_CONFIG="$PS3DEV/portlibs/ppu/bin/libmikmod-config"
export LIBMIKMOD_CONFIG

## Download the source code.
if [ ! -f ${SDL2_MIXER}.tar.gz ]; then wget --continue http://www.libsdl.org/projects/SDL_mixer/release/${SDL2_MIXER}.tar.gz; fi

## Unpack the source code.
rm -Rf ${SDL2_MIXER} && tar -xvzf ${SDL2_MIXER}.tar.gz && cd ${SDL2_MIXER}

## Patch the source code if a patch exists.
if [ -f ../../patches/${SDL2_MIXER}.patch ]; then
  echo "patching ${SDL2_MIXER}..."
  cat ../../patches/${SDL2_MIXER}.patch | patch -p1;
fi

## Create the build directory.
mkdir build-ppu && cd build-ppu

## Configure the build.
CPPFLAGS="-I${PS3DEV}/portlibs/ppu/include" \
CFLAGS="-I${PS3DEV}/portlibs/ppu/include" \
LDFLAGS="-L${PS3DEV}/portlibs/ppu/lib" \
../configure --prefix="$PS3DEV/portlibs/ppu" --host=powerpc64-ps3-elf \
	--disable-sdltest \
	--with-sdl-exec-prefix="$PS3DEV/portlibs/ppu" \
	--disable-shared \
	--disable-music-cmd \
	--disable-music-mod-modplug \
	--disable-music-midi-fluidsynth \
	--disable-music-ogg-shared \
	--disable-music-mp3-smpeg \
	--enable-music-mp3-mad-gpl \
	--enable-music-mod-mikmod

## Compile and install.
${MAKE:-make} -j4 && ${MAKE:-make} install
