# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/geolith-libretro"

inherit libretro-core

DESCRIPTION="Neo Geo AES and MVS highly accurate emulator for libretro"
HOMEPAGE="https://github.com/libretro/geolith-libretro"
KEYWORDS=""

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S="${WORKDIR}/${P}"/libretro
