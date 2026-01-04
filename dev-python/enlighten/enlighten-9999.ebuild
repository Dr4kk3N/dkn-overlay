# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517="setuptools"
inherit distutils-r1 # pypi

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/Rockhopper-Technologies/enlighten.git"
else
        SRC_URI="https://github.com/Rockhopper-Technologies/enlighten/archive/${PV}.tar.gz"
        KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="A console progress bar library for Python."
HOMEPAGE="https://github.com/Rockhopper-Technologies/enlighten https://pypi.org/project/enlighten/"

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DOCS="README.md"

RDEPEND=">=dev-python/blessed-1.22.0[${PYTHON_USEDEP}]
	 >=dev-python/prefixed-0.9.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
