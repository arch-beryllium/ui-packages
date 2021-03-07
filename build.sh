#!/bin/bash

tmpdir=$(mktemp -d)
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT

branch="arm-unstable"
arch="aarch64"

# To always use an up-to-date mirror download the page, extract the columns of 'green' mirrors, and finally extract the url of the first one
url=$(curl https://repo.manjaro.org | hxnormalize -x | hxselect -s "\n" "tr.green a" | sed -e "s/.*>\(.*\)<\/a>/\1/" | head -n 1)
baseurl="http://$url/$branch"

for repo in extra community kde-unstable; do
  wget "$baseurl/$repo/$arch/$repo.db" -O "$tmpdir/$repo.db"
  mkdir -p "$tmpdir/$repo"
  tar -xzf "$tmpdir/$repo.db" -C "$tmpdir/$repo" >/dev/null 2>&1
done

for ui in "plasma-mobile" "lomiri" "phosh"; do
  IFS=$'\n' read -d '' -r -a packages <"$ui.packages"
  mkdir -p repo/$ui

  for packageCombo in "${packages[@]}"; do
    pkgfile=("$tmpdir/$packageCombo-"*/desc)
    # shellcheck disable=SC2128
    if [ ! -f "$pkgfile" ]; then
      echo "Package not found: $packageCombo"
      exit 1
    fi

    # shellcheck disable=SC2128
    IFS=$'\n' read -d '' -r -a lines <"$pkgfile"
    filename=""
    packager=""
    for i in "${!lines[@]}"; do
      line="${lines[$i]}"
      if [ "$line" == "%FILENAME%" ]; then
        filename="${lines[$i + 1]}"
      elif [ "$line" == "%PACKAGER%" ]; then
        packager="${lines[$i + 1]}"
      fi
      if [ -n "$filename" ] && [ -n "$packager" ]; then
        break
      fi
    done
    if [[ "$packager" == *"Arch Linux ARM Build System"* ]]; then
      echo "Package $packageCombo is already provided by ALARM"
      exit 1
    fi
    if [ ! -f "repo/$ui/$filename" ]; then
      wget "$baseurl/$(dirname "$packageCombo")/$arch/$filename" -O "repo/$ui/$filename"
      repo-add -R -n -p "repo/$ui/$ui.db.tar.xz" "repo/$ui/$filename"
    fi
  done
done
