EAPI=8
PYTHON_COMPAT=( python3_{8..13})
inherit desktop python-any-r1 toolchain-funcs qmake-utils xdg-utils

MY_PV="${PV/.}"

DESCRIPTION="Multiple Arcade Machine Emulator + Multi Emulator Super System (MESS)"
HOMEPAGE="http://mamedev.org/"
SRC_URI="https://github.com/mamedev/mame/archive/mame${MY_PV}.tar.gz -> mame-${PV}.tar.gz"

LICENSE="GPL-2+ BSD-2 MIT CC0-1.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="alsa debug opengl openmp tools"

RDEPEND="dev-db/sqlite:3
	 dev-libs/expat
	 media-libs/fontconfig
	 media-libs/flac
	 media-libs/libsdl2[joystick,opengl?,sound,video,X]
	 media-libs/libpulse
	 media-libs/portaudio
	 media-libs/sdl2-ttf
	 sys-libs/zlib
	 virtual/jpeg:0
	 virtual/opengl
	 alsa? ( media-libs/alsa-lib
		 media-libs/portmidi )
	 debug? ( dev-qt/qtcore:6
		  dev-qt/qtgui:6
		  dev-qt/qtwidgets:6 )
	 x11-libs/libX11
	 x11-libs/libXinerama
	 dev-libs/libutf8proc
	 media-libs/glm
	 dev-libs/rapidjson
	 dev-libs/pugixml
	 dev-cpp/asio
	 app-arch/zstd
	 dev-db/sqlite"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto"
S=${WORKDIR}/mame-mame${MY_PV}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
        eapply -p1 "${FILESDIR}"/sdlmame-0.282-ffightae_cps2.patch
        eapply_user
        default
}

src_configure() {
	filter-lto
}

src_compile() {
	VERBOSE=1 NOWERROR=1 OPTIMIZE=2 \
	QT_SELECT=qt6 QT_HOME="$(qt6_get_libdir)/qt6" \
	ARCHOPTS_C="-mtune=native -pipe" ARCHOPTS_CXX="$ARCHOPTS_C" \
	USE_SYSTEM_LIB_ASIO=1 \
	USE_SYSTEM_LIB_EXPAT=1 \
	USE_SYSTEM_LIB_ZLIB=1 \
	USE_SYSTEM_LIB_ZSTD=1 \
	USE_SYSTEM_LIB_JPEG=1 \
	USE_SYSTEM_LIB_FLAC=1 \
	USE_SYSTEM_LIB_SQLITE3=1 \
	USE_SYSTEM_LIB_PORTAUDIO=1 USE_SYSTEM_LIB_PORTMIDI=$(usex alsa 1 0) \
	NO_USE_MIDI=$(usex alsa 0 1) \
	USE_SYSTEM_LIB_UTF8PROC=1 \
	USE_SYSTEM_LIB_GLM=1 \
	USE_SYSTEM_LIB_RAPIDJSON=1 \
	USE_SYSTEM_LIB_PUGIXML=1 \
	TOOLS=$(usex tools 1 0) \
	PTR64=$(usex amd64 1 0) \
	DEBUG=$(usex debug 1 0) \
	OPENMP=$(usex openmp 1 0) \
	PYTHON_EXECUTABLE=${PYTHON} \
	OVERRIDE_CC=$(tc-getCC) \
	OVERRIDE_CXX=$(tc-getCXX) \
	OVERRIDE_LD=$(tc-getCXX) \
	ARCH= \
	emake
}

src_install()
{
	MAMEBIN=mame
	dobin $MAMEBIN
	doman docs/man/mame.6

	insinto "/usr/share/${PN}"
	doins -r keymaps hash

	# Create default mame.ini and inject Gentoo settings into it
	#  Note that '~' does not work and '$HOME' must be used
	./${MAMEBIN} -noreadconfig -showconfig > "${T}/mame.ini" || die
	# -- Paths --
	for f in {rom,hash,sample,art,font,crosshair} ; do
		sed -i \
			-e "s:\(${f}path\)[ \t]*\(.*\):\1 \t\t\$HOME/.${PN}/\2;/usr/share/${PN}/\2:" \
			"${T}/mame.ini" || die
	done
	for f in {ctrlr,cheat} ; do
		sed -i \
			-e "s:\(${f}path\)[ \t]*\(.*\):\1 \t\t\$HOME/.${PN}/\2;/etc/${PN}/\2;/usr/share/${PN}/\2:" \
			"${T}/mame.ini" || die
	done
	# -- Directories
	for f in {cfg,nvram,memcard,input,state,snapshot,diff,comment} ; do
		sed -i \
			-e "s:\(${f}_directory\)[ \t]*\(.*\):\1 \t\t\$HOME/.${PN}/\2:" \
			"${T}/mame.ini" || die
	done
	# -- Keymaps --
	sed -i \
		-e "s:\(keymap_file\)[ \t]*\(.*\):\1 \t\t\$HOME/.${PN}/\2:" \
		"${T}/mame.ini" || die
	for f in keymaps/km*.map ; do
		sed -i \
			-e "/^keymap_file/a \#keymap_file \t\t/usr/share/${PN}/keymaps/${f##*/}" \
			"${T}/mame.ini" || die
	done
	insinto "/etc/${PN}"
	doins "${T}/mame.ini"

	insinto "/etc/${PN}"
	doins "${FILESDIR}/vector.ini"

	#dodoc docs/{config,mame,newvideo}.txt
	keepdir \
		"/usr/share/${PN}"/{ctrlr,cheat,roms,samples,artwork,crosshair} \
		"/etc/${PN}"/{ctrlr,cheat}

	if use tools ; then
		for f in castool chdman floptool imgtool jedutil ldresample ldverify romcmp ; do
			newbin ${f} ${PN}-${f}
			newman docs/man/${f}.1 ${PN}-${f}.1
		done
		#newbin ldplayer${suffix} ${PN}-ldplayer
		#newman docs/man/ldplayer.1 ${PN}-ldplayer.1
	fi
}

pkg_postinst() {
	xdg_desktop_database_update

	elog "It is strongly recommended to change either the system-wide"
	elog "  /etc/${PN}/mame.ini or use a per-user setup at ~/.${PN}/mame.ini"
	elog
	if use opengl ; then
		elog "You built ${PN} with opengl support and should set"
		elog "\"video\" to \"opengl\" in mame.ini to take advantage of that"
		elog
		elog "For more info see http://wiki.mamedev.org"
	fi
}

pkg_postrm(){
	xdg_desktop_database_update
}

