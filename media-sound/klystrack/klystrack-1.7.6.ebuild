# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kometbomb/klystrack.git"
else
	V_KLYSTRON="10743245fbaf67fc02b432577dc4d47ad5e459da"
	SRC_URI="
		https://github.com/kometbomb/klystrack/archive/${PV}-make-fix.tar.gz -> ${P}.tar.gz
		https://github.com/kometbomb/klystron/archive/${V_KLYSTRON}.tar.gz -> klystron-${V_KLYSTRON}.tar.gz
	"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A really cool fakebit tracker"
HOMEPAGE="http://kometbomb.github.io/klystrack/"
LICENSE="MIT"
SLOT="0"

DEPEND="
	media-libs/libsdl2
	media-libs/sdl2-image
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		default
		mv "${WORKDIR}/${P}-make-fix" "${WORKDIR}/${P}"
		rm -rf "${S}/klystron" || die
		cp -r "${WORKDIR}/klystron-${V_KLYSTRON}" "${S}/klystron" || die
	fi
}

src_prepare() {
	default
	sed -i "s/} menu.t;/};/" "${S}/klystron/src/gui/menu.h" || die
}
