# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.1
LLVM_COMPAT=( {18..20} )
LLVM_OPTIONAL=1

inherit cmake desktop xdg flag-o-matic llvm-r1 toolchain-funcs

DESCRIPTION="An early PlayStation 4 emulator written in C++."
HOMEPAGE="https://github.com/shadps4-emu/shadPS4"

if [[ ${PV} == *9999 ]]
then
	EGIT_REPO_URI="https://github.com/shadps4-emu/shadPS4.git"
	EGIT_SUBMODULES=( 'externals/LibAtrac9' \
			  'externals/MoltenVK' \
			  'externals/date' \
			  'externals/dear_imgui' \
			  'externals/discord-rpc' \
			  'externals/epoll-shim' \
			  'externals/ext-CLI11' \
			  'externals/ext-boost' \
			  'externals/ext-libusb' \
			  'externals/ext-wepoll' \
			  'externals/ffmpeg-core' \
			  'externals/fmt' \
			  'externals/glslang' \
			  'externals/half' \
			  'externals/hwinfo' \
			  'externals/json' \
			  'externals/libpng' \
			  'externals/magic_enum' \
			  'externals/miniz' \
			  'externals/pugixml' \
			  'externals/robin-map' \
			  'externals/sdl3' \
			  'externals/sdl3_mixer' \
			  'externals/sirit' \
			  'externals/toml11' \
			  'externals/tracy' \
			  'externals/vma' \
			  'externals/vulkan-headers' \
			  'externals/xbyak' \
			  'externals/xxhash' \
			  'externals/zlib-ng' \
			  'externals/zydis' \
			  'externals/zydis/dependencies/zycore' \
			  'externals/zlib-ng/zlibstatic-ngd' \
			  'externals/aacdec/fdk-aac' \
			  'externals/sdl3_mixer/external/flac' \
			  'externals/sdl3_mixer/external/libgme' \
			  'externals/sdl3_mixer/external/libxmp' \
			  'externals/sdl3_mixer/external/mpg123' \
			  'externals/sdl3_mixer/external/ogg' \
			  'externals/sdl3_mixer/external/opus' \
			  'externals/sdl3_mixer/external/opusfile' \
			  'externals/sdl3_mixer/external/tremor' \
			  'externals/sdl3_mixer/external/vorbis' \
			  'externals/sdl3_mixer/external/wavpack' \
			  'externals/sirit/externals/SPIRV-Headers'
			)
	inherit git-r3
else
	EGIT_COMMIT=86911747bf64324cfd438afc08f6f6a0a9f7ff41
	ZYDIS_COMMIT=5a68f639e4f01604cc7bfc8d313f583a8137e3d3
	SRC_URI="
		https://github.com/shadps4-emu/shadPS4/archive/${EGIT_COMMIT}.tar.gz
			-> ${P}.tar.gz
		https://github.com/zyantific/zydis/archive/${ZYDIS_COMMIT}.tar.gz
	"
	S=${WORKDIR}/${PN}-${EGIT_COMMIT}
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+llvm alsa discord pulseaudio sndio vulkan wayland test debug"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	llvm? ( ${LLVM_REQUIRED_USE} )
"

COMMON_DEPEND="
	app-arch/lz4:=
	app-arch/xz-utils
	app-arch/zstd:=
	dev-libs/libaio
	app-text/doxygen
	media-libs/libglvnd
	media-libs/libpng:=
	media-libs/libsdl3
	media-libs/sdl3-mixer
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
	llvm-core/clang:*
	wayland? (
		dev-util/wayland-scanner
		kde-frameworks/extra-cmake-modules
	)
"

PATCHES=(
	"${FILESDIR}"/shadps4-emu-rpath.patch
)

pkg_setup() {
	if use llvm && has_version llvm-core/llvm[!debug=]; then
		ewarn "Mismatch between debug USE flags in games-emulation/shadps4-emu and llvm-core/llvm"
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

	#insinto /usr/lib/${PN}
	# doins -r "${BUILD_DIR}"/bin/.
	#fperms +x /usr/lib/${PN}/shadps4

	exeinto "/opt/shadps4"

	insinto /opt/shadps4
        doins -r "${BUILD_DIR}"/.
        fperms +x /opt/shadps4/shadps4
	insopts -m0755
	dosym "/opt/shadps4/shadps4" "/opt/bin/shadps4"

	use !test || rm "${ED}"/opt/${PN}/*_test || die
}

#pkg_postinst() {
#        
#}

#pkg_postrm() {
#        
#}
