#!/bin/bash

set -e

printtag() {
    # GitHub Actions tag format
    echo "::$1::${2-}"
}

begingroup() {
    printtag "group" "$1"
}

endgroup() {
    printtag "endgroup"
}

MACPORTS_VERSION=2.10.3

OS_MAJOR=$(uname -r | cut -f 1 -d .)
OS_ARCH=$(uname -p)

MACPORTS_FILENAME=MacPorts-${MACPORTS_VERSION}-${OS_MAJOR}.tar.bz2

begingroup "Fetching files"
# Download resources in background ASAP but use later.
# Use /usr/bin/curl so that we don't use Homebrew curl.
echo "Fetching MacPorts..."
/usr/bin/curl -fsSLO "https://github.com/macports/macports-ci-files/releases/download/v${MACPORTS_VERSION}/${MACPORTS_FILENAME}" &
curl_mpbase_pid=$!
endgroup


begingroup "Disabling Spotlight"
# Disable Spotlight indexing. We don't need it, and it might cost performance
sudo mdutil -a -i off
endgroup


begingroup "Uninstalling Homebrew"
# Move directories to /opt/*-off
echo "Moving directories..."
sudo mkdir /opt/local-off /opt/homebrew-off
test ! -d /usr/local || /usr/bin/sudo /usr/bin/find /usr/local -mindepth 1 -maxdepth 1 -type d -print -exec /bin/mv {} /opt/local-off/ \;
test ! -d /opt/homebrew || /usr/bin/sudo /usr/bin/find /opt/homebrew -mindepth 1 -maxdepth 1 -type d -print -exec /bin/mv {} /opt/homebrew-off/ \;

# Unlink files
echo "Removing files..."
test ! -d /usr/local || /usr/bin/sudo /usr/bin/find /usr/local -mindepth 1 -maxdepth 1 -type f -print -delete
test ! -d /opt/homebrew || /usr/bin/sudo /usr/bin/find /opt/homebrew -mindepth 1 -maxdepth 1 -type f -print -delete

# Rehash to forget about the deleted files
hash -r
endgroup

begingroup "Selecting Xcode version"
case "$OS_MAJOR" in
    22) sudo xcode-select --switch /Applications/Xcode_14.3.1.app/Contents/Developer
        ;;
    23) sudo xcode-select --switch /Applications/Xcode_15.4.app/Contents/Developer
        ;;
esac
endgroup


begingroup "Installing MacPorts"
# Install MacPorts built by https://github.com/macports/macports-base/tree/master/.github
if ! wait $curl_mpbase_pid; then
    echo "Fetching base failed: $?"
fi
echo "Extracting..."
sudo tar -xpf "${MACPORTS_FILENAME}" -C /
rm -f "${MACPORTS_FILENAME}"
endgroup


begingroup "Configuring MacPorts"
# Set PATH for portindex
source /opt/local/share/macports/setupenv.bash
# CI is not interactive
echo "ui_interactive no" | sudo tee -a /opt/local/etc/macports/macports.conf >/dev/null
# Also try downloading archives from the private server
echo "archive_site_local https://packages-private.macports.org/:tbz2" | sudo tee -a /opt/local/etc/macports/macports.conf >/dev/null
endgroup


begingroup "Running postflight"
# Create macports user
sudo /opt/local/libexec/macports/postflight/postflight
endgroup

begingroup "Syncing ports tree"
sudo /opt/local/bin/port sync
endgroup
