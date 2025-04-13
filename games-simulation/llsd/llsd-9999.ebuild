# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=(python3_{11..13})

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 git-r3

DESCRIPTION="Python LLSD serialization library"
HOMEPAGE="https://github.com/secondlife/python-llsd"
EGIT_REPO_URI="https://github.com/secondlife/python-llsd.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	games-simulation/llbase
	${PYTHON_DEPS}
"
DEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	${RDEPEND}
"

DOCS="README.md"
