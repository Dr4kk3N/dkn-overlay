# Copyright 2023-2024 Robert Günzler
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo shell-completion rust-toolchain

DESCRIPTION="Efficient animated wallpaper daemon for wayland, controlled at runtime"
HOMEPAGE="https://github.com/Horus645/swww"

if [[ "$PV" = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Horus645/swww.git"
else
	SRC_URI="https://github.com/Horus645/swww/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz $(cargo_crate_uris)"
	KEYWORDS="~amd64"
fi

RUST_MIN_VERSION=1.70.0

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
IUSE="+man"

DEPEND="app-arch/lz4
	x11-libs/libxkbcommon[wayland]"
RDEPEND="${DEPEND}"
BDEPEND="
	man? ( app-text/scdoc )
"

QA_FLAGS_IGNORED="
	usr/bin/swww
	usr/bin/swww-daemon
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
	use man && ${S}/doc/gen.sh
}

src_install() {
	dodoc README.md CHANGELOG.md
	dobashcomp "${WORKDIR}/swww-${PV}/completions/swww.bash"
	dofishcomp "${WORKDIR}/swww-${PV}/completions/swww.fish"

	if use man ; then
		doman doc/generated/*
	fi

	if use debug ; then
		cd target/debug || die
	else
		cd target/release || die
	fi

	dobin swww{,-daemon}
}
