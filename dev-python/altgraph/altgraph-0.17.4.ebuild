# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/ronaldoussoren/altgraph.git"
else
        SRC_URI="
                https://github.com/ronaldoussoren/altgraph/archive/refs/tags/v${PV}.tar.gz
                        -> ${P}.tar.gz
        "
        KEYWORDS="amd64 ~arm64 x86"
fi

DESCRIPTION="A constructing graphs, BFS and DFS traversals, etc"
HOMEPAGE="https://altgraph.readthedocs.io/en/latest/"

LICENSE="MIT"
SLOT="0"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

distutils_enable_tests unittest
