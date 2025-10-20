# Copyright 2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

DESCRIPTION="Xorg drivers for xrdp"
HOMEPAGE="http://www.xrdp.org/"
SRC_URI="https://github.com/neutrinolabs/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
RESTRICT="mirror"

RDEPEND="
	>=net-misc/xrdp-0.9.14:0=
	x11-base/xorg-server:0=
"
DEPEND=${RDEPEND}
BDEPEND="
	dev-lang/nasm
	virtual/pkgconfig
"

