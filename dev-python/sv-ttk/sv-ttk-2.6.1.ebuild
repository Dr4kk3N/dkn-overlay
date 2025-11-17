# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

DESCRIPTION="Make your Tkinter application look better than ever with just two lines of code!"
HOMEPAGE="https://pypi.org/project/sv-ttk/"
SRC_URI="https://files.pythonhosted.org/packages/4e/ca/9625914e7a7e58ce9f0d8d6a5eb29975bab077ce58a36cf86f863d188cd3/sv_ttk-2.6.1.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

S="${WORKDIR}/sv_ttk-${PV}"
