# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/mame"
inherit check-reqs #libretro-core

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libretro/mame.git"
else
	SRC_URI="
		https://github.com/libretro/mame.git/archive/refs/tags/v${PV}.tar.gz
			-> ${P}.tar.gz
	"
	KEYWORDS="-* ~amd64"
fi

DESCRIPTION="MAME (current) for libretro."
HOMEPAGE="https://github.com/libretro/mame"

LICENSE="MAME-GPL"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

CHECKREQS_MEMORY="8G" # Debug build requires more
CHECKREQS_DISK_BUILD="25G" # Debug build requires more

pkg_pretend() {
		einfo "Checking for sufficient disk space to build ${PN} with debugging CFLAGS"
		check-reqs_pkg_pretend
}

pkg_setup() {
		check-reqs_pkg_setup
}

src_configure() {
	myemakeargs=(
	PTR64=1
	)
}

src_compile() {
	emake -f Makefile.libretro
#        #libretro-core_src_compile
}

src_install() {
	insinto "/usr/lib64/libretro"
	doins "/usr/lib64/libretro"
}
