pkgname=cryptoflow
pkgver=1.0.0
pkgrel=1
pkgdesc="Une petite description"
arch=('x86_64')
url="https://futureofthe.tech"
license=('GPL_3.0')
depends=('glibc' 'gtk3')
source=("https://tonsite.com/myapp-$pkgver.tar.gz")
sha256sums=('SKIP') # à remplacer par le vrai hash

build() {
  cd "$srcdir/$pkgname-$pkgver"
  make
}

package() {
  cd "$srcdir/$pkgname-$pkgver"
  install -Dm755 myapp "$pkgdir/usr/bin/myapp"
}
