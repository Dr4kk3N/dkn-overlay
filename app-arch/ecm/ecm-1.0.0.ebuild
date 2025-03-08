# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit toolchain-funcs

DESCRIPTION="Convert between ECM and BIN files"
HOMEPAGE="https://web.archive.org/web/20091104002036/www.neillcorlett.com/${PN}"
SRC_URI="https://web.archive.org/web/20091021035854/www.neillcorlett.com\
/downloads/ecm100.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86 ~arm ~mips ~ppc ~ppc64 ~amd64-linux ~x86-linux ~x64-macos"

DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_compile() {
	for i in *.c; do
		$(tc-getCC) ${CFLAGS} ${LDFLAGS} "$i" -o "${i%.*}" || die
	done
}

src_install() {
	dobin {un,}ecm
	dodoc {format,readme}.txt
}
