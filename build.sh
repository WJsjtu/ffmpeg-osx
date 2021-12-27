#!/bin/sh

set -e
set -u

jflag=
jval=2
rebuild=0
download_only=0
uname -mp | grep -qE 'x86|i386|i686' && is_x86=1 || is_x86=0

while getopts 'j:Bd' OPTION
do
  case $OPTION in
  j)
      jflag=1
      jval="$OPTARG"
      ;;
  B)
      rebuild=1
      ;;
  d)
      download_only=1
      ;;
  ?)
      printf "Usage: %s: [-j concurrency_level] (hint: your cores + 20%%) [-B] [-d]\n" $(basename $0) >&2
      exit 2
      ;;
  esac
done
shift $(($OPTIND - 1))

if [ "$jflag" ]
then
  if [ "$jval" ]
  then
    printf "Option -j specified (%d)\n" $jval
  fi
fi

[ "$rebuild" -eq 1 ] && echo "Reconfiguring existing packages..."
[ $is_x86 -ne 1 ] && echo "Not using yasm or nasm on non-x86 platform..."

cd `dirname $0`
ENV_ROOT=`pwd`
. ./env.source

# check operating system
OS=`uname`
platform="unknown"

case $OS in
  'Darwin')
    platform='darwin'
    ;;
  'Linux')
    platform='linux'
    ;;
esac

#if you want a rebuild
#rm -rf "$BUILD_DIR" "$TARGET_DIR"
mkdir -p "$BUILD_DIR" "$TARGET_DIR" "$DOWNLOAD_DIR" "$BIN_DIR" "$INSTALL_DIR"

#download and extract package
download(){
  filename="$1"
  if [ ! -z "$2" ];then
    filename="$2"
  fi
  $ENV_ROOT/download.pl "$DOWNLOAD_DIR" "$1" "$filename" "$3" "$4"
  #disable uncompress
  REPLACE="$rebuild" CACHE_DIR="$DOWNLOAD_DIR" $ENV_ROOT/fetchurl "http://cache/$filename"
}

echo "#### FFmpeg static build ####"

#this is our working directory
cd $BUILD_DIR

[ $is_x86 -eq 1 ] && download \
  "yasm-1.3.0.tar.gz" \
  "" \
  "fc9e586751ff789b34b1f21d572d96af" \
  "http://www.tortall.net/projects/yasm/releases/"

[ $is_x86 -eq 1 ] && download \
  "nasm-2.15.05.tar.bz2" \
  "" \
  "b8985eddf3a6b08fc246c14f5889147c" \
  "https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/"

download \
  "OpenSSL_1_0_2o.tar.gz" \
  "" \
  "5b5c050f83feaa0c784070637fac3af4" \
  "https://github.com/openssl/openssl/archive/"

# updated
download \
  "v1.2.11.tar.gz" \
  "zlib-1.2.11.tar.gz" \
  "0095d2d2d1f3442ce1318336637b695f" \
  "https://github.com/madler/zlib/archive/"

# updated
download \
  "x264-66a5bc1bd1563d8227d5d18440b525a09bcf17ca.tar.gz" \
  "x264-0.164.3075.tar.gz" \
  "nil" \
  "https://code.videolan.org/videolan/x264/-/archive/66a5bc1bd1563d8227d5d18440b525a09bcf17ca"

# updated
download \
  "x265_3.5.tar.gz" \
  "" \
  "nil" \
  "https://bitbucket.org/multicoreware/x265_git/downloads"

download \
  "v0.1.6.tar.gz" \
  "fdk-aac.tar.gz" \
  "223d5f579d29fb0d019a775da4e0e061" \
  "https://github.com/mstorsjo/fdk-aac/archive"

# updated
download \
  "opencore-amr-0.1.5.tar.gz"\
  "" \
  "nil" \
  "http://downloads.sourceforge.net/project/opencore-amr/opencore-amr"

# updated
download \
  "xvidcore-1.3.7.tar.gz"\
  "" \
  "nil" \
  "https://downloads.xvid.com/downloads"

# updated
download \
  "libtheora-1.1.1.tar.gz"\
  "" \
  "nil" \
  "http://downloads.xiph.org/releases/theora"

# libass dependency
# updated
download \
  "harfbuzz-3.0.0.tar.xz" \
  "" \
  "nil" \
  "https://github.com/harfbuzz/harfbuzz/releases/download/3.0.0/"

# updated
download \
  "fribidi-1.0.10.tar.xz" \
  "" \
  "nil" \
  "https://github.com/fribidi/fribidi/releases/download/v1.0.10"

# updated
download \
  "0.15.2.tar.gz" \
  "libass-0.15.2.tar.gz" \
  "nil" \
  "https://github.com/libass/libass/archive/"

# updated
download \
  "lame-3.100.tar.gz" \
  "" \
  "nil" \
  "http://downloads.sourceforge.net/project/lame/lame/3.100"

# updated
download \
  "opus-1.3.1.tar.gz" \
  "" \
  "nil" \
  "https://archive.mozilla.org/pub/opus"

# updated
download \
  "c56ab7d0c6f3fb215d571db3dacc0cc908c1b53c.tar.gz" \
  "libvpx-1.11.0.tar.gz" \
  "nil" \
  "https://github.com/webmproject/libvpx/archive"

# updated
download \
  "rtmpdump-2.3.tgz" \
  "" \
  "eb961f31cd55f0acf5aad1a7b900ef59" \
  "https://rtmpdump.mplayerhq.hu/download/"

# updated
download \
  "soxr-0.1.3-Source.tar.xz" \
  "" \
  "3f16f4dcb35b471682d4321eda6f6c08" \
  "https://sourceforge.net/projects/soxr/files/"

# updated
download \
  "f9166e9b082242b622b5b456ef80cbdbd4042826.tar.gz" \
  "vid.stab-1.1.0.tar.gz" \
  "nil" \
  "https://github.com/georgmartius/vid.stab/archive"

# updated
download \
  "release-3.0.3.tar.gz" \
  "zimg-release-3.0.3.tar.gz" \
  "nil" \
  "https://github.com/sekrit-twc/zimg/archive/"

# updated
download \
  "9f70bf0ad1ba02fa3af87c552647bbc05c94c18e.tar.gz" \
  "openjpeg-2.4.0.tar.gz" \
  "nil" \
  "https://github.com/uclouvain/openjpeg/archive"

# updated
download \
  "cdcf89020e8ed5ab4bbecb1959f86edec8363a20.tar.gz" \
  "libwebp-1.2.1.tar.gz" \
  "nil" \
  "https://github.com/webmproject/libwebp/archive"

# updated
download \
  "v1.3.7.tar.gz" \
  "vorbis-1.3.7.tar.gz" \
  "nil" \
  "https://github.com/xiph/vorbis/archive/"

# updated
download \
  "v1.3.5.tar.gz" \
  "ogg-1.3.5.tar.gz" \
  "nil" \
  "https://github.com/xiph/ogg/archive/"

# updated
download \
  "Speex-1.2.0.tar.gz" \
  "Speex-1.2.0.tar.gz" \
  "4bec86331abef56129f9d1c994823f03" \
  "https://github.com/xiph/speex/archive/"

# updated
download \
  "freetype-2.10.4.tar.gz" \
  "" \
  "nil" \
  "http://download.savannah.gnu.org/releases/freetype"

# updated
download \
  "libtool-2.4.6.tar.gz" \
  "" \
  "nil" \
  "https://ftpmirror.gnu.org/libtool"

# updated
download \
  "autoconf-2.71.tar.xz" \
  "" \
  "nil" \
  "https://ftp.gnu.org/gnu/autoconf/"

# updated
download \
  "pkg-config-0.29.1.tar.gz" \
  "" \
  "nil" \
  "http://pkgconfig.freedesktop.org/releases"

# updated
# 2.13.94 cannot comile https://gitlab.freedesktop.org/fontconfig/fontconfig/-/issues/287
download \
  "fontconfig-889097353ecd7b061ae7cf677e3db56db77a135f.tar.gz" \
  "fontconfig-2.13.94.tar.gz" \
  "nil" \
  "https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/889097353ecd7b061ae7cf677e3db56db77a135f"

# updated
download \
  "gettext-0.21.tar.gz" \
  "" \
  "nil" \
  "https://ftp.gnu.org/pub/gnu/gettext"

# updated
download \
  "libiconv-1.16.tar.gz" \
  "" \
  "nil" \
  "https://ftp.gnu.org/pub/gnu/libiconv/"

# updated
download \
  "xz-5.2.5.tar.gz" \
  "" \
  "nil" \
  "https://tukaani.org/xz/"

# updated
download \
  "SDL2-2.0.18.tar.gz" \
  "" \
  "nil" \
  "https://www.libsdl.org/release/"

# updated
download \
  "expat-2.2.10.tar.gz" \
  "" \
  "nil" \
  "https://github.com/libexpat/libexpat/releases/download/R_2_2_10/"

# updated
download \
  "bzip2-1.0.8.tar.gz" \
  "" \
  "nil" \
  "https://sourceware.org/pub/bzip2/"

# updated
download \
  "v1.7.0.tar.gz" \
  "" \
  "nil" \
  "https://github.com/dyne/frei0r/archive/refs/tags/"

# updated
download \
  "v1.6.35.tar.gz" \
  "" \
  "nil" \
  "https://github.com/glennrp/libpng/archive/refs/tags/"

# updated
download \
  "ffmpeg-4.4.1.tar.gz" \
  "ffmpeg4.4.tar.gz" \
  "493da4b6a946b569fc65775ecde404ea" \
  "https://ffmpeg.org/releases"

[ $download_only -eq 1 ] && exit 0

TARGET_DIR_SED=$(echo $TARGET_DIR | awk '{gsub(/\//, "\\/"); print}')

echo "*** Building pkg-config ***"
cd $BUILD_DIR/pkg-config-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --with-internal-glib
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building libtool ***"
cd $BUILD_DIR/libtool-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --disable-shared --enable-static
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building bzip2 ***"
cd $BUILD_DIR/bzip2-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make install PREFIX=$TARGET_DIR

echo "*** Building expat ***"
cd $BUILD_DIR/expat-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DEXPAT_SHARED_LIBS:BOOL=off
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building autoconf ***"
cd $BUILD_DIR/autoconf-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --disable-shared --enable-static
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

if [ $is_x86 -eq 1 ]; then
    echo "*** Building yasm ***"
    cd $BUILD_DIR/yasm*
    [ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
    [ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --bindir=$BIN_DIR
    export MACOSX_DEPLOYMENT_TARGET=10.15
    export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
    export LDFLAGS='-mmacosx-version-min=10.15'
    export CFLAGS='-mmacosx-version-min=10.15'
    export CXXFLAGS='-mmacosx-version-min=10.15'
    make -j $jval
    make install
fi

if [ $is_x86 -eq 1 ]; then
    echo "*** Building nasm ***"
    cd $BUILD_DIR/nasm*
    [ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
    [ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --bindir=$BIN_DIR
    export MACOSX_DEPLOYMENT_TARGET=10.15
    export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
    export LDFLAGS='-mmacosx-version-min=10.15'
    export CFLAGS='-mmacosx-version-min=10.15'
    export CXXFLAGS='-mmacosx-version-min=10.15'
    make -j $jval
    make install
fi

echo "*** Building zlib ***"
cd $BUILD_DIR/zlib*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
if [ "$platform" = "linux" ]; then
  [ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR
elif [ "$platform" = "darwin" ]; then
  [ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR
fi
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
PATH="$BIN_DIR:$PATH" make -j $jval
make install
if [[ -f $TARGET_DIR/lib/libz.dylib ]]; then
  rm "$TARGET_DIR/lib/libz.dylib"
fi
if [[ -f $TARGET_DIR/lib/libz.1.dylib ]]; then
  rm "$TARGET_DIR/lib/libz.1.dylib"
fi
if [[ -f $TARGET_DIR/lib/libz.1.2.11.dylib ]]; then
  rm "$TARGET_DIR/lib/libz.1.2.11.dylib"
fi

echo "*** Building libpng ***"
cd $BUILD_DIR/libpng-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DPNG_SHARED:bool=off
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building libiconv ***"
cd $BUILD_DIR/libiconv-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --disable-shared --enable-static --enable-extra-encodings
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building OpenSSL ***"
cd $BUILD_DIR/openssl*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
if [ "$platform" = "darwin" ]; then
  PATH="$BIN_DIR:$PATH" ./Configure darwin64-x86_64-cc --prefix=$TARGET_DIR
elif [ "$platform" = "linux" ]; then
  PATH="$BIN_DIR:$PATH" ./config --prefix=$TARGET_DIR
fi
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
PATH="$BIN_DIR:$PATH" make -j $jval
make install

echo "*** Building gettext ***"
cd $BUILD_DIR/gettext-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --disable-shared --enable-static --disable-java
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building xz ***"
cd $BUILD_DIR/xz-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
export LIBTOOLIZE=$TARGET_DIR/bin/libtoolize
export GETTEXTIZE=$TARGET_DIR/bin/gettextize
./autogen.sh --no-po4a
./configure --prefix=$TARGET_DIR --enable-static --disable-shared --disable-docs --disable-examples
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building sdl2 ***"
cd $BUILD_DIR/SDL2-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
$TARGET_DIR/bin/libtoolize
export LIBTOOLIZE=$TARGET_DIR/bin/libtoolize
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared --enable-static
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building x264 ***"
cd $BUILD_DIR/x264*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR --enable-static --disable-shared --disable-opencl --enable-pic
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
PATH="$BIN_DIR:$PATH" make -j $jval
make install

echo "*** Building x265 ***"
cd $BUILD_DIR/x265*
cd build/linux
[ $rebuild -eq 1 ] && find . -mindepth 1 ! -name 'make-Makefiles.bash' -and ! -name 'multilib.sh' -exec rm -r {} +
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DENABLE_SHARED:BOOL=OFF -DSTATIC_LINK_CRT:BOOL=ON -DENABLE_CLI:BOOL=OFF ../../source
if [ "$platform" = "darwin" ]; then
  gsed -i 's/-lgcc_s/-lgcc_eh/g' x265.pc
elif [ "$platform" = "linux" ]; then
  sed -i 's/-lgcc_s/-lgcc_eh/g' x265.pc
fi
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building fdk-aac ***"
cd $BUILD_DIR/fdk-aac*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
$TARGET_DIR/bin/libtoolize
export LIBTOOLIZE=$TARGET_DIR/bin/libtoolize
autoreconf -fiv
[ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --disable-shared
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building opencore-amr ***"
cd $BUILD_DIR/opencore-amr-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --disable-shared --enable-static
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building xvidcore ***"
cd $BUILD_DIR/xvidcore
cd build/generic
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --disable-shared --enable-static
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install
if [[ -f $TARGET_DIR/lib/libxvidcore.4.dylib ]]; then
  rm "$TARGET_DIR/lib/libxvidcore.4.dylib"
fi

echo "*** Building harfbuzz ***"
cd $BUILD_DIR/harfbuzz-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --disable-shared --enable-static
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building fribidi ***"
cd $BUILD_DIR/fribidi-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --disable-shared --enable-static --disable-docs
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building freetype ***"
cd $BUILD_DIR/freetype-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --disable-shared --enable-static --without-harfbuzz
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building fontconfig ***"
cd $BUILD_DIR/fontconfig-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
$TARGET_DIR/bin/libtoolize
export LIBTOOLIZE=$TARGET_DIR/bin/libtoolize
export GETTEXTIZE=$TARGET_DIR/bin/gettextize
./autogen.sh --prefix=$TARGET_DIR --disable-shared --enable-static
# ./configure --prefix=$TARGET_DIR --disable-shared --enable-static
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building libass ***"
cd $BUILD_DIR/libass-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
$TARGET_DIR/bin/libtoolize
export LIBTOOLIZE=$TARGET_DIR/bin/libtoolize
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building mp3lame ***"
cd $BUILD_DIR/lame*
# The lame build script does not recognize aarch64, so need to set it manually
uname -a | grep -q 'aarch64' && lame_build_target="--build=arm-linux" || lame_build_target=''
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --enable-nasm --disable-shared $lame_build_target
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make
make install

echo "*** Building opus ***"
cd $BUILD_DIR/opus*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --disable-shared
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make
make install

echo "*** Building libvpx ***"
cd $BUILD_DIR/libvpx*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR --disable-examples --disable-unit-tests --enable-pic --target=x86_64-darwin19-gcc
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
PATH="$BIN_DIR:$PATH" make -j $jval
make install

echo "*** Building librtmp ***"
cd $BUILD_DIR/rtmpdump-*
cd librtmp
[ $rebuild -eq 1 ] && make distclean || true

# there's no configure, we have to edit Makefile directly
if [ "$platform" = "linux" ]; then
  sed -i "/INC=.*/d" ./Makefile # Remove INC if present from previous run.
  sed -i "s/prefix=.*/prefix=${TARGET_DIR_SED}\nINC=-I\$(prefix)\/include/" ./Makefile
  sed -i "s/SHARED=.*/SHARED=no/" ./Makefile
elif [ "$platform" = "darwin" ]; then
  gsed -i "s/prefix=.*/prefix=${TARGET_DIR_SED}\nINC=-I\$(prefix)\/include/" ./Makefile
fi
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make install_base

echo "*** Building libsoxr ***"
cd $BUILD_DIR/soxr-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off -DWITH_OPENMP:bool=off -DBUILD_TESTS:bool=off
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building libvidstab ***"
cd $BUILD_DIR/vid.stab-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
if [ "$platform" = "linux" ]; then
  sed -i "s/vidstab SHARED/vidstab STATIC/" ./CMakeLists.txt
elif [ "$platform" = "darwin" ]; then
  gsed -i "s/vidstab SHARED/vidstab STATIC/" ./CMakeLists.txt
fi
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS=OFF
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building openjpeg ***"
cd $BUILD_DIR/openjpeg-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building zimg ***"
cd $BUILD_DIR/zimg-release-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
$TARGET_DIR/bin/libtoolize
export LIBTOOLIZE=$TARGET_DIR/bin/libtoolize
./autogen.sh
./configure --enable-static  --prefix=$TARGET_DIR --disable-shared
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building libwebp ***"
cd $BUILD_DIR/libwebp*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
$TARGET_DIR/bin/libtoolize
export LIBTOOLIZE=$TARGET_DIR/bin/libtoolize
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building libogg ***"
cd $BUILD_DIR/ogg*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
$TARGET_DIR/bin/libtoolize
export LIBTOOLIZE=$TARGET_DIR/bin/libtoolize
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building libvorbis ***"
cd $BUILD_DIR/vorbis*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
$TARGET_DIR/bin/libtoolize
export LIBTOOLIZE=$TARGET_DIR/bin/libtoolize
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building theora ***"
cd $BUILD_DIR/libtheora-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
if [ "$platform" = "linux" ]; then
  sed "s/-fforce-addr//g" configure > configure.patched
elif [ "$platform" = "darwin" ]; then
  gsed "s/-fforce-addr//g" configure > configure.patched
fi
chmod +x configure.patched
mv configure.patched configure
export LIBTOOLIZE=$TARGET_DIR/bin/libtoolize
./configure --prefix=$TARGET_DIR --with-ogg-libraries=$TARGET_DIR/lib --with-ogg-includes=$TARGET_DIR/include/ --with-vorbis-libraries=$TARGET_DIR/lib --with-vorbis-includes=$TARGET_DIR/include/ --enable-static --disable-shared --disable-oggtest --disable-vorbistest --disable-examples --disable-asm
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building libspeex ***"
cd $BUILD_DIR/speex*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
$TARGET_DIR/bin/libtoolize
export LIBTOOLIZE=$TARGET_DIR/bin/libtoolize
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install

echo "*** Building frei0r ***"
cd $BUILD_DIR/frei0r*
PATH="$BIN_DIR:$PATH" cmake -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DWITHOUT_OPENCV=ON -DWITHOUT_GAVL=ON -DBUILD_SHARED_LIBS=OFF
export MACOSX_DEPLOYMENT_TARGET=10.15
export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET=10.15
export LDFLAGS='-mmacosx-version-min=10.15'
export CFLAGS='-mmacosx-version-min=10.15'
export CXXFLAGS='-mmacosx-version-min=10.15'
make -j $jval
make install
for file in $TARGET_DIR/lib/frei0r-1/*.so ; do
  cp $file "${file%.*}.dylib"
done

# FFMpeg
echo "*** Building FFmpeg ***"
cd $BUILD_DIR/ffmpeg*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true

if [ "$platform" = "linux" ]; then
  [ ! -f config.status ] && PATH="$BIN_DIR:$PATH" \
  PKG_CONFIG_PATH="$TARGET_DIR/lib/pkgconfig" ./configure \
    --prefix="$INSTALL_DIR" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$TARGET_DIR/include" \
    --extra-ldflags="-L$TARGET_DIR/lib" \
    --extra-libs="-lpthread -lm -lz" \
    --extra-ldexeflags="-static" \
    --bindir="$INSTALL_DIR/bin" \
    --enable-pic \
    --enable-ffplay \
    --enable-fontconfig \
    --enable-frei0r \
    --enable-gpl \
    --enable-version3 \
    --enable-libass \
    --enable-libfribidi \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopencore-amrnb \
    --enable-libopencore-amrwb \
    --enable-libopenjpeg \
    --enable-libopus \
    --enable-librtmp \
    --enable-libsoxr \
    --enable-libspeex \
    --enable-libtheora \
    --enable-libvidstab \
    --enable-libvo-amrwbenc \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libxvid \
    --enable-libzimg \
    --enable-nonfree \
    --enable-openssl \
    --enable-shared \
    --enable-static
elif [ "$platform" = "darwin" ]; then
  [ ! -f config.status ] && PATH="$BIN_DIR:$PATH" \
  PKG_CONFIG_PATH="${TARGET_DIR}/lib/pkgconfig" ./configure \
    --cc=/usr/bin/clang \
    --prefix="$INSTALL_DIR" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$TARGET_DIR/include -mmacosx-version-min=10.15" \
    --extra-ldflags="-L$TARGET_DIR/lib -mmacosx-version-min=10.15" \
    --extra-ldexeflags="-Bstatic" \
    --bindir="$INSTALL_DIR/bin" \
    --enable-pic \
    --enable-ffplay \
    --enable-fontconfig \
    --enable-frei0r \
    --enable-gpl \
    --enable-version3 \
    --enable-libass \
    --enable-libfribidi \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopencore-amrnb \
    --enable-libopencore-amrwb \
    --enable-libopenjpeg \
    --enable-libopus \
    --enable-librtmp \
    --enable-libsoxr \
    --enable-libspeex \
    --enable-libvidstab \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libxvid \
    --enable-libzimg \
    --enable-nonfree \
    --enable-openssl \
    --enable-shared \
    --enable-static
fi

PATH="$BIN_DIR:$PATH" make -j $jval
make install

make distclean
hash -r

if [ "$platform" = "darwin" ]; then
  mkdir -p $ENV_ROOT/lib
  dylibs=("libavcodec.58.dylib" "libavdevice.58.dylib" "libavfilter.7.dylib" "libavformat.58.dylib" "libavutil.56.dylib" "libpostproc.55.dylib" "libswresample.3.dylib" "libswscale.5.dylib")
  for dylib in ${dylibs[@]}; do
    for _dylib in ${dylibs[@]}; do
      if [ "$dylib" = "$_dylib" ]; then
        install_name_tool -id @loader_path/$_dylib $INSTALL_DIR/lib/$dylib
      else
        install_name_tool -change $INSTALL_DIR/lib/$_dylib @loader_path/$_dylib $INSTALL_DIR/lib/$dylib
      fi
    done
  done
fi
