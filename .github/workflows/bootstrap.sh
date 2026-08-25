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

MACPORTS_VERSION=${MP_CI_RELEASE:-2.12.6}

OS_MAJOR=$(uname -r | cut -f 1 -d .)
OS_ARCH=$(uname -p)

case "$OS_MAJOR" in
    25)
        macosvers=26
        macosname=Tahoe
        ;;
    *)
        echo "Unknown macOS version"
        exit 1
        ;;
esac

MACPORTS_FILENAME=MacPorts-${MACPORTS_VERSION}-${macosvers}-${macosname}.pkg

begingroup "Fetching files"
# Download resources in background ASAP but use later.
# Use /usr/bin/curl so that we don't use Homebrew curl.
echo "Fetching MacPorts..."
/usr/bin/curl -fsSLO "https://github.com/macports/macports-base/releases/download/v${MACPORTS_VERSION}/${MACPORTS_FILENAME}" &
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
    23) sudo xcode-select --switch /Applications/Xcode_16.2.app/Contents/Developer
        ;;
    25) sudo xcode-select --switch /Applications/Xcode_26.4.app/Contents/Developer
        ;;
esac
endgroup


begingroup "Installing MacPorts"
# Set up config files to prevent the postflight script from spending a
# lot of time running selfupdate.
sudo mkdir -p /opt/local/etc/macports
sudo cp ./guide/.github/workflows/macports.conf /opt/local/etc/macports
sudo chown root:wheel /opt/local/etc/macports/macports.conf
sudo chmod 0644 /opt/local/etc/macports/macports.conf
echo "https://github.com/macports/macports-base/releases/tag/v${MACPORTS_VERSION}" > ./RELEASE_URL
echo "release_version_urls file://${PWD}/RELEASE_URL" | sudo tee -a /opt/local/etc/macports/macports.conf >/dev/null
# Install MacPorts
if ! wait $curl_mpbase_pid; then
    echo "Fetching base failed: $?"
fi
sudo installer -package "${MACPORTS_FILENAME}" -target /
rm -f "${MACPORTS_FILENAME}"
endgroup


begingroup "Configuring MacPorts"
# Set PATH for portindex
source /opt/local/share/macports/setupenv.bash
endgroup
