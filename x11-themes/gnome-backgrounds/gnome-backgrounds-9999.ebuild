# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson #gnome.org

DESCRIPTION="A set of backgrounds packaged with the GNOME desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-backgrounds"

#if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/gnome-backgrounds.git"
	inherit git-r3
#else
#	SRC_URI="
#		https://download.gnome.org/sources/${MY_P}.tar.xz
#	"
#	KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~riscv ~x86"
#fi

LICENSE="CC-BY-SA-2.0 CC-BY-SA-3.0 CC-BY-2.0 CC-BY-4.0"
SLOT="0"

RDEPEND="
	media-libs/libjxl[gdk-pixbuf]
	gnome-base/librsvg
"
BDEPEND=">=sys-devel/gettext-0.19.8"
