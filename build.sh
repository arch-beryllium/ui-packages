#!/bin/bash

tmpdir=$(mktemp -d)
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT

baseurl="https://mirror.alpix.eu/manjaro/arm-unstable"

for repo in extra community kde-unstable; do
  wget "$baseurl/$repo/aarch64/$repo.db" -O "$tmpdir/$repo.db"
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
      wget "$baseurl/$(dirname "$packageCombo")/aarch64/$filename" -O "repo/$ui/$filename"
      repo-add -R -n -p "repo/$ui/$ui.db.tar.xz" "repo/$ui/$filename"
    fi
  done
done
