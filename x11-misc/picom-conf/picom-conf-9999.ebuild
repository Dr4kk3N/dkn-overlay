# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..13} )
inherit git-r3 cmake python-any-r1 virtualx xdg

DESCRIPTION="A configuration tool for X composite manager picom."
HOMEPAGE="https://github.com/qtilities/picom-conf"
EGIT_REPO_URI="https://github.com/qtilities/picom-conf.git"

LICENSE="MPL-2.0 MIT"
SLOT="0"
IUSE="dbus qt5 +qt6"

REQUIRED_USE="dbus"
RESTRICT="test"

RDEPEND="dev-libs/libconfig:=
	dev-libs/libev
	dev-libs/uthash
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/pixman
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-renderutil
	sys-apps/dbus
	qt5? (
                >=dev-qt/qtcore-5.15:5
                >=dev-qt/qtgui-5.15:5
                >=dev-qt/qtmultimedia-5.15:5
                >=dev-qt/qtwidgets-5.15:5
        )
        qt6? (
                >=dev-qt/qtbase-6.6.0:6[gui,widgets,dbus]
        )

	dev-build/qtilitools"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-misc/picom"

#DOCS=( README.md picom.sample.conf )

src_configure() {
        local -a mycmakeargs=(
                -DPROJECT_QT_VERSION=$(usex qt6 6 5)
        )
        cmake_src_configure
}

#src_configure() {
#	local emesonargs=(
#		$(meson_use dbus)
#		$(meson_use doc with_docs)
#		$(meson_use opengl)
#		$(meson_use pcre regex)
#	)
#
#	cmake_src_configure
#}
