# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LLVM_COMPAT=( 18 19 )
inherit git-r3 meson llvm-r2 xdg

DESCRIPTION="An IDE using EFL"
HOMEPAGE="https://git.enlightenment.org/enlightenment/edi.git"
EGIT_REPO_URI="https://git.enlightenment.org/enlightenment/edi.git"

S="${WORKDIR}/${P/_/-}"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clang"
DOCS=( AUTHORS NEWS README.md )

RDEPEND="|| ( dev-libs/efl[X] dev-libs/efl[wayland] )
	>=dev-libs/efl-1.22.0[eet]
	clang? (
		dev-util/bear
		$(llvm_gen_dep 'llvm-core/clang:${LLVM_SLOT}=')
	)"
DEPEND="${RDEPEND}
	dev-libs/check"
BDEPEND="virtual/libintl
	virtual/pkgconfig"

llvm_check_deps() {
	has_version "llvm-core/clang:${LLVM_SLOT}"
}

pkg_setup() {
	use clang && llvm-r2_pkg_setup
}

src_prepare() {
	default

	# fix a QA issue with .desktop file, https://phab.enlightenment.org/T7368
	sed -i '/Version=/d' data/desktop/edi.desktop* || die

	# fix 'unexpected path' QA warning
	sed -i 's|share/doc/edi/|share/doc/'${PF}'/|g' doc/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use clang bear)
		$(meson_use clang libclang)
	)

	if use clang; then
		emesonargs+=(
			-D libclang-headerdir="$(llvm-config --includedir)"
			-D libclang-libdir="$(llvm-config --libdir)"
		)
	fi

	meson_src_configure
}
