# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Open-source cross-platform C++ application framework"
HOMEPAGE="https://juce.com"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/juce-framework/JUCE.git"
else
	SRC_URI="https://github.com/juce-framework/JUCE/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/JUCE-${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="alsa cpu_flags_x86_sse2 curl doc examples extras gtk jack ladspa opengl webkit test"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/freetype
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	alsa? ( media-libs/alsa-lib )
	curl? ( net-misc/curl )
	gtk? (
		x11-libs/gtk+:3
		webkit? ( net-libs/webkit-gtk:4.1 )
	)
	jack? ( virtual/jack )
	ladspa? ( media-libs/ladspa-sdk )
	opengl? ( media-libs/libglvnd )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

pkg_pretend() {
	if use examples; then
		ewarn "You have enabled the 'examples' USE flag."
		ewarn "------------------------------------------------"
		ewarn "WARNING: HEADLESS BUILD FAILURE RISK"
		ewarn "The JUCE examples include 'WebViewPluginDemo', which attempts to"
		ewarn "open a GUI window during the compile/link phase."
		ewarn ""
		ewarn "This is known to fail in the standard Portage sandbox (headless)."
		ewarn "If you see 'Gtk-WARNING: cannot open display', you MUST"
		ewarn "disable the 'examples' flag to proceed."
		ewarn "------------------------------------------------"
		ewarn "Compiling examples also requires significant RAM (4GB+ per core)."
		ewarn "If the build hangs/crashes, try lowering MAKEOPTS (e.g., -j1)."
	fi
}

src_configure() {
	local mycmakeargs=(
		-DJUCE_INSTALL_DESTINATION="${EPREFIX}/usr/share/juce"
		-DJUCE_TOOL_INSTALL_DIR="${EPREFIX}/usr/bin"
		-DCMAKE_BUILD_TYPE=Release
		-DJUCE_BUILD_EXTRAS=$(usex extras)
		-DJUCE_BUILD_EXAMPLES=$(usex examples)
		-DJUCE_ENABLE_MODULE_SOURCE_GROUPS=ON
		-DJUCE_COPY_PLUGIN_AFTER_BUILD=OFF
		-DJUCE_WEB_BROWSER=$(usex webkit)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use extras; then
		if [[ -f "${S}/extras/Projucer/dest/Linux/Projucer.desktop" ]]; then
			domenu "${S}/extras/Projucer/dest/Linux/Projucer.desktop"
			doicon "${S}/extras/Projucer/Graphics/juce_icon.png"
		else
			newicon "${S}/help/img/juce_icon.png" Projucer.png
			make_desktop_entry Projucer Projucer Projucer "Development;IDE;"
		fi
	fi

	if use doc; then
		[[ -d "${BUILD_DIR}/docs" ]] && dodoc -r "${BUILD_DIR}/docs/html"
	fi
}
