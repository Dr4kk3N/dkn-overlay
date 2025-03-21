# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

DESCRIPTION="Make your Tkinter application look better than ever with just two lines of code!"
HOMEPAGE="https://pypi.org/project/sv-ttk/"
SRC_URI="https://files.pythonhosted.org/packages/40/da/6ad667a4bad4d66ec2d15206c1a1ad81d572679e516aae078824a6f35870/sv_ttk-2.6.0.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"
