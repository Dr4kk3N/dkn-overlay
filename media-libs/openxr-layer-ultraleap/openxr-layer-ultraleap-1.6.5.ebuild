# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Ultraleap OpenXR Hand Tracking API Layer. Enables Ultraleap hand-tracking on an existing OpenXR runtime"
HOMEPAGE="https://docs.ultraleap.com/linux/"

pkgname=openxr-layer-ultraleap
pkgver=1.6.5
commit=2486adf9
ci=1130164
SRC_URI="https://repo.ultraleap.com/apt/pool/main/o/${pkgname}/${pkgname}_${pkgver}%2b${commit}.CI${ci}_amd64.deb"

S="${WORKDIR}"

LICENSE="PROPRIETARY"
SLOT="0"
KEYWORDS="~amd64"
#IUSE="gnome X"

#RESTRICT="strip"

#RDEPEND=""

#DEPEND="${RDEPEND}"

#BDEPEND="virtual/pkgconfig"

src_unpack() {
	unpack_deb "${A}"
}

#src_configure() {
#}

#src_compile() {
#}

src_install() {
	insinto /
	doins -r *
	fperms +x /usr/lib/${PN}/libUltraleapHandTracking.so.1.6.5.0

	insinto /etc/ld.so.conf.d
	doins ${WORKDIR}/../files/${PN}.conf
}
