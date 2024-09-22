# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson optfeature xdg #gnome.org

DESCRIPTION="A quick previewer for Nautilus, the GNOME file manager"
HOMEPAGE="https://gitlab.gnome.org/GNOME/sushi"

#if [[ ${PV} == 9999 ]]; then
        EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/sushi.git"
        inherit git-r3
#else
#       SRC_URI="
#               https://download.gnome.org/sources/${MY_P}.tar.xz
#       "
#       KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
#fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="wayland +X"
REQUIRED_USE="|| ( wayland X )"

DEPEND="
	media-libs/libepoxy
	>=app-text/evince-3.0[introspection]
	media-libs/freetype:2
	>=x11-libs/gdk-pixbuf-2.23.0[introspection]
	>=dev-libs/glib-2.29.14:2
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	>=x11-libs/gtk+-3.13.2:3[introspection,wayland?,X?]
	>=x11-libs/gtksourceview-4.0.3:4[introspection]
	>=media-libs/harfbuzz-0.9.9:=
	>=dev-libs/gobject-introspection-1.54:=
	>=dev-libs/gjs-1.40
"
RDEPEND="${DEPEND}
	=gnome-base/nautilus-9999
	media-plugins/gst-plugins-gtk:1.0[wayland?,X?]
"
BDEPEND="
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature wayland)
		$(meson_feature X X11)
		-Dprofile=default
	)
	meson_src_configure
}

src_compile() {
	local -x GST_PLUGIN_SYSTEM_PATH_1_0=
	meson_src_compile
}

pkg_postinst() {
	optfeature "Support viewing file formats such as generated by LibreOffice" \
	           app-office/libreoffice app-office/libreoffice-bin
}
