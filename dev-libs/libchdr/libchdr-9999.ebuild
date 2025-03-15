# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

EGIT_REPO_URI="https://github.com/PCSX2/pcsx2.git"

DESCRIPTION="Standalone library for reading MAME's CHDv1-v5 formats"
HOMEPAGE="https://github.com/rtissera/libchdr/"
#S="${WORKDIR}/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/zlib:="
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_SYSTEM_ZLIB=yes
	)

	cmake_src_configure
}
