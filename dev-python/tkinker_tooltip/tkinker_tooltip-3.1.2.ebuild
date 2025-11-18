# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

SRC_URI="https://github.com/gnikit/tkinter-tooltip/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="This is a simple yet fully customisable tooltip/pop-up implementation for tkinter widgets."
HOMEPAGE="https://pypi.org/project/tkinter-tooltip/"

LICENSE="LGPL-3"
SLOT="0"

KEYWORDS="~amd64"
RESTRICT="test"
