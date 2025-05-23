# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/FBNeo"

inherit libretro-core

DESCRIPTION="Fork of Final Burn Alpha"
HOMEPAGE="https://github.com/libretro/FBNeo"
KEYWORDS=""

LICENSE="FBA"
SLOT="0"

IUSE="nocrc"

DEPEND="media-libs/libsdl2
		media-libs/sdl-image"
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S="${WORKDIR}/${P}"/src/burner/libretro

src_prepare() {
	if use nocrc; then
		eapply -p1 "${FILESDIR}/ignoreCRC.patch"
		eapply_user
	fi
	default
}

pkg_preinst() {
	if ! has_version "=${CATEGORY}/${PN}-${PVR}"; then
		first_install="1"
	fi
}
