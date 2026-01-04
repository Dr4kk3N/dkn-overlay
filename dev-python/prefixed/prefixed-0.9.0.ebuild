# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517="setuptools"
inherit distutils-r1 pypi

DESCRIPTION="An alternative implementation of the built-in float which supports formatted output with SI (decimal) and IEC (binary) prefixes."
HOMEPAGE="https://github.com/Rockhopper-Technologies/prefixed https://pypi.org/project/prefixed/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

#DOCS="README.md"

RDEPEND=">=dev-python/pycryptodome-3.22.0[${PYTHON_USEDEP}]
	 >=dev-python/zstandard-0.23.0-r3[${PYTHON_USEDEP}]
	 >=dev-python/enlighten-1.14.1[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
