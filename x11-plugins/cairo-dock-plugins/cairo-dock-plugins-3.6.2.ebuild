# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="${PN/plugins/plug-ins}"
MM_PV=$(ver_cut 1-2)

DESCRIPTION="Official plugins for cairo-dock"
HOMEPAGE="http://www.glx-dock.org"

SRC_URI="https://github.com/Cairo-Dock/cairo-dock-plug-ins/archive/refs/tags/${PV}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa exif gmenu terminal gnote vala +webkit xfce xgamma xklavier twitter indicator3 mail"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	gnome-base/librsvg:2
	sys-apps/dbus
	x11-libs/cairo
	>=x11-misc/cairo-dock-${PV}
	x11-libs/gtk+:3
	alsa? ( media-libs/alsa-lib )
	exif? ( media-libs/libexif )
	gmenu? ( gnome-base/gnome-menus )
	terminal? ( x11-libs/vte:= )
	vala? ( dev-lang/vala:= )
	xfce? ( xfce-base/thunar )
	xgamma? ( x11-libs/libXxf86vm )
	xklavier? ( x11-libs/libxklavier )
	gnote? ( app-misc/gnote )
	twitter? ( dev-python/oauth dev-python/simplejson )
	indicator3? ( dev-libs/libappindicator:= )
	mail? ( net-libs/libetpan )
	webkit? ( net-libs/webkit-gtk )
"

DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	dev-libs/libdbusmenu[gtk3]
"

S="${WORKDIR}/cairo-dock-plug-ins-${PV}"

src_prepare() {
	eapply "${FILESDIR}/cairo-dock-00-disable-zeitgeist-gentoo.diff"
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-Denable-alsa-mixer=$(usex alsa)
		-Denable-sound-effects=$(usex alsa)
		-Denable-upower-support=ON
	)
	cmake_src_configure
}
