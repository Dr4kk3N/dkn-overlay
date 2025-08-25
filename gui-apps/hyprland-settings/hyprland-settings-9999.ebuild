# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit meson linux-info git-r3

DESCRIPTION="Frontend for the CLI hyprctl."
HOMEPAGE="https://github.com/mylinuxforwork/hyprland-settings"

EGIT_REPO_URI="https://github.com/mylinuxforwork/hyprland-settings.git"

LICENSE="LGPL 2.1"
SLOT="0"

IUSE="wayland debug"

RDEPEND="
	wayland? ( >=dev-libs/wayland-1.18.0
		   >=dev-libs/wayland-protocols-1.30
		   dev-util/wayland-scanner
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
