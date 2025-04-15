# Maintainer: Julien de Montmollin <julien@rmbi.ch>
pkgname=cryptoflow
pkgver=1.0.0
pkgrel=1
pkgdesc="Track crypto prices in style and privacy with CryptoFlow"
arch=('x86_64')
url="https://futureofthe.tech"
license=('GPL-3.0')
source=('https://github.com/judemont/cryptoflow/releases/download/v1.0.0/CryptoFlow-v1.0.0-x86_64.AppImage')
noextract=('CryptoFlow-v1.0.0-x86_64.AppImage')
md5sums=('SKIP')
depends=(
    'glibc'
    'gtk3'
    'libnotify'
    'libappindicator-gtk3'
  )

package() {
  install -Dm755 "${srcdir}/CryptoFlow-v1.0.0-x86_64.AppImage" "${pkgdir}/usr/bin/cryptoflow"
  install -Dm644 "${srcdir}/cryptoflow.desktop" "${pkgdir}/usr/share/applications/cryptoflow.desktop"
  install -Dm644 "${srcdir}/cryptoflow_icon.svg" "${pkgdir}/usr/share/pixmaps/cryptoflow_icon.svg"
}
