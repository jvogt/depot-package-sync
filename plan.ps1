$pkg_name="depot-package-sync"
$pkg_origin="jvogt"
$pkg_version="0.1.0"
$pkg_description="Helps sync from public to private depot"
$pkg_maintainer="Jeff Vogt <jdvogt@gmail.com>"
$pkg_license=("Apache-2.0")
$pkg_bin_dirs=@('bin')

function invoke-build { }

function invoke-install {
  mkdir $pkg_prefix\bin -force
  copy-item $PLAN_CONTEXT\depot-package-sync.ps1 $pkg_prefix\bin -force
  copy-item $PLAN_CONTEXT\depot-package-sync.bat $pkg_prefix\bin -force
  copy-item $PLAN_CONTEXT\workshop-packages $pkg_prefix\ -force
  copy-item $PLAN_CONTEXT\README.md $pkg_prefix\ -force
}
