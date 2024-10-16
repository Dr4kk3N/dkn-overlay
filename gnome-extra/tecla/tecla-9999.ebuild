# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson xdg #gnome.org

DESCRIPTION="Tecla is a keyboard layout viewer"
HOMEPAGE="https://gitlab.gnome.org/GNOME/tecla"

#if [[ ${PV} == 9999 ]]; then
        EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/tecla.git"
        inherit git-r3
#else
#       SRC_URI="
#               https://download.gnome.org/sources/${MY_P}.tar.xz
#       "
#       KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
#fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	gui-libs/gtk:4[introspection]
	>=gui-libs/libadwaita-1.4_alpha:1
	x11-libs/libxkbcommon
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/glib
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
