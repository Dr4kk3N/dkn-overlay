# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mathoudebine/turing-smart-screen-python.git"
else
	SRC_URI="
		https://github.com/mathoudebine/turing-smart-screen-python/archive/refs/tags/${PV}.tar.gz
			-> ${P}.tar.gz
	"
	KEYWORDS="-* ~amd64"
fi

DESCRIPTION="A Python system monitor program and an abstraction library for small IPS USB-C (UART) displays."
HOMEPAGE="https://github.com/mathoudebine/turing-smart-screen-python"

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/pyserial-3.5-r2[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.2[${PYTHON_USEDEP}]
	>=dev-python/psutil-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/pystray-0.19.5[${PYTHON_USEDEP}]
	>=dev-python/babel-2.17.0[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.18.10[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.3[${PYTHON_USEDEP}]
	>=dev-python/pyinstaller-6.12.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-2.2.3[${PYTHON_USEDEP}]
	>=dev-python/pyamdgpuinfo-2.1.6[${PYTHON_USEDEP}]
	>=dev-python/pmw-2.1.1[${PYTHON_USEDEP}]"

S="${WORKDIR}/turing-smart-screen-python-${PV}"

src_install() {
        insinto /opt/turing-smart-screen-python/
        doins -r "${BUILD_DIR}"/.
#        insopts -m0755

#        use !test || rm "${ED}"/opt/${PN}/*_test || die
}

distutils_enable_tests pytest
