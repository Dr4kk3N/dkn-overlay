# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..14} pypy3 pypy3_11 )

inherit cmake desktop git-r3 python-any-r1 xdg

DESCRIPTION="A mcpe 0.1.0-0.11.1 launcher for linux and windows"
HOMEPAGE="https://github.com/MCPI-Revival/Ninecraft"
EGIT_REPO_URI="https://github.com/MCPI-Revival/Ninecraft"
EGIT_SUBMODULES=( '*' '-zlib' '-SDL' )

LICENSE="MIT"
SLOT="0"
KEYWORDS="-alpha -hppa -loong -m68k -mips -ppc -ppc64 -riscv -s390 -sparc"
IUSE="experimental"

DEPEND="
	media-libs/openal:=[abi_x86_32(+)]
	x11-libs/libX11:=[abi_x86_32(+)]
	x11-libs/libXrandr:=[abi_x86_32(+)]
	x11-libs/libXinerama:=[abi_x86_32(+)]
	x11-libs/libXcursor:=[abi_x86_32(+)]
	x11-libs/libXi:=[abi_x86_32(+)]
	media-libs/mesa:=[abi_x86_32(+)]
	media-libs/libsdl2:=[abi_x86_32(+)]
	virtual/zlib:=[abi_x86_32(+)]
"

RDEPEND="
	${DEPEND}
	gnome-extra/zenity
	app-arch/unzip
	dev-util/patchelf
"

BDEPEND="
	dev-build/cmake
	$(python_gen_any_dep 'dev-python/jinja2[${PYTHON_USEDEP}]')
"

python_check_deps() {
	python_has_version dev-python/jinja2[${PYTHON_USEDEP}]
}

pkg_setup() {
	python-any-r1_pkg_setup

	use experimental && export EGIT_BRANCH="0.12-experimental"
}

src_prepare() {
	cmake_src_prepare

	sed -i -e 's/add_subdirectory(zlib)/find_package(ZLIB REQUIRED)/' \
		-e 's/add_subdirectory(SDL)/find_package(SDL2 REQUIRED)/' \
		CMakeLists.txt || die
	sed -i 's/zlibstatic/ZLIB::ZLIB/' ninecraft/CMakeLists.txt || die
}

src_configure() {
	export CFLAGS="${CFLAGS} -m32"
	export CXXFLAGS="${CXXFLAGS} -m32"
	export LDFLAGS="${LDFLAGS} -m32"

	# arm support has not been tested
	if use arm || use arm64; then
		MY_ARCH="arm"
	elif use x86 || use amd64; then
		MY_ARCH="i686"
	else
		die "Unsupported architecture"
	fi

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_TOOLCHAIN_FILE="${S}/cmake/${MY_ARCH}_toolchain.cmake"
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	insinto /opt/ninecraft
	doins "${BUILD_DIR}/ninecraft/ninecraft" "${FILESDIR}/ninecraft-launcher.sh" "${FILESDIR}/ninecraft-extract.sh"
	fperms +x /opt/ninecraft/ninecraft /opt/ninecraft/ninecraft-launcher.sh /opt/ninecraft/ninecraft-extract.sh

	dosym ../../opt/ninecraft/ninecraft-launcher.sh /usr/bin/ninecraft
	dosym ../../opt/ninecraft/ninecraft-extract.sh /usr/bin/ninecraft-extract

	domenu "${FILESDIR}/ninecraft.desktop"
}
