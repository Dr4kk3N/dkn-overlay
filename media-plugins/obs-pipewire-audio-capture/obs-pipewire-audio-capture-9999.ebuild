# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER="dimtpap"

DESCRIPTION="PipeWire application audio capture plugin for OBS Studio"
LICENSE="GPL-2"
SLOT="0"

# This ebuild revision is for 38176824e5 or later
inherit github-pkg cmake

if [[ ${PV} != "9999" ]]; then
	KEYWORDS="~amd64 ~x86"
	MY_PN="linux-pipewire-audio"
	SRC_URI="${GITHUB_HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

DEPEND="
	>=media-video/obs-studio-28.0
	media-video/wireplumber"
RDEPEND="${DEPEND}"
