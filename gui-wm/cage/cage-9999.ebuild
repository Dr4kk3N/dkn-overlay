# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson verify-sig

DESCRIPTION="A Wayland kiosk"
HOMEPAGE="https://www.hjdskes.nl/projects/cage/ https://github.com/cage-kiosk/cage"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cage-kiosk/cage"
else
	SRC_URI="https://github.com/cage-kiosk/cage/archive/v${PV}.tar.gz -> ${P}.tar.gz
	verify-sig? ( https://github.com/cage-kiosk/cage/releases/download/v${PV}/${P}.tar.gz.sig )
	"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="X man"

# No tests
RESTRICT="test"

DEPEND="
	dev-libs/wayland
	>=dev-libs/wayland-protocols-1.14
        gui-libs/wlroots:0.20[X=]
	x11-libs/libxkbcommon[X?]
	X? ( gui-libs/wlroots:0.19[X,x11-backend] )
"
RDEPEND="${DEPEND}"
BDEPEND="
        dev-util/wayland-scanner
        >=app-text/scdoc-1.9.2
        verify-sig? ( sec-keys/openpgp-keys-emersion )
"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/emersion.asc"

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
	)
	meson_src_configure
}
