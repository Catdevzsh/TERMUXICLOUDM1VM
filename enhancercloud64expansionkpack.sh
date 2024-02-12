#!/bin/bash
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit
fi

# iCloudManager1.0FT.sh
#!/bin/bash
# Check if script is running as root, if not, re-run it with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Running script with sudo..."
    sudo "$0" "$@"
    exit
fi

# Define local and iCloud directories
LOCAL_DIR="$HOME"
ICLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

# List of directories to move
DIRS=("Documents" "Desktop" "Downloads" "Pictures" "Music" "Movies")

# Move directories and create symbolic links
for dir in "${DIRS[@]}"; do
    # Check if the directory exists in the local directory and not yet in iCloud
    if [ -d "$LOCAL_DIR/$dir" ] && [ ! -L "$LOCAL_DIR/$dir" ]; then
        # Check if the directory already exists in iCloud, if so, append a timestamp to avoid overwriting
        if [ -d "$ICLOUD_DIR/$dir" ]; then
            TIMESTAMP=$(date +%Y%m%d%H%M%S)
            mv "$LOCAL_DIR/$dir" "$ICLOUD_DIR/${dir}_$TIMESTAMP"
        else
            mv "$LOCAL_DIR/$dir" "$ICLOUD_DIR/"
        fi
        # Create a symbolic link from the original location to the new location in iCloud
        ln -s "$ICLOUD_DIR/$dir" "$LOCAL_DIR/$dir"
    fi
done

echo "Directories moved and linked to iCloud."

# Reminder to manually adjust iCloud settings
echo "Please manually adjust your iCloud settings to ensure Desktop & Documents folders are syncing if they weren't already."
