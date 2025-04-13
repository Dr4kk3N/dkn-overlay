# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..13} )

inherit git-r3 python-any-r1 desktop xdg wrapper

DESCRIPTION="Firestorm SL Viewer"
HOMEPAGE="https://firestorm.org"
IUSE="fmod kde lto"

SLOT="0"
KEYWORDS="~amd64"
LICENSE="GPL-2-with-Linden-Lab-FLOSS-exception"

BDEPEND="${BDEPEND}
	games-simulation/llsd
	dev-build/cmake"

DEPEND="${DEPEND}
	media-libs/libpng
	sys-libs/zlib[abi_x86_64,abi_x86_32]
	gui-libs/gtk
	media-libs/mesa
	media-libs/libsdl2
	dev-perl/XML-XPath
	media-video/vlc
	dev-python/pip
	dev-python/virtualenv
	"

RDEPEND="${DEPEND}
	net-dns/libidn-compat
	kde? ( kde-plasma/kde-cli-tools )"

# https://www.fmod.com/download#fmodstudiosuite
# register or login
# FMOD Engine -> Linux -> Download
# sudo mv ~/Downloads/fmod* /var/
: ${FMOD_VERSION:="2.02.20"}
: ${FMOD_FILE_PATH="/var"}

FMOD_DIR="${WORKDIR}/fmod"
FMOD_VERSION_NO_DOTS=${FMOD_VERSION//./}
FMOD_FILE="${FMOD_FILE_PATH}/fmodstudioapi${FMOD_VERSION_NO_DOTS}linux.tar.gz"
FMOD_OUT_FILE="${FMOD_DIR}/fmodstudio-${FMOD_VERSION}-linux64-0.tar.bz2"

src_unpack() {
	if use lto; then
		ewarn "LTO only works fine with clang and will lead to problems with GCC!"
	fi

	EGIT_REPO_URI="https://github.com/FirestormViewer/fs-build-variables.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/fs-build-variables"
	git-r3_src_unpack

	if use fmod; then
		EGIT_REPO_URI="https://github.com/FirestormViewer/3p-fmodstudio.git"
		EGIT_BRANCH="main"
		EGIT_SUBMODULES=()
		EGIT_CHECKOUT_DIR="${FMOD_DIR}"
		git-r3_src_unpack
		if [[ -f "${FMOD_FILE}" ]]; then
			mkdir -p "${FMOD_DIR}/fmodstudio"
			cp "${FMOD_FILE}" "${FMOD_DIR}/fmodstudio/" || die
		else
			die "can't find FMOD_FILE at ${FMOD_FILE}, please download from https://www.fmod.com/download#fmodstudiosuite"
		fi
	fi

	export AUTOBUILD_VARIABLES_FILE="${WORKDIR}/fs-build-variables/variables"

	EGIT_REPO_URI="https://github.com/FirestormViewer/phoenix-firestorm.git"
	EGIT_BRANCH="master"

	EGIT_SUBMODULES=( '*' )
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"

	git-r3_src_unpack

	cd "${S}"
	virtualenv ".venv" -p python3 || die "failed to create virtual env"
	source .venv/bin/activate
	#pip3 install --upgrade llbase certifi autobuild || die
	pip install -r requirements.txt || die

	if use fmod; then
		cd "${FMOD_DIR}"
		AUTOBUILD_BUILD_ID=0 autobuild build -A64 || die "failed to compile fmod studio"
		AUTOBUILD_BUILD_ID=0 autobuild package -A64 || die "failed to package fmod studio"
		cd "${S}"
		if [[ -f ${FMOD_OUT_FILE} ]]; then
			autobuild installables edit -a file://${FMOD_OUT_FILE} || die "failed to add fmod to autobuild.xml"
		else
			eerror "${FMOD_OUT_FILE} missing"
			die "failed to find compiled fmod studio"
		fi
	fi

	sed -i '/if (NOT GCC_DISABLE_FATAL_WARNINGS)$/d;/    set(GCC_WARNINGS "${GCC_WARNINGS} -Werror")$/d;/endif (NOT GCC_DISABLE_FATAL_WARNINGS)$/d' "${S}/indra/cmake/00-Common.cmake" || die

	autobuild configure -A 64 -c ReleaseFS_open -- \
		-DLL_TESTS:BOOL=FALSE \
		-DLLCOREHTTP_TESTS=FALSE \
		-DDISABLE_FATAL_WARNINGS=ON \
		-DENABLE_MEDIA_PLUGINS=ON \
		-DUSE_VLC=ON \
		-DUSE_X11=ON \
		-DUSE_CEF=ON \
		-DUSE_OPENAL=ON \
		-DEXAMPLEPLUGIN=OFF \
		-DREVISION_FROM_VCS=ON \
		-DUSE_DISCORD=OFF \
		-DUSE_LTO=$(usex lto ON OFF) \
		-DUSESYSTEMLIBS=OFF \
		-DUSE_FMODSTUDIO=$(usex fmod ON OFF) || die "configure failed"

	autobuild build -A 64 -c ReleaseFS_open --no-configure || die "build failed"
	
	export XZ_DEFAULTS="-T0"
	autobuild build -A 64 -c ReleaseFS_open -- --package || die "package failed"
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	insinto "/opt/firestorm-install"
	doins -r "${WORKDIR}/${P}"/build-linux-x86_64/newview/packaged/*

	fperms +x /opt/firestorm-install/bin/llplugin/chrome-sandbox
	fperms +x /opt/firestorm-install/bin/llplugin/dullahan_host
	fperms +x /opt/firestorm-install/bin/firestorm-bin
	fperms +x /opt/firestorm-install/bin/ALPlugin
	fperms +x /opt/firestorm-install/bin/SLVoice
	fperms +x /opt/firestorm-install/firestorm
	fperms -R +x /opt/firestorm-install/etc/
}

pkg_postinst() {
	xdg_pkg_postinst
}
