# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit meson linux-info flag-o-matic git-r3

replace-flags -O2 -O3

DESCRIPTION="vkmark is an extensible Vulkan benchmarking suite with targeted, configurable scenes."
HOMEPAGE="https://github.com/vkmark/vkmark"

EGIT_REPO_URI="https://github.com/vkmark/vkmark.git"

LICENSE="LGPL 2.1"
SLOT="0"

IUSE="X vulkan wayland debug"

REQUIRED_USE="vulkan"

RDEPEND="
	>=media-libs/assimp-5.2.5-r1
	>=dev-libs/expat-2.1.0-r3
	>=sys-libs/zlib-1.2.8
	>=media-libs/glm-1.0.1
	wayland? ( >=dev-libs/wayland-1.18.0
		   >=dev-libs/wayland-protocols-1.30
		   dev-util/wayland-scanner
	)
	X? (
		>=x11-libs/libX11-1.6.2
		>=x11-libs/libxshmfence-1.1
		>=x11-libs/libXext-1.3.2
		>=x11-libs/libXxf86vm-1.1.3
		>=x11-libs/libxcb-1.13
		>=x11-libs/xcb-util-wm-0.4.2
	)
	vulkan? (
		dev-util/glslang
	)
"

multilib_src_configure() {
	local emesonargs=()
	emesonargs+=(
		--buildtype $(usex debug debug plain)
		-Db_ndebug=$(usex debug false true)
		-Dwayland=$(usex wayland auto true false)
	)
	meson_src_configure
}
