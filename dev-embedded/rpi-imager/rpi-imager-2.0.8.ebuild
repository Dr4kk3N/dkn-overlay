EAPI=8

inherit cmake

DESCRIPTION="Raspberry Pi Imaging Utility"
HOMEPAGE=https://www.raspberrypi.com/software/
SRC_URI="https://github.com/raspberrypi/rpi-imager/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE=Apache-2.0
SLOT=0
KEYWORDS="amd64 aarch64"
S=$WORKDIR/$P/src

DEPEND="
	dev-qt/qtbase:6
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
       "
