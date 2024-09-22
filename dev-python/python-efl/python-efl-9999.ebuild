# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{5..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Python bindings for EFL"
HOMEPAGE="https://www.enlightenment.org/"
EGIT_REPO_URI="https://git.enlightenment.org/enlightenment/${PN}.git"

LICENSE="|| ( GPL-3 LGPL-3 )"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~riscv ~x86"
SLOT="0"

IUSE="doc test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/cython-0.21
	dev-python/dbus-python[${PYTHON_USEDEP}]
	>=dev-libs/efl-1.22.99
	sys-apps/dbus"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		media-gfx/graphviz
	)"

S="${WORKDIR}/${P/_/-}"

PATCHES=(
	"${FILESDIR}/python-efl-1.25-clang-crosscompile.patch"
	"${FILESDIR}/python-efl-1.26.1-distutils-dep_util.patch"
)

src_prepare() {
	default
}

python_compile_all() {
	default

	if use doc ; then
		esetup.py build_doc --build-dir "${S}"/build/doc/
	fi
}

python_test() {
	cd tests/ || die
	${EPYTHON} 00_run_all_tests.py --verbose || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( ./build/doc/html/. )
	distutils-r1_python_install_all
}
