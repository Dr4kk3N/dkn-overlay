# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson git-r3

DESCRIPTION="How to drive bare metal graphics without a compositor like X11, wayland or similar, using DRM/KMS (kernel mode setting), GBM (graphics buffer manager) and EGL for rendering content using OpenGL or OpenGL ES"
HOMEPAGE="https://gitlab.freedesktop.org/mesa/kmscube"

EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/kmscube.git"

LICENSE="LGPL 2.1"
SLOT="0"
KEYWORDS="amd64 arm"
IUSE="gstreamer debug"

COMMON_DEPEND="
	media-libs/glm
	"

RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"

BDEPEND=""

multilib_src_configure() {
	local emesonargs=()
	emesonargs+=(
		--buildtype $(usex debug debug plain)
		-Db_ndebug=$(usex debug false true)
		-Dkms=$(usex drm false true)
	)
	meson_src_configure
}
