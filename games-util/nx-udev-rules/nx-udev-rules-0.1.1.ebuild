# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev

DESCRIPTION="udev rule to allow communication via usb with the Nintendo Switch without root access"
HOMEPAGE="https://github.com/pheki/nx-udev"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"
S="${WORKDIR}"

RESTRICT="test"

RDEPEND="
	virtual/udev
"

src_install() {
#	udev_dorules "${FILESDIR}"/60-nx-rcm.rules
#	udev_dorules "${FILESDIR}"/60-nx.rules
	udev_dorules "${FILESDIR}"/60-nx{-rcm,}.rules
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
