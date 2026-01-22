# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit meson xdg-utils linux-info git-r3

DESCRIPTION="The sidebar for the ML4W Dotfiles for Hyprland. Gives quick access to important settings and features."
HOMEPAGE="https://github.com/mylinuxforwork/dotfiles-sidebar"

EGIT_REPO_URI="https://github.com/mylinuxforwork/dotfiles-sidebar.git"

LICENSE="LGPL 2.1"
SLOT="0"

IUSE="X wayland debug"

RDEPEND="
	wayland? ( >=dev-libs/wayland-1.18.0
		   >=dev-libs/wayland-protocols-1.30
		   dev-util/wayland-scanner
	)
"

multilib_src_prepare() {
        rm -rf "${WORKDIR}/data/icons/hicolor/scalable/actions/settings-symbolic.svg" || die
}

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

