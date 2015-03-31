magnet-info() {
	if [ $# -eq 1 ]; then
		hash=$(echo "$1" | grep -oP "(?<=btih:).*?(?=&)")
		echo "Magnet hash: $hash"
		aria2c --bt-metadata-only=true --bt-save-metadata=true "$1"
		aria2c "${hash,,}.torrent" -S
	else
		echo "Usage: magnet-info <magnet link>"
	fi
}

