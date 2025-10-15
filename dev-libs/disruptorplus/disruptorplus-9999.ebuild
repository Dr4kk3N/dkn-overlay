# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C++11 header-only implementation of the 'disruptor' data structure."
HOMEPAGE="https://github.com/xenia-project/disruptorplus"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/xenia-project/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/xenia-project/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"/${PN}-${COMMIT}
fi

LICENSE="LGPL-2.1"
SLOT="0"

src_compile() {
	true
}

src_install() {
	insinto /usr/include
	doins -r "${S}"/include/*
}
