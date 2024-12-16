# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit meson linux-info git-r3

DESCRIPTION="A collection of libraries which implement some of the freedesktop.org specifications.A collection of libraries which implement some of the freedesktop.org specifications."
HOMEPAGE="https://github.com/jlindgren90/libsfdo"

EGIT_REPO_URI="https://github.com/jlindgren90/libsfdo.git"

LICENSE="LGPL 2.1"
SLOT="0"

IUSE=""

RDEPEND=""
