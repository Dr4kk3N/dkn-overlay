# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517="setuptools"
inherit distutils-r1 # pypi

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/Rockhopper-Technologies/prefixed.git"
else
        SRC_URI="https://github.com/Rockhopper-Technologies/prefixed/archive/${PV}.tar.gz"
        KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="An alternative implementation of the built-in float which supports formatted output with SI (decimal) and IEC (binary) prefixes."
HOMEPAGE="https://github.com/Rockhopper-Technologies/prefixed https://pypi.org/project/prefixed/"

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DOCS="README.md"

RDEPEND=">=dev-python/blessed-1.22.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
