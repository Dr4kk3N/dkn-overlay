# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo rust-toolchain

DESCRIPTION="Multi-Purpose Launcher with a lot of features. Highly Customizable and fast"
HOMEPAGE="https://github.com/abenz1267/walker"

if [[ "$PV" = *9999* ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/abenz1267/walker.git"
else
        SRC_URI="https://github.com/abenz1267/walker/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz $(cargo_crate_uris)"
        KEYWORDS="~amd64"
fi

RUST_MIN_VERSION=1.70.0

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-libs/glib:2
	gui-libs/gtk:4
	>=gui-libs/gtk4-layer-shell-1.0.4
	dev-libs/gobject-introspection
	media-libs/graphene
	media-libs/vips:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-libs/glib-2.80.0[introspection]
"

src_unpack() {
        if [[ ${PV} = *9999* ]]; then
                git-r3_src_unpack
                cargo_live_src_unpack
        else
                cargo_src_unpack
        fi
}

src_compile() {
        cargo_src_compile
}
