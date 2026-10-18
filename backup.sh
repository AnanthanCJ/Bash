run() {
    mkdir -p backup

    for f in "$@"; do
        if [ -f "$f" ]; then
            cp "$f" backup/
            echo "copied $f"
        else
            echo "skipped $f"
        fi
    done
}

run "$@"

