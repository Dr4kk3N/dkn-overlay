# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {15..19} )
LLVM_OPTIONAL=1

inherit cmake llvm-r1 desktop xdg

MY_PN="Cemu"

if [[ ${PV} == *9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/cemu-project/Cemu"
        EGIT_SUBMODULES=(
                dependencies/Vulkan-Headers
                dependencies/Zarchive
                dependencies/cubeb
                dependencies/imgui
        )
else
	SHA="dd0af0a56fa3c6b8a82f60c19e67bbe06d673d0e"
	IMGUI_PV="1.89.5"
	SRC_URI="
		https://github.com/cemu-project/${MY_PN}/archive/${SHA}.tar.gz
			-> ${P}.tar.gz
		https://github.com/ocornut/imgui/archive/refs/tags/v${IMGUI_PV}.tar.gz
			-> ${PN}-imgui-${IMGUI_PV}.tar.gz
	"
        KEYWORDS="~amd64"
fi

DESCRIPTION="Wii U emulator."
HOMEPAGE="https://cemu.info/ https://github.com/cemu-project/Cemu"
LICENSE="MPL-2.0 ISC"
SLOT="0"
IUSE="+cubeb discord +sdl +vulkan llvm"

REQUIRED_USE="
	llvm? ( ${LLVM_REQUIRED_USE} )
"

DEPEND="app-arch/zarchive
	app-arch/zstd
	cubeb? ( media-libs/cubeb )
	dev-libs/boost
	dev-libs/glib
	>=dev-libs/libfmt-9.1.0:=
	dev-libs/libzip
	dev-libs/openssl
	dev-libs/pugixml
	dev-libs/rapidjson
	dev-libs/wayland
	dev-util/glslang
	media-libs/libglvnd
	media-libs/libsdl2[haptic,joystick]
	net-misc/curl
	sys-libs/zlib
	vulkan? ( dev-util/vulkan-headers )
	llvm? ( $(llvm_gen_dep 'llvm-core/llvm:${LLVM_SLOT}=') )
	x11-libs/gtk+:3[wayland]
	x11-libs/libX11
	x11-libs/wxGTK:3.3-gtk3
	virtual/libusb"
RDEPEND="${DEPEND}"
BDEPEND="media-libs/glm"

S="${WORKDIR}/cemu-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-0002-remove-default-from-system-g.patch"
)

pkg_setup() {
        use llvm && llvm-r1_pkg_setup
}

src_prepare() {
	sed -re \
		's/^target_link_libraries\(CemuBin.*/target_link_libraries(CemuBin PRIVATE wayland-client/' \
		-i src/CMakeLists.txt || die
	cmake_src_prepare
#	rmdir dependencies/imgui || die
#	mv "${WORKDIR}/imgui-${IMGUI_PV}" dependencies/imgui || die
}

src_configure() {
	if use llvm; then
		mycmakeargs+=(
			-DCMAKE_C_COMPILER=/usr/bin/clang
			-DCMAKE_CXX_COMPILER=/usr/bin/clang++
		)
	fi

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_BUILD_TYPE=release
		-DCMAKE_C_COMPILER=/usr/bin/clang
                -DCMAKE_CXX_COMPILER=/usr/bin/clang++
		-DENABLE_CUBEB=$(usex cubeb)
		-DENABLE_DISCORD_RPC=$(usex discord)
		-DENABLE_OPENGL=ON
		-DENABLE_SDL=$(usex sdl)
		-DENABLE_VCPKG=OFF
		-DENABLE_VULKAN=$(usex vulkan)
		-DENABLE_WXWIDGETS=ON
		-DwxWidgets_CONFIG_EXECUTABLE=/usr/$(get_libdir)/wx/config/gtk3-unicode-3.2-gtk3
		-DCMAKE_DISABLE_PRECOMPILE_HEADERS=OFF
		-Wno-dev
	)
	cmake_src_configure
}

src_install() {
	newbin "bin/${MY_PN}_relwithdebinfo" "$MY_PN"
	insinto "/usr/share/${PN}/gameProfiles"
	doins -r bin/gameProfiles/default/*
	insinto "/usr/share/${PN}"
#	doins -r bin/resources bin/shaderCache
	einstalldocs
	newicon -s 128 src/resource/logo_icon.png "info.${PN}.${MY_PN}.png"
	domenu "dist/linux/info.${PN}.${MY_PN}.desktop"
}
