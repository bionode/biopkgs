#! /bin/bash -e

dseditgroup -o create nixbld -q

gid=$(dscl . -read /Groups/nixbld | awk '($1 == "PrimaryGroupID:") {print $2 }')

echo "created nixbld group with gid $gid"

for i in $(seq 1 10); do
    user=/Users/nixbld$i
    uid="$((30000 + $i))"
    dscl . create $user
    dscl . create $user RealName "Nix build user $i"
    dscl . create $user PrimaryGroupID "$gid"
    dscl . create $user UserShell /usr/bin/false
    dscl . create $user NFSHomeDirectory /var/empty
    dscl . create $user UniqueID "$uid"
    dseditgroup -o edit -a nixbld$i -t user nixbld
    echo "created nixbld$i user with uid $uid"
done