# Copyright 2022 Aisha Tammy <floss@bsd.ac>
# Distributed under the terms of the ISC License

EAPI=8

inherit cmake

DESCRIPTION="small C++ library with graphics."
HOMEPAGE="https://github.com/hyprwm/Hyprgraphics"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/hyprgraphics/"
else
	COMMIT="571f495e88cf9a758698d937d65b9ba35d6eab13"
	SRC_URI="https://github.com/hyprwm/hyprgraphics/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/hyprgraphics-${COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

DEPEND="
	dev-libs/wayland
	media-libs/libglvnd
	media-libs/libjpeg-turbo
	x11-libs/cairo
	x11-libs/pango
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	virtual/pkgconfig
"

src_compile() {
	cmake_src_compile
}
