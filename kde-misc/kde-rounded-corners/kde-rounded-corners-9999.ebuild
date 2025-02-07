# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN="6.0"
SLOT="6"
ECM_NONGUI="true"

inherit ecm

#MY_PN="KDE-Rounded-Corners"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/matinlotfali/KDE-Rounded-Corners.git"
else
        SRC_URI="https://github.com/matinlotfali/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
        KEYWORDS="-* ~amd64"
fi

DESCRIPTION="Rounds the corners of your windows in KDE Plasma 6"
HOMEPAGE="https://github.com/matinlotfali/KDE-Rounded-Corners"

LICENSE="GPL-3"

DEPEND="
	>=kde-frameworks/kcmutils-${KFMIN}:${SLOT}=
	>=kde-frameworks/kconfigwidgets-${KFMIN}:${SLOT}=
	>=kde-frameworks/ki18n-${KFMIN}:${SLOT}=
	kde-plasma/kwin:${SLOT}=
	media-libs/libepoxy
	x11-libs/libxcb
"
RDEPEND="${DEPEND}"

#S="${WORKDIR}/${MY_PN}-${PV}"
