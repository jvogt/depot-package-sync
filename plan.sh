pkg_name=depot-package-sync
pkg_origin=jvogt
pkg_version=0.1.0
pkg_description="Helps sync from public to private depot"
pkg_maintainer="Jeff Vogt <jdvogt@gmail.com>"
pkg_license=("Apache-2.0")
pkg_bin_dirs=(bin)

do_build() {
  return 0
}

do_install() {
  mkdir -p $pkg_prefix/bin
  cp $PLAN_CONTEXT/depot-package-sync.sh $pkg_prefix/bin/depot-package-sync
  chmod +x $pkg_prefix/bin/depot-package-sync
  cp $PLAN_CONTEXT/workshop-packages $PLAN_CONTEXT/README.md $pkg_prefix/
}
