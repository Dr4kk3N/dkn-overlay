# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson git-r3

DESCRIPTION="vkmark is an extensible Vulkan benchmarking suite with targeted, configurable scenes."
HOMEPAGE="https://github.com/vkmark/vkmark"

EGIT_REPO_URI="https://github.com/vkmark/vkmark.git"

LICENSE="LGPL 2.1"
SLOT="0"
KEYWORDS="amd64 arm"
IUSE="X wayland drm debug"

COMMON_DEPEND="
	media-libs/glm
	media-libs/assimp
	X? (
		x11-libs/libxcb
	 )
	wayland? (
		dev-libs/wayland-protocols
	)
	drm? (
		x11-libs/libdrm
		media-libs/mesa[gbm(+)]
	)"

RDEPEND="
	${COMMON_DEPEND}
	media-libs/vulkan-loader

"
DEPEND="
	${COMMON_DEPEND}
	dev-util/vulkan-headers"

BDEPEND="
	wayland? (
		dev-util/wayland-scanner
	)
"

multilib_src_configure() {
	local emesonargs=()
	emesonargs+=(
		--buildtype $(usex debug debug plain)
		-Db_ndebug=$(usex debug false true)
		-Dkms=$(usex drm false true)
		-Dwayland=$(usex wayland auto true false)
	)
	meson_src_configure
}
