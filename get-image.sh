image_name="ubuntu-22.04.5-live-server-amd64.iso"
download_url="https://releases.ubuntu.com/jammy/$image_name"

if command -v wget > /dev/null; then
  wget "$download_url"
elif command -v curl > /dev/null; then
  curl -O "$download_url"
fi

chmod uo+rx "./$image_name"

