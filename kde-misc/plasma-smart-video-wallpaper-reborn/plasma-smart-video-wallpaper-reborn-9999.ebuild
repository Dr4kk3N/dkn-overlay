# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN="6.0"
SLOT="6"
ECM_NONGUI="true"

inherit ecm

MY_PN="plasma-smart-video-wallpaper-reborn"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn.git"
else
        SRC_URI="https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
        KEYWORDS="-* ~amd64"
fi

DESCRIPTION="Plasma 6 Wallpaper plugin to play videos on your Desktop/Lock Screen"
HOMEPAGE="https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn"

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

S="${WORKDIR}/${MY_PN}-${PV}"
