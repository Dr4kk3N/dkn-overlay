# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit meson xdg-utils linux-info git-r3

DESCRIPTION="Simple GTK4 App showing a calender widget with configurable events button."
HOMEPAGE="https://github.com/mylinuxforwork/dotfiles-calendar"

EGIT_REPO_URI="https://github.com/mylinuxforwork/dotfiles-calendar.git"

LICENSE="LGPL 2.1"
SLOT="0"

IUSE="X wayland debug"

#REQUIRED_USE="vulkan"

RDEPEND="
	gui-libs/gtk:=
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

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

