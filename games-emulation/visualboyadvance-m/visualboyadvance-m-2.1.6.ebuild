# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="The continuing development of the legendary VBA gameboy advance emulator."
HOMEPAGE="https://vba-m.com/"
COMMIT="a42e166e94753ca0a8e290225ec7127a623374dd"
SRC_URI="https://github.com/visualboyadvance-m/visualboyadvance-m/archive/refs/tags/v${PV}.tar.gz -> v${PV}.tar.gz"
LICENSE="CC-BY-SA-3.0 GPL-2.0"
SLOT="0"
S="${WORKDIR}/"
KEYWORDS="~amd64"
IUSE="+openal +ffmpeg"
RDEPEND=">=media-libs/openal-1.22.2-r1
		>=media-video/ffmpeg-4.4.3"
DEPEND="${RDEPEND}
		>=sys-devel/gcc-12.2.1_p20221008
		>=sys-devel/make-4.3
		>=dev-util/cmake-3.24.3
		>=dev-util/ccache-4.6.3
		>=sys-devel/binutils-2.38-r2
		>=media-libs/libsdl2-2.24.0-r2
		>=media-libs/libsfml-2.5.1-r1
		>=x11-libs/wxGTK-3.0.5.1
		>=sys-libs/zlib-1.2.13-r1
		>=dev-util/pkgconf-1.8.0-r1
		>=dev-lang/nasm-2.15.05
		>=dev-util/ninja-1.11.1-r2"

src_compile() {
	BUILDDIR="/var/tmp/portage/games-emulation/visualboyadvance-m-9999/work/visualboyadvance-m-a42e166e94753ca0a8e290225ec7127a623374dd"
	cmake $BUILDDIR -G Ninja || die
	ninja || die
}

src_install() {
	PKGNAME="visualboyadvance-m"
	dobin ${WORKDIR}/$PKGNAME
}
