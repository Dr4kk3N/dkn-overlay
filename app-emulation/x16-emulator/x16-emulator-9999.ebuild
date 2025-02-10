# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/commanderx16/x16-emulator.git"
	ROM_REPO_URI="https://github.com/commanderx16/x16-rom.git"
	ROM_P="x16-rom-9999"
else
	SRC_URI="
		https://github.com/commanderx16/x16-emulator/archive/r${PV}.tar.gz  -> ${P}.tar.gz
		https://github.com/commanderx16/x16-rom/archive/r${PV}.tar.gz -> x16-rom-${PV}.tar.gz
	"
	KEYWORDS="~amd64"
	MY_P="${PN}-r${PV}"
	S="${WORKDIR}/${MY_P}"
	ROM_P="x16-rom-r${PV}"
fi

DESCRIPTION="Emulator for the Commander X16 computer"
HOMEPAGE="https://github.com/commanderx16/x16-emulator"
LICENSE="BSD-2"
SLOT="0"
IUSE="+rom"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	rom? ( dev-embedded/cc65 )
	media-libs/libsdl2
"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
		use rom && git-r3_fetch "${ROM_REPO_URI}" || die
		use rom && git-r3_checkout "${ROM_REPO_URI}" "${WORKDIR}/${ROM_P}" || die
	else
		default
	fi
}

src_prepare() {
	default
	sed -i "s/-Werror //" "${S}/Makefile"
}

src_compile() {
	default
	use rom && emake -C "${WORKDIR}/${ROM_P}" || die
}

src_install() {
	dodir /opt/${PN}
	cp "${S}/x16emu" "${D}/opt/${PN}" || die
	use rom && cp "${WORKDIR}/${ROM_P}/build/x16/rom.bin" "${D}/opt/${PN}" || die
	dosym ../../opt/"${PN}"/x16emu /usr/bin/x16emu
}
