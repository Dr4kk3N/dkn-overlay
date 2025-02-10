# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

ZDIS_COMMIT="7eb89e56d219bbca5ca5cd82c98dce69bd75004b"

MY_PN="CEmu"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}/gui/qt"
SRC_URI="
	https://github.com/CE-Programming/CEmu/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/CE-Programming/zdis/archive/${ZDIS_COMMIT}.tar.gz -> zdis-${ZDIS_COMMIT}.tar.gz
"
KEYWORDS="~amd64"

DESCRIPTION="TI-84 Plus CE emulator"
HOMEPAGE="https://ce-programming.github.io/CEmu/"
LICENSE="GPL-3"
SLOT="0"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/libpng[apng]
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	default
	rm -rf "${S}/../../core/debug/zdis"
	mv "${WORKDIR}/zdis-${ZDIS_COMMIT}" "${S}/../../core/debug/zdis"
}

src_prepare() {
	default
	sed -i "s/-Wextra/-Wextra#/" "${S}/CEmu.pro"
	sed -i "s/CONFIG += c++11 console/CONFIG += c++11 console ltcg/" "${S}/CEmu.pro"
	find tivarslib -type f -exec sed -i "/namespace tivars/i #include <stdexcept>" "${S}/"{} \;
}

src_configure() {
	eqmake5 "CEmu.pro"
}

src_install() {
	eqmake5 "CEmu.pro" PREFIX="${D}/usr"
	default
}
