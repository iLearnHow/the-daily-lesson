#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# --- Configuration ---
BACKUP_DIR="backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILENAME="the-daily-lesson-backup-$TIMESTAMP"
TEMP_BACKUP_PATH="$BACKUP_DIR/$BACKUP_FILENAME"

# --- Main ---
echo "Starting project backup..."

# 1. Create the main backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# 2. Create a temporary directory for this specific backup
mkdir -p "$TEMP_BACKUP_PATH"

# 3. Create a full backup of the git repository
echo "  - Bundling git repository..."
git bundle create "$TEMP_BACKUP_PATH/repo.bundle" --all

# 4. Copy critical environment files
echo "  - Copying environment files..."
if [ -f ".env" ]; then
    cp .env "$TEMP_BACKUP_PATH/.env"
else
    echo "    - Warning: .env file not found. Skipping."
fi
if [ -f ".env.local" ]; then
    cp .env.local "$TEMP_BACKUP_PATH/.env.local"
fi

# 5. Placeholder for future data (e.g., database dumps, lesson content)
mkdir -p "$TEMP_BACKUP_PATH/data"
echo "This directory is a placeholder for future data backups." > "$TEMP_BACKUP_PATH/data/README.md"

# 6. Compress the backup directory into a single archive
echo "  - Compressing backup..."
tar -czf "$BACKUP_DIR/$BACKUP_FILENAME.tar.gz" -C "$BACKUP_DIR" "$BACKUP_FILENAME"

# 7. Clean up the temporary backup directory
rm -rf "$TEMP_BACKUP_PATH"

# --- Final Message ---
echo "✅ Backup complete!"
echo "Archive created at: $BACKUP_DIR/$BACKUP_FILENAME.tar.gz" 