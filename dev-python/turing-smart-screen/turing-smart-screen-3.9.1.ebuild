# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..12} )
inherit python-r1 systemd

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mathoudebine/turing-smart-screen-python.git"
else
	SRC_URI="
		https://github.com/mathoudebine/turing-smart-screen-python/archive/refs/tags/${PV}.tar.gz
			-> ${P}.tar.gz
	"
	KEYWORDS="-* ~amd64"
fi

DESCRIPTION="A Python system monitor program and an abstraction library for small IPS USB-C (UART) displays."
HOMEPAGE="https://github.com/mathoudebine/turing-smart-screen-python"

LICENSE="MIT"
SLOT="0"
IUSE="systemd test"
RESTRICT="!test? ( test )"

RDEPEND="systemd? ( sys-apps/systemd:= )
	>=dev-python/ping3-4.0.4[${PYTHON_USEDEP}]
	>=dev-python/uptime-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/pyserial-3.5-r2[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.2[${PYTHON_USEDEP}]
	>=dev-python/psutil-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/pystray-0.19.5[${PYTHON_USEDEP}]
	>=dev-python/babel-2.17.0[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.18.10[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.3[${PYTHON_USEDEP}]
	>=dev-python/pyinstaller-6.12.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-2.2.3[${PYTHON_USEDEP}]
	>=dev-python/pyamdgpuinfo-2.1.6[${PYTHON_USEDEP}]
	>=dev-python/gputil-1.0.4[${PYTHON_USEDEP}]
"
#	>=dev-python/pmw-2.1.1[${PYTHON_USEDEP}]"

S="${WORKDIR}/turing-smart-screen-python-${PV}"

src_install() {
#	newinitd "${FILESDIR}/turing-smart-screen.initd" turing-smart-screen
#        if use systemd; then
#                systemd_newunit "${FILESDIR}/turing-smart-screen.service-1" turing-smart-screen.service
#                systemd_install_serviced "${FILESDIR}/turing-smart-screen.service.conf"
#        fi
#       cp "${FILESDIR}/turing-smart-screen.confd" "${T}/turing-smart-screen" || die

        insinto /opt/turing-smart-screen-python/
        doins -r *
#        insopts -m0755

#        use !test || rm "${ED}"/opt/${PN}/*_test || die
}

pkg_postinst() {
	if use systemd; then
		systemd_newunit "${FILESDIR}"/turing-smart-screen.service-1 turing-smart-screen.service
                systemd_install_serviced "${FILESDIR}"/turing-smart-screen.service.conf
        else
		newconfd "${FILESDIR}"/turing-smart-screen.conf.d turing-smart-screen
		newinitd "${FILESDIR}"/turing-smart-screen.initd turing-smart-screen
	fi

	ewarn ""
	ewarn "Configure your screen first:"
	ewarn "python3 /opt/turing-smart-screen-python/configure.py"
	ewarn "and launch service:"
	ewarn "rc-service start turing-smart-screen"
	ewarn "ou systemctl start turing-smart-screen.service"
	ewarn ""
}

#distutils_enable_tests pytest
