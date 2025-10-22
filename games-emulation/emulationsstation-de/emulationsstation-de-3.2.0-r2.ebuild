# @Author : XaetaCore
# Distributed under the terms of the GNU General Public License v2
EAPI=8
inherit cmake

DESCRIPTION="ES-DE is a frontend for browsing and launching games from your multi-platform collection."
HOMEPAGE="https://gitlab.com/es-de/emulationstation-de"
SRC_URI="https://gitlab.com/es-de/emulationstation-de/-/archive/v3.2.0/emulationstation-de-v3.2.0.tar.gz"
S="${WORKDIR}/emulationstation-de-v3.2.0"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="-auto_updater -deinit -debug -profiling -asan -video_hw"
DEPEND="
    dev-build/cmake
    llvm-core/clang
    dev-vcs/git
    sys-devel/gettext
    media-libs/harfbuzz
    dev-libs/icu
    media-libs/libsdl2
    media-video/ffmpeg:=
    media-libs/freeimage
    media-libs/freetype
    dev-libs/libgit2
    net-misc/curl
    dev-libs/pugixml
    media-libs/alsa-lib
    net-wireless/bluez
    media-libs/mesa
    app-text/poppler[cxx]
"
RDEPEND="${DEPEND}"

src_prepare() {
  cmake_src_prepare
}

src_configure() {
  local mycmakeargs=()
  if ! use auto_updater; then
      mycmakeargs+=( -DAPPLICATION_UPDATER=off )
  elif use deinit; then
    mycmakeargs+=( -DDEINIT_ON_LAUNCH=on )
  elif use debug; then
    mycmakeargs+=( -DCMAKE_BUILD_TYPE=Debug )
  elif use profiling; then
    mycmakeargs+=( -DCMAKE_BUILD_TYPE=Profiling )
  elif use asan; then
    mycmakeargs+=( -DASAN=on )
  elif use video_hw; then
    mycmakeargs+=( -DVIDEO_HW_DECODING=on )
  fi
  
  cmake_src_configure
}