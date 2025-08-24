# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {18..20} )

inherit cmake llvm-r1

DESCRIPTION="User Mode Register Debugger for AMDGPU Hardware"
HOMEPAGE="https://gitlab.freedesktop.org/tomstdenis/umr https://github.com/ps4gentoo/ps4-umr"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/ps4gentoo/ps4-umr"
	inherit git-r3
else
	SRC_URI="
		https://github.com/ps4gentoo/ps4-umr/${MY_P}.tar.xz
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
fi

LICENSE="LGPL 2.1"
SLOT="0"

IUSE="X +sdl debug"

REQUIRED_USE="sdl"

RDEPEND="
	>=dev-libs/expat-2.1.0-r3
	>=sys-libs/zlib-1.2.8
	media-libs/libsdl2:=
	X? (
		>=x11-libs/libX11-1.6.2
		>=x11-libs/libxshmfence-1.1
		>=x11-libs/libXext-1.3.2
		>=x11-libs/libXxf86vm-1.1.3
		>=x11-libs/libxcb-1.13
		>=x11-libs/xcb-util-wm-0.4.2
	)
"
