# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.1
LLVM_COMPAT=( {18..21} )
LLVM_OPTIONAL=1

inherit cmake desktop xdg flag-o-matic llvm-r1 toolchain-funcs

DESCRIPTION="An early PlayStation 4 emulator written in C++."
HOMEPAGE="https://github.com/shadps4-emu/shadPS4"

if [[ ${PV} == *9999 ]]
then
	EGIT_REPO_URI="https://github.com/shadps4-emu/shadPS4.git"
	EGIT_SUBMODULES=( 'externals/CLI11' \
			  'externals/ImGuiFileDialog' \
			  'externals/LibAtrac9' \
			  'externals/MoltenVK' \
			  'externals/cpp-httplib' \
			  'externals/date' \
			  'externals/dear_imgui' \
			  'externals/discord-rpc' \
			  'externals/epoll-shim' \
			  'externals/ext-boost' \
			  'externals/ext-wepoll' \
			  'externals/ffmpeg-core' \
			  'externals/fmt' \
			  'externals/glslang' \
			  'externals/half' \
			  'externals/hwinfo' \
			  'externals/json' \
			  'externals/libpng' \
			  'externals/libressl' \
			  'externals/libusb' \
			  'externals/magic_enum' \
			  'externals/minimp3' \
			  'externals/miniz' \
			  'externals/openal-soft' \
			  'externals/pugixml' \
			  'externals/robin-map' \
			  'externals/sdl3' \
			  'externals/sirit' \
			  'externals/spdlog' \
			  'externals/toml11' \
			  'externals/tracy' \
			  'externals/vma' \
			  'externals/vulkan-headers' \
			  'externals/xbyak' \
			  'externals/xxhash' \
			  'externals/zlib-ng' \
			  'externals/zydis' \
			  'externals/aacdec/fdk-aac' \
			  'externals/discord-rpc/thirdparty/rapidjson' \
			  'externals/discord-rpc/thirdparty/rapidjson/thirdparty/gtest' \
			  'externals/zydis/dependencies/zycore' \
			  'externals/zlib-ng/zlibstatic-ngd' \
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
	dev-cpp/cli11
	dev-cpp/magic_enum
	dev-cpp/nlohmann_json
	dev-cpp/robin-map
	app-arch/lz4:=
	app-arch/xz-utils
	app-arch/zstd:=
	dev-libs/libaio
	app-text/doxygen
	media-libs/libglvnd
	media-libs/libpng:=
	media-libs/openal
	media-libs/libsdl3
	media-libs/sdl3-mixer
	media-libs/libwebp:=
	media-video/ffmpeg:=
	net-libs/libpcap
	media-gfx/renderdoc
	dev-libs/boost
	dev-libs/libfmt
	dev-libs/half
	dev-libs/pugixml
	dev-libs/stb
	dev-libs/xbyak
	dev-libs/xxhash
	media-libs/imgui
	net-misc/curl
	dev-cpp/toml11
	sys-apps/dbus
	sys-libs/zlib:=
	virtual/libudev:=
	virtual/jack
	virtual/zlib
	x11-libs/libXrandr
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-libs/libpulse )
	sndio? ( media-sound/sndio:= )
	vulkan? ( media-libs/vulkan-loader )
	wayland? ( dev-libs/wayland )
	test? ( dev-cpp/gtest )
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
	"${FILESDIR}/shadps4-emu-rpath.patch"
#	"${FILESDIR}/${P}-SDL3-rename.patch"
	"${FILESDIR}/${P}-cmake-4.patch"
	"${FILESDIR}/${P}-executable-stack.patch"
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

src_prepare() {
	mv src/core/libraries/fiber/fiber_context.s src/core/libraries/fiber/fiber_context.S || die
	cmake_src_prepare
}

src_configure() {
	filter-lto
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF # to remove after unbundling
		#-DSDL_SHARED=ON
		-DENABLE_DISCORD_RPC="$(usex discord ON OFF)"
		-DENABLE_UPDATER=OFF
		-DUSE_LINKED_FFMPEG=yes
		-DCMAKE_C_COMPILER=clang
		-DCMAKE_CXX_COMPILER=clang++
		-DUSE_VULKAN=$(usex vulkan)
		-DWAYLAND_API=$(usex wayland)
		-DCHECK_ALSA=$(usex alsa)
		-DCHECK_PULSE=$(usex pulseaudio)
		-DCHECK_SNDIO=$(usex sndio)
		-DENABLE_TESTS="$(usex test ON OFF)"
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
