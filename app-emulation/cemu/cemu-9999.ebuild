# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 qmake-utils

EGIT_REPO_URI="https://github.com/CE-Programming/CEmu.git"
S="${S}/gui/qt"

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

src_prepare() {
	default
	sed -i "s/-Wextra/-Wextra#/" "${S}/CEmu.pro"
}

src_configure() {
	eqmake5 "CEmu.pro"
}

src_install() {
	eqmake5 "CEmu.pro" PREFIX="${D}/usr"
	default
}
