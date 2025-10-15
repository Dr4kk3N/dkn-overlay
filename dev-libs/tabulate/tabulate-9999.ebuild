# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/p-ranav/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/p-ranav/${PN}/archive/${PN}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Library for printing aligned, formated, and colorized in Modern C++."
HOMEPAGE="https://github.com/p-ranav/tabulate"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-Dtabulate_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}
