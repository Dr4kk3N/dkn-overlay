# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils

DESCRIPTION="Library and layout configuration for the Desktop Menu fd.o specification"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-menus"

if [[ ${PV} == 9999 ]]; then
        EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/gnome-menus.git"
        inherit git-r3
else
       SRC_URI="
               https://download.gnome.org/sources/${MY_P}.tar.xz
       "
	KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

LICENSE="GPL-2+ LGPL-2+"
SLOT="4"
IUSE="+introspection test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.29.15:2
	introspection? ( =dev-libs/gobject-introspection-1.81.4:= )
"
DEPEND="${RDEPEND}
	test? ( dev-libs/gjs )
"
BDEPEND="
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog HACKING NEWS README )

src_configure() {
	# Do NOT compile with --disable-debug/--enable-debug=no
	# It disables api usage checks
	gnome2_src_configure $(use_enable introspection)
}
