# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LIBRETRO_REPO_NAME="libretro/dolphin"
LIBRETRO_CORE_NAME="dolphin"

inherit cmake
# TODO no EAPI-8 #966155, copy in relevant code
# inherit libretro-core

DESCRIPTION="A Gamecube/Wii emulator core for libretro"
HOMEPAGE="https://github.com/libretro/dolphin"
KEYWORDS=""
IUSE="+opengl vulkan +X test"
RESTRICT="!test? ( test )"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	dev-libs/hidapi:0=
	dev-libs/libfmt:0=
	dev-libs/lzo:2=
	dev-libs/pugixml:0=
	dev-qt/qtconcurrent
	media-libs/libpng:0=
	media-libs/libsfml
	media-libs/mesa
	net-libs/enet:1.3
	net-libs/mbedtls:0=
	net-misc/curl:0=
	sys-libs/readline:0=
	sys-libs/zlib:0=
	X? (
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrandr
	)
	virtual/libusb:1
	opengl? ( virtual/opengl )
	vulkan? ( media-libs/vulkan-loader )
"
DEPEND="${RDEPEND}
	games-emulation/libretro-info"

BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-fix-for-fmt.patch"
)

# [directory]=license
declare -A KEEP_BUNDLED=(
	# Issues revealed at configure time
	#
	# Please keep this list in `CMakeLists.txt` order
	[Bochs_disasm]=LGPL-2.1+
	[cpp-optparse]=MIT
	[glslang]=BSD
	[imgui]=MIT
	[xxhash]=BSD-2
	[minizip]=ZLIB
	[libpng]=libpng2 # Intentionally static for Libretro
	[FreeSurround]=GPL-2+
	[soundtouch]=LGPL-2.1+
	[curl]=curl # Intentionally static for Libretro
	[gtest]=BSD

	# Issues revealed at compile time
	[Libretro]=MIT
	[picojson]=BSD-2 # Complains about exception handling being disabled
	[Vulkan]=Apache-2.0 # Relies on `VK_PRESENT_MODE_RANGE_SIZE_KHR`
)

add_bundled_licenses() {
	for license in "${KEEP_BUNDLED[@]}"; do
		LICENSE+=" ${license}"
	done
}
add_bundled_licenses

src_prepare() {
	cmake_src_prepare

	local s remove=()
	for s in Externals/*; do
		[[ -f ${s} ]] && continue
		if ! has "${s#Externals/}" "${!KEEP_BUNDLED[@]}"; then
			remove+=( "${s}" )
		fi
	done

	einfo "removing sources: ${remove[*]}"
	rm -r "${remove[@]}" || die
}

src_configure() {
	local mycmakeargs=(
		-DCCACHE_BIN=CCACHE_BIN-NOTFOUND
		#-DENABLE_LLVM=OFF
		-DBUILD_SHARED_LIBS=OFF
		-DLIBRETRO=ON
		-DLIBRETRO_STATIC=1
		-DENABLE_QT=0
		-DUSE_SHARED_ENET=ON
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_INSTALL_PREFIX=/usr
		-DENABLE_X11=$(usex X)
		-DENABLE_TESTS=$(usex test)

		# Avoid warning spam around unset variables.
		-Wno-dev

		# System installed Git shouldn't affect non-live builds
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=yes

	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_test() {
	cmake_build unittests
}

src_install() {
	# TODO libretro-core.eclass does not support EAPI-8 #966155

	# LIBRETRO_CORE_LIB_FILE="${BUILD_DIR}/${LIBRETRO_CORE_NAME}_libretro.so"
	# libretro-core_src_install

	# libretro-core_src_install from libretro-core.eclass
	local LIBRETRO_CORE_NAME=${PN#libretro-}
	LIBRETRO_CORE_NAME=${LIBRETRO_CORE_NAME//-/_}

	local LIBRETRO_CORE_LIB_FILE="${BUILD_DIR}/${LIBRETRO_CORE_NAME}_libretro.so"

	# Absolute path of the directory containing Libretro shared libraries.
	local libretro_lib_dir="/usr/$(get_libdir)/libretro"
	# If this core's shared library exists, install that.
	if [[ -f "${LIBRETRO_CORE_LIB_FILE}" ]]; then
		exeinto "${libretro_lib_dir}"
		doexe "${LIBRETRO_CORE_LIB_FILE}"
	else
		# Basename of this library.
		local lib_basename="${LIBRETRO_CORE_LIB_FILE##*/}"

		# Absolute path to which this library was installed.
		local lib_file_target="${ED}${libretro_lib_dir}/${lib_basename}"

		# If this library was *NOT* installed, fail.
		[[ -f "${lib_file_target}" ]] ||
			die "Libretro core shared library \"${lib_file_target}\" not installed."
	fi
}
