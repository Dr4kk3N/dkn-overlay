# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {18..19} )
LLVM_OPTIONAL=1

inherit cmake llvm-r1 flag-o-matic toolchain-funcs git-r3 xdg

DESCRIPTION="An emulator for Nintendo Switch"
HOMEPAGE="https://citron-emu.org"
EGIT_REPO_URI="https://git.citron-emu.org/Citron/Citron.git"
EGIT_SUBMODULES=( '-*' 'cpp-httplib' 'cpp-jwt' 'dynarmic' 'mbedtls' 'simpleini' 'sirit' 'xbyak' 'tzdb_to_nx'
	              'externals/nx_tzdb/tzdb_to_nx/externals/tz/tz' 'VulkanMemoryAllocator' )
# Dynarmic is not intended to be generic, it is tweaked to fit emulated processor
# Bundled back some libs: cpp-* mbedtls

# asio: use dev-cpp/asio until src/input_common/drivers/udp_client.cpp updated
# system-vulkan: wait for 1.4.307 (also need vulkan-utility-libraries?)
LICENSE="|| ( Apache-2.0 GPL-2+ ) 0BSD BSD GPL-2+ ISC MIT
	!system-vulkan? ( Apache-2.0 )"
SLOT="0"
KEYWORDS=""
IUSE="-compatibility-list +cubeb +qt6 sdl +system-libfmt -system-vulkan test webengine clang lto pgo"

RDEPEND="
	>=app-arch/zstd-1.5
	>=dev-libs/inih-52
	>=dev-libs/openssl-1.1:=
	>=media-video/ffmpeg-4.3:=
	>=net-libs/enet-1.3
	app-arch/lz4:=
	dev-cpp/asio
	dev-libs/boost:=[context]
	media-libs/opus
	>=media-libs/vulkan-loader-1.3.274
	sys-libs/zlib
	virtual/libusb:1
	cubeb? ( media-libs/cubeb )
	qt6? (
		>=dev-qt/qtbase-6.6.0:6[gui,widgets]
		webengine? ( dev-qt/qtwebengine:6[widgets] )
	)
	sdl? ( >=media-libs/libsdl2-2.28 )
	system-libfmt? ( >=dev-libs/libfmt-9:= )
"
DEPEND="${RDEPEND}
	system-vulkan? (
		dev-util/spirv-headers
		>=dev-util/vulkan-headers-1.3.274
		dev-util/vulkan-utility-libraries
		x11-libs/libX11
	)
	test? ( >dev-cpp/catch-3:0 )
"
BDEPEND="
	>=dev-cpp/nlohmann_json-3.8.0
	dev-cpp/robin-map
	dev-util/glslang
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
		llvm-core/llvm:${LLVM_SLOT}
		clang? (
			llvm-core/lld:${LLVM_SLOT}
			pgo? ( llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[profile] )
		)
	')
"
REQUIRED_USE="|| ( qt6 sdl ) "
RESTRICT="!test? ( test )"

llvm_check_deps() {
	if ! has_version -b "llvm-core/clang:${LLVM_SLOT}" ; then
		einfo "llvm-core/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
		return 1
	fi

	if use clang && ! tc-ld-is-mold ; then
		if ! has_version -b "llvm-core/lld:${LLVM_SLOT}" ; then
			einfo "llvm-core/lld:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi
	fi

	if use pgo ; then
		if ! has_version -b "=llvm-runtimes/compiler-rt-sanitizers-${LLVM_SLOT}*[profile]" ; then
			einfo "=llvm-runtimes/compiler-rt-sanitizers-${LLVM_SLOT}*[profile] is missing!" >&2
			einfo "Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi
	fi

	einfo "Using LLVM slot ${LLVM_SLOT} to build" >&2
}

src_unpack() {
	if use !system-vulkan; then
		EGIT_SUBMODULES+=('externals/sirit/externals/SPIRV-Headers')
		EGIT_SUBMODULES+=('Vulkan-Headers')
		EGIT_SUBMODULES+=('Vulkan-Utility-Libraries')
	fi

	if use test; then
		EGIT_SUBMODULES+=('Catch2')
	fi

	git-r3_src_unpack

	# Do not fetch via sources because this file always changes
	use compatibility-list && curl https://api.citron-emu.org/gamedb/ > "${S}"/compatibility_list.json
}

src_prepare() {
	# temporary fix
	sed -i -e '/Werror/d' src/CMakeLists.txt || die

	# Workaround: GenerateSCMRev fails
	sed -i -e "s/@GIT_BRANCH@/${EGIT_BRANCH:-master}/" \
		-e "s/@GIT_REV@/$(git rev-parse --short HEAD)/" \
		-e "s/@GIT_DESC@/$(git describe --always --long)/" \
		src/common/scm_rev.cpp.in || die

	# Unbundle cubeb
	sed -i '/^if.*cubeb/,/^endif()/d' externals/CMakeLists.txt || die

	# Unbundle enet
	sed -i -e '/^if.*enet/,/^endif()/d' externals/CMakeLists.txt || die
	sed -i -e '/enet\/enet\.h/{s/"/</;s/"/>/}' src/network/network.cpp || die

	# LZ4 temporary fix: https://github.com/yuzu-emu/yuzu/pull/9054/commits/a8021f5a18bc5251aef54468fa6033366c6b92d9
	sed -i 's/lz4::lz4/lz4/' src/common/CMakeLists.txt || die

	if ! use system-libfmt; then # libfmt >= 9
		sed -i '/fmt.*REQUIRED/d' CMakeLists.txt || die
	fi

	# asio fix
	sed -e "/asio.hpp/a #include <asio.hpp>" -e "s/boost::asio/asio/g" \
		-i src/input_common/drivers/udp_client.cpp || die

	cmake_src_prepare
}

src_configure() {
#	if use clang ; then
#		# Force clang
#		einfo "Enforcing the use of clang due to USE=clang ..."
#		AR=llvm-ar
#		CC=${CHOST}-clang
#		CXX=${CHOST}-clang++
#		NM=llvm-nm
#		RANLIB=llvm-ranlib
#		LDFLAGS+=" -fuse-ld=lld"
#
#		# Not implemented by Clang, bug #903889
#		#filter-flags -Wlto-type-mismatch -Werror=lto-type-mismatch
#	else
#		# Force gcc
#		einfo "Enforcing the use of gcc due to USE=-clang ..."
#		AR=gcc-ar
#		CC=${CHOST}-gcc
#		CXX=${CHOST}-g++
#		NM=gcc-nm
#		RANLIB=gcc-ranlib
#	fi
#
#	filter-lto
#
#	export LO_CLANG_CC=${CC}
#	export LO_CLANG_CXX=${CXX}
#
#	# Show flags set at the end
#	einfo "  Used CFLAGS:    ${CFLAGS}"
#	einfo "  Used LDFLAGS:   ${LDFLAGS}"
#
#	# Ensure we use correct toolchain
#	tc-export CC CXX LD AR NM OBJDUMP RANLIB PKG_CONFIG

	if use clang && ! tc-is-clang; then
		local -x CC=${CHOST}-clang CXX=${CHOST}-clang++
		strip-unsupported-flags
	fi

	local -a mycmakeargs=(
		# Libraries are private and rely on circular dependency resolution.
		-DCITRON_ENABLE_LTO=$(usex lto ON OFF)
		-DCITRON_ENABLE_PGO_INSTRUMENT=$(usex pgo ON OFF)
		-DBUILD_SHARED_LIBS=OFF # dynarmic
		-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=$(usex compatibility-list)
		-DENABLE_CUBEB=$(usex cubeb ON OFF)
		-DENABLE_LIBUSB=ON
		-DENABLE_QT=$(usex qt6 ON OFF)
		-DENABLE_QT_TRANSLATION=$(usex qt6 ON OFF)
		-DENABLE_SDL2=$(usex sdl ON OFF)
		-DENABLE_WEB_SERVICE=OFF
		-DSIRIT_USE_SYSTEM_SPIRV_HEADERS=$(usex system-vulkan ON OFF)
		-DCITRON_USE_LLVM_DEMANGLE=OFF
		-DUSE_DISCORD_PRESENCE=OFF
		-DCITRON_TESTS=$(usex test)
		-DCITRON_USE_EXTERNAL_VULKAN_HEADERS=$(usex system-vulkan OFF ON)
		-DCITRON_USE_EXTERNAL_VULKAN_UTILITY_LIBRARIES=$(usex system-vulkan OFF ON)
		-DCITRON_USE_EXTERNAL_SDL2=OFF
		-DCITRON_CHECK_SUBMODULES=false
		-DCITRON_USE_QT_WEB_ENGINE=$(usex webengine ON OFF)
		-DCMAKE_BUILD_TYPE=Release
	)

	cmake_src_configure

	# This would be better in src_unpack but it would be unlinked
	if use compatibility-list; then
		mv "${S}"/compatibility_list.json "${BUILD_DIR}"/dist/compatibility_list/ || die
	fi
}
