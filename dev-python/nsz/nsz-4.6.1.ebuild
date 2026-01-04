# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517="setuptools"
inherit distutils-r1 pypi

DESCRIPTION="A compression/decompresson script (with optional GUI) that allows user to compress/decompress Nintendo Switch dumps loselessly, thanks to zstd compression algorithm."
HOMEPAGE="https://github.com/nicoboss/nsz https://pypi.org/project/nsz/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"
IUSE="-gui test"
RESTRICT="!test? ( test )"

DOCS="README.md"

RDEPEND=">=dev-python/pycryptodome-3.22.0[${PYTHON_USEDEP}]
	 >=dev-python/zstandard-0.23.0-r3[${PYTHON_USEDEP}]"


distutils_enable_tests pytest
