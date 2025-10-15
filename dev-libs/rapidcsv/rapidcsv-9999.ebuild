# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/d99kris/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/d99kris/${PN}/archive/${PN}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="An easy-to-use C++ CSV parser library."
HOMEPAGE="https://github.com/d99kris/rapidcsv"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DRAPIDCSV_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}
