# Usage:
```
TOKEN="abcd1234..."
URL="https://jv-hab-depot.chef-demo.com"
depot-package-sync --onprem-token "${TOKEN}" --onprem-url "${URL}" --package <package ident>
```

# Bulk:
```
TOKEN="abcd1234..."
URL="https://jv-hab-depot.chef-demo.com"
while read PACKAGE; do 
  depot-package-sync --onprem-token "${TOKEN}" --onprem-url "${URL}" --package $PACKAGE
done < workshop-packages
```