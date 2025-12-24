# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.1
LLVM_COMPAT=( {18..20} )
LLVM_OPTIONAL=1

inherit cmake desktop xdg fcaps flag-o-matic llvm-r1 toolchain-funcs

DESCRIPTION="Official launcher for shadPS4."
HOMEPAGE="https://github.com/shadps4-emu/shadps4-qtlauncher"

if [[ ${PV} == *9999 ]]
then
	EGIT_REPO_URI="https://github.com/shadps4-emu/shadps4-qtlauncher.git"
	EGIT_SUBMODULES=( 'externals/MoltenVK' \
			  'externals/fmt' \
			  'externals/json' \
			  'externals/pugixml' \
			  'externals/sdl3' \
			  'externals/toml11' \
			  'externals/volk' \
			  'externals/vulkan-headers'
			)
	inherit git-r3
else
	EGIT_COMMIT=86911747bf64324cfd438afc08f6f6a0a9f7ff41
	SRC_URI="
		https://github.com/shadps4-emu/shadps4-qtlauncher/archive/${EGIT_COMMIT}.tar.gz
			-> ${P}.tar.gz
		)
	"
	S=${WORKDIR}/${PN}-${EGIT_COMMIT}
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+llvm alsa pulseaudio sndio vulkan wayland test debug"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	llvm? ( ${LLVM_REQUIRED_USE} )
"

COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[concurrent,widgets]
	games-emulation/shadps4-emu
	app-arch/lz4:=
	app-arch/xz-utils
	app-arch/zstd:=
	dev-libs/libaio
	app-text/doxygen
	media-libs/libglvnd
	media-libs/libpng:=
	media-libs/libsdl3
	media-libs/libwebp:=
	media-video/ffmpeg:=
	net-libs/libpcap
	net-misc/curl
	dev-cpp/toml11
	sys-apps/dbus
	sys-libs/zlib:=
	virtual/libudev:=
	x11-libs/libXrandr
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-libs/libpulse )
	sndio? ( media-sound/sndio:= )
	vulkan? ( media-libs/vulkan-loader )
	wayland? ( dev-libs/wayland )
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	llvm-core/clang:*
	wayland? (
		dev-util/wayland-scanner
		kde-frameworks/extra-cmake-modules
	)
"

PATCHES=(
	"${FILESDIR}"/shadps4-qtlauncher-rpath.patch
)

pkg_setup() {
	if use llvm && has_version llvm-core/llvm[!debug=]; then
		ewarn "Mismatch between debug USE flags in games-emulation/shadps4 and llvm-core/llvm"
		ewarn "detected! This can cause problems."
	fi

	use llvm && llvm-r1_pkg_setup
}

#src_prepare() {
#	default
#	sed -i -e "/^PLATFORM_SYMBOLS/a '__gentoo_check_ldflags__'," bin/symbols-check.py || die
#	cmake_src_prepare
#}

#  sed -i '/three/cyour text' /tmp/file      work/shadps4-emu-9999_build/externals/zlib-ng/zlibstatic-ngd

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF # to remove after unbundling
		#-DSDL_SHARED=ON
		-DUSE_LINKED_FFMPEG=yes
		-DENABLE_QT_GUI=yes
		-DCMAKE_C_COMPILER=clang
		-DCMAKE_CXX_COMPILER=clang++
		-DUSE_VULKAN=$(usex vulkan)
		-DWAYLAND_API=$(usex wayland)
		-DCHECK_ALSA=$(usex alsa)
		-DCHECK_PULSE=$(usex pulseaudio)
		-DCHECK_SNDIO=$(usex sndio)
	)
	cmake_src_configure
}

src_install() {

	domenu "${FILESDIR}"/shadps4.desktop
	doicon -s 128 "${FILESDIR}"/shadps4.png
	#doicon -s 48 images/shadps4.ico

	#insinto /usr/lib/${PN}
	# doins -r "${BUILD_DIR}"/bin/.
	#fperms +x /usr/lib/${PN}/shadps4

	exeinto "/opt/shadps4-qtlauncher"

	insinto /opt/shadps4-qtlauncher
        doins -r "${BUILD_DIR}"/.
        fperms +x /opt/shadps4-qtlauncher/shadPS4QtLauncher
	insopts -m0755
	dosym "/opt/shadps4-qtlauncher/shadPS4QtLauncher" "/opt/bin/shadPS4QtLauncher"

	use !test || rm "${ED}"/opt/${PN}/*_test || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
