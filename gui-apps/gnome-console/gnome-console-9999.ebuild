# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg gnome2-utils #gnome.org

DESCRIPTION="A simple user-friendly terminal emulator for the GNOME desktop"
HOMEPAGE="https://apps.gnome.org/Console/ https://gitlab.gnome.org/GNOME/console"

#if [[ ${PV} == 9999 ]]; then
        EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/gnome-console.git"
        inherit git-r3
#else
#       SRC_URI="
#               https://download.gnome.org/sources/${MY_P}.tar.xz
#       "
#	KEYWORDS="~amd64 ~arm64 ~loong"
#fi

LICENSE="LGPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.76:2
	=gui-libs/gtk-4.16.0:4
	>=gui-libs/libadwaita-1.4_alpha:1
	>=gui-libs/vte-0.75.1:2.91-gtk4
	gnome-base/libgtop:2=
	>=dev-libs/libpcre2-10.32:0=
	gnome-base/gsettings-desktop-schemas

	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-util/desktop-file-utils
		dev-libs/appstream-glib
	)
"

src_configure() {
	local emesonargs=(
		-Ddevel=false
		$(meson_use test tests)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
