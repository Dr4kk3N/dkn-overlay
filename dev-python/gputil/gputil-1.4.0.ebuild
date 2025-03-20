# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

DESCRIPTION="Python module for getting the GPU status from NVIDA GPUs using nvidia-smi."
HOMEPAGE="https://pypi.org/project/GPUtil/"
SRC_URI="https://github.com/anderskm/gputil/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

#RDEPEND="
#	dev-python/pillow[${PYTHON_USEDEP}]
#	dev-python/six[${PYTHON_USEDEP}]
#"
