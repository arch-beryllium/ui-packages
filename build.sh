#!/bin/bash
packages=()
packages+=("attica-git")
packages+=("baloo-git")
packages+=("bluedevil-git")
packages+=("bluez-qt-git")
packages+=("bootsplash-systemd")
packages+=("bootsplash-theme-kde")
packages+=("breeze-git")
packages+=("breeze-icons-git")
packages+=("buho-git")
packages+=("calindori-git")
packages+=("discover-git")
packages+=("extra-cmake-modules-git")
packages+=("frameworkintegration-git")
packages+=("index-git")
packages+=("inxi")
packages+=("kaccounts-integration-git")
packages+=("kaccounts-providers-git")
packages+=("kactivities-git")
packages+=("kactivities-stats-git")
packages+=("kactivitymanagerd-git")
packages+=("kalk-git")
packages+=("karchive-git")
packages+=("kauth-git")
packages+=("kbookmarks-git")
packages+=("kcalendarcore-git")
packages+=("kclock-git")
packages+=("kcmutils-git")
packages+=("kcodecs-git")
packages+=("kcompletion-git")
packages+=("kconfig-git")
packages+=("kconfigwidgets-git")
packages+=("kcontacts-git")
packages+=("kcoreaddons-git")
packages+=("kcrash-git")
packages+=("kdbusaddons-git")
packages+=("kde-cli-tools-git")
packages+=("kdeclarative-git")
packages+=("kdeconnect-git")
packages+=("kdecoration-git")
packages+=("kded-git")
packages+=("kdelibs4support-git")
packages+=("kdesignerplugin-git")
packages+=("kdesu-git")
packages+=("kdnssd-git")
packages+=("kdoctools-git")
packages+=("kemoticons-git")
packages+=("keysmith-git")
packages+=("kfilemetadata-git")
packages+=("kglobalaccel-git")
packages+=("kguiaddons-git")
packages+=("kholidays-git")
packages+=("ki18n-git")
packages+=("kiconthemes-git")
packages+=("kidletime-git")
packages+=("kinit-git")
packages+=("kio-extras-git")
packages+=("kio-git")
packages+=("kirigami-addons-git")
packages+=("kirigami2-git")
packages+=("kitemmodels-git")
packages+=("kitemviews-git")
packages+=("kjobwidgets-git")
packages+=("kjs-git")
packages+=("knewstuff-git")
packages+=("knotifications-git")
packages+=("knotifyconfig-git")
packages+=("koko")
packages+=("kongress-git")
packages+=("kpackage-git")
packages+=("kparts-git")
packages+=("kpeople-git")
packages+=("kpeoplesink-git")
packages+=("kpeoplevcard-git")
packages+=("kplotting-git")
packages+=("kpty-git")
packages+=("kpublictransport-git")
packages+=("kquickcharts-git")
packages+=("kquickimageeditor-git")
packages+=("kquicksyntaxhighlighter-git")
packages+=("krecorder-git")
packages+=("krunner-git")
packages+=("kscreen-git")
packages+=("kscreenlocker-git")
packages+=("kservice-git")
packages+=("ktexteditor-git")
packages+=("ktextwidgets-git")
packages+=("ktrip-git")
packages+=("kunitconversion-git")
packages+=("kuserfeedback-git")
packages+=("kwallet-git")
packages+=("kwallet-pam-git")
packages+=("kwayland-git")
packages+=("kwayland-integration-git")
packages+=("kwayland-server-git")
packages+=("kweather-git")
packages+=("kwidgetsaddons-git")
packages+=("kwin-git")
packages+=("kwindowsystem-git")
packages+=("kxmlgui-git")
packages+=("libkgapi-git")
packages+=("libkscreen-git")
packages+=("libksysguard-git")
packages+=("libofono-qt")
packages+=("libqofono-qt5")
packages+=("libquotient-git")
packages+=("maliit-framework-git")
packages+=("maliit-keyboard-git")
packages+=("mauikit-git")
packages+=("milou-git")
packages+=("modemmanager-qt-git")
packages+=("mplus-font")
packages+=("neochat-git")
packages+=("networkmanager-qt-git")
packages+=("nota-git")
packages+=("ofonoctl")
packages+=("okular-mobile-git")
packages+=("oxygen-git")
packages+=("plasma-angelfish-git")
packages+=("plasma-camera-git")
packages+=("plasma-dialer-git")
packages+=("plasma-framework-git")
packages+=("plasma-integration-git")
packages+=("plasma-mobile-nm-git")
packages+=("plasma-mobile-settings")
packages+=("plasma-nano-git")
packages+=("plasma-pa-git")
packages+=("plasma-phone-components-git")
packages+=("plasma-phonebook-git")
packages+=("plasma-pix-git")
packages+=("plasma-settings-git")
packages+=("plasma-wayland-protocols-git")
packages+=("plasma-wayland-session-git")
packages+=("plasma-workspace-git")
packages+=("plasma-workspace-wallpapers-git")
packages+=("plymouth-shim")
packages+=("polkit-kde-agent-git")
packages+=("powerdevil-git")
packages+=("presage-git")
packages+=("prison-git")
packages+=("purpose-git")
packages+=("qmlkonsole-git")
packages+=("qqc2-breeze-style-git")
packages+=("qqc2-desktop-style-git")
packages+=("qt5-es2-base")
packages+=("qt5-es2-declarative")
packages+=("qt5-es2-multimedia")
packages+=("qt5-es2-wayland")
packages+=("qt5-es2-xcb-private-headers")
packages+=("qt5-pim-git")
packages+=("signon-kwallet-extension-git")
packages+=("solid-git")
packages+=("sonnet-git")
packages+=("spacebar-git")
packages+=("syntax-highlighting-git")
packages+=("telepathy-ofono")
packages+=("threadweaver-git")
packages+=("vvave-git")
packages+=("xdg-desktop-portal-kde-git")
packages+=("zswap-arm")

mkdir -p repo
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
        if [ ! -f "repo/$filename" ]; then
          wget "$baseurl/$filename" -O "repo/$filename"
          repo-add -R -n -p "repo/plasma-mobile.db.tar.xz" "repo/$filename"
        fi
      fi
    done
  done
done

rm -rf "$tmpdir"
