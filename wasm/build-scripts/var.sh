#!/bin/bash
#
# Common variables for all scripts

set -euo pipefail

# Include llvm binaries
export PATH=$PATH:/emsdk/upstream/bin

# Flags for code optimization, focus on speed instead
# of size
OPTIM_FLAGS=(
  -O3
)

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Use closure complier only in linux environment
  OPTIM_FLAGS=(
    "${OPTIM_FLAGS[@]}"
    --closure 1
  )
fi

# Convert array to string
OPTIM_FLAGS="${OPTIM_FLAGS[@]}"

# Directory to install headers and libraries
BUILD_DIR=$PWD/build

# Toolchain file path for cmake
TOOLCHAIN_FILE=/emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake

CFLAGS="-s USE_PTHREADS=1 -I$BUILD_DIR/include $OPTIM_FLAGS"
LDFLAGS="$CFLAGS -L$BUILD_DIR/lib"
FFMPEG_CONFIG_FLAGS_BASE=(
  --target-os=none        # use none to prevent any os specific configurations
  --arch=x86_32           # use x86_32 to achieve minimal architectural optimization
  --enable-cross-compile  # enable cross compile
  --disable-x86asm        # disable x86 asm
  --disable-inline-asm    # disable inline asm
  --disable-stripping     # disable stripping
  --disable-programs      # disable programs build (incl. ffplay, ffprobe & ffmpeg)
  --disable-doc           # disable doc
  --enable-gpl            # required by x264
  --enable-libx264        # enable x264
  --enable-libvpx         # enable libvpx / webm
  --disable-debug         # disable debug info, required by closure
  --disable-runtime-cpudetect   # disable runtime cpu detect
  --disable-autodetect    # disable external libraries auto detect
  --extra-cflags="$CFLAGS"
  --extra-cxxflags="$CFLAGS"
  --extra-ldflags="$LDFLAGS"
  --nm="llvm-nm"
  --ar=emar
  --as=llvm-as
  --ranlib=emranlib
  --cc=emcc
  --cxx=em++
  --objcc=emcc
  --dep-cc=emcc
)

echo "OPTIM_FLAGS=$OPTIM_FLAGS"
echo "BUILD_DIR=$BUILD_DIR"
