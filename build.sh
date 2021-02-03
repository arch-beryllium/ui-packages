#!/bin/bash
for ui in "plasma-mobile"; do
  IFS=$'\n' read -d '' -r -a packages <"$ui.packages"
  mkdir -p repo/$ui
  tmpdir=$(mktemp -d)
  for repo in core extra community; do
    baseurl="https://mirror.alpix.eu/manjaro/arm-unstable/$repo/aarch64"
    wget "$baseurl/$repo.db" -O "$tmpdir/$repo.db"
    tar -xzf "$tmpdir/$repo.db" -C "$tmpdir" >/dev/null 2>&1
    for pkgdir in "$tmpdir"/*/; do
      IFS=$'\n' read -d '' -r -a lines <"$pkgdir/desc"
      filename=""
      pkgname=""
      packager=""
      for i in "${!lines[@]}"; do
        line="${lines[$i]}"
        if [ "$line" == "%FILENAME%" ]; then
          filename="${lines[$i + 1]}"
        elif [ "$line" == "%NAME%" ]; then
          pkgname="${lines[$i + 1]}"
        elif [ "$line" == "%PACKAGER%" ]; then
          packager="${lines[$i + 1]}"
        fi
        if [ -n "$filename" ] && [ -n "$pkgname" ] && [ -n "$packager" ]; then
          break
        fi
      done
      for package in "${packages[@]}"; do
        if [ "$package" == "$pkgname" ]; then
          if [[ "$packager" == *"Arch Linux ARM Build System"* ]]; then
            echo "Package $package is already provided by ALARM"
            continue
          fi
          if [ ! -f "repo/$ui/$filename" ]; then
            wget "$baseurl/$filename" -O "repo/$ui/$filename"
            repo-add -R -n -p "repo/$ui/$ui.db.tar.xz" "repo/$ui/$filename"
          fi
        fi
      done
    done
  done

  rm -rf "$tmpdir"
done
