# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

DESCRIPTION="Pure python3 version of ICMP ping implementation using raw socket."
HOMEPAGE="https://pypi.org/project/ping3/"
SRC_URI="https://github.com/kyan001/ping3/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

#RDEPEND="
#	dev-python/pillow[${PYTHON_USEDEP}]
#	dev-python/six[${PYTHON_USEDEP}]
#"
