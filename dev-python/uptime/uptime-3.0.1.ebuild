# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

DESCRIPTION="A cross-platform uptime for the Python."
HOMEPAGE="https://pypi.org/project/uptime/"
SRC_URI="https://files.pythonhosted.org/packages/ad/53/6c420ddf6949097d6f9406358951c9322505849bea9cb79efe3acc0bb55d/uptime-3.0.1.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

#RDEPEND="
#	dev-python/pillow[${PYTHON_USEDEP}]
#	dev-python/six[${PYTHON_USEDEP}]
#"
