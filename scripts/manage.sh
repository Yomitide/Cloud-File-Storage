#!/bin/bash

# ============================================
# Cloud File Storage Manager
# Using AWS S3
# ============================================

BUCKET_NAME="cloud-storage-ayomide"
REGION="us-east-1"
LOG_FILE="../logs/storage.log"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

# ============================================
# 1. CREATE BUCKET
# ============================================
create_bucket() {
    log "Creating S3 bucket: $BUCKET_NAME"
    aws s3api create-bucket \
        --bucket $BUCKET_NAME \
        --region $REGION
    log "Bucket $BUCKET_NAME created successfully"
}

# ============================================
# 2. UPLOAD FILE
# ============================================
upload_file() {
    read -p "Enter the full path of the file to upload: " FILE_PATH
    if [ ! -f "$FILE_PATH" ]; then
        log "ERROR: File $FILE_PATH not found"
        echo "File not found!"
        return
    fi
    FILE_NAME=$(basename "$FILE_PATH")
    aws s3 cp "$FILE_PATH" "s3://$BUCKET_NAME/$FILE_NAME"
    log "Uploaded $FILE_NAME to s3://$BUCKET_NAME"
    echo "File uploaded successfully!"
}

# ============================================
# 3. DOWNLOAD FILE
# ============================================
download_file() {
    read -p "Enter the filename to download: " FILE_NAME
    read -p "Enter destination folder (e.g. /c/Users/Ayomide/Downloads): " DEST
    aws s3 cp "s3://$BUCKET_NAME/$FILE_NAME" "$DEST/$FILE_NAME"
    log "Downloaded $FILE_NAME from s3://$BUCKET_NAME to $DEST"
    echo "File downloaded successfully!"
}

# ============================================
# 4. LIST FILES
# ============================================
list_files() {
    log "Listing all files in $BUCKET_NAME"
    echo "Files in your cloud storage:"
    echo "-----------------------------"
    aws s3 ls "s3://$BUCKET_NAME"
    log "Listed files in $BUCKET_NAME"
}

# ============================================
# 5. DELETE FILE
# ============================================
delete_file() {
    read -p "Enter the filename to delete: " FILE_NAME
    aws s3 rm "s3://$BUCKET_NAME/$FILE_NAME"
    log "Deleted $FILE_NAME from s3://$BUCKET_NAME"
    echo "File deleted successfully!"
}

# ============================================
# 6. DELETE BUCKET
# ============================================
delete_bucket() {
    log "Deleting bucket $BUCKET_NAME"
    aws s3 rm "s3://$BUCKET_NAME" --recursive
    aws s3api delete-bucket --bucket $BUCKET_NAME --region $REGION
    log "Bucket $BUCKET_NAME deleted successfully"
    echo "Bucket deleted successfully!"
}

# ============================================
# MAIN MENU
# ============================================
while true; do
    echo ""
    echo "============================="
    echo "   Cloud File Storage Menu   "
    echo "============================="
    echo "1. Create Storage Bucket"
    echo "2. Upload File"
    echo "3. Download File"
    echo "4. List Files"
    echo "5. Delete File"
    echo "6. Delete Bucket"
    echo "7. Exit"
    echo "============================="
    read -p "Choose an option (1-7): " CHOICE

    case $CHOICE in
        1) create_bucket ;;
        2) upload_file ;;
        3) download_file ;;
        4) list_files ;;
        5) delete_file ;;
        6) delete_bucket ;;
        7) log "Exiting storage manager"
           echo "Goodbye!"
           exit 0 ;;
        *) echo "Invalid option, please choose 1-7" ;;
    esac
done