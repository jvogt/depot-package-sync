# Depot Package Sync Tool
This tool will help you sync specific packages from the public depot to an onprem depot.

## Installation
```
hab studio enter
hab pkg install jvogt/depot-package-sync -b
```

## Usage
```
hab studio enter
hab pkg install jvogt/depot-package-sync -b
TOKEN="abcd1234..."
URL="https://jv-hab-depot.chef-demo.com"
depot-package-sync --onprem-token "${TOKEN}" --onprem-url "${URL}" --package <package ident>
```

## Example of performing a bulk sync from a file
```
hab studio enter
hab pkg install jvogt/depot-package-sync -b
TOKEN="abcd1234..."
URL="https://jv-hab-depot.chef-demo.com"
while read PACKAGE; do 
  depot-package-sync --onprem-token "${TOKEN}" --onprem-url "${URL}" --package $PACKAGE
done < workshop-packages
```