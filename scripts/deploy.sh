#!/bin/bash

# ============================================
# Automated Deployment Script
# Sets up entire cloud storage from scratch
# ============================================

BUCKET_NAME="cloud-storage-ayomide"
REGION="us-east-1"
LOG_FILE="/tmp/storage.log"

# Logging function
# Logging function
log() {
    mkdir -p "$(dirname $LOG_FILE)"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE 2>/dev/null || echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

echo "============================================"
echo "   Cloud Storage Automated Deployment"
echo "============================================"

# ============================================
# Step 1 — Check AWS CLI is installed
# ============================================
log "Checking AWS CLI installation..."
if ! command -v aws &> /dev/null; then
    log "ERROR: AWS CLI is not installed"
    echo "Please install AWS CLI first"
    exit 1
fi
log "AWS CLI is installed"
echo "AWS CLI check passed"

# ============================================
# Step 2 — Check AWS credentials
# ============================================
log "Checking AWS credentials..."
aws sts get-caller-identity &> /dev/null
if [ $? -ne 0 ]; then
    log "ERROR: AWS credentials not configured"
    echo "Please run aws configure first"
    exit 1
fi
log "AWS credentials verified"
echo "AWS credentials check passed"

# ============================================
# Step 3 — Create S3 Bucket
# ============================================
log "Creating S3 bucket: $BUCKET_NAME"
echo "Creating S3 bucket..."

# Check if bucket already exists
aws s3 ls "s3://$BUCKET_NAME" &> /dev/null
if [ $? -eq 0 ]; then
    log "Bucket $BUCKET_NAME already exists, skipping creation"
    echo "Bucket already exists, skipping..."
else
    aws s3api create-bucket \
        --bucket $BUCKET_NAME \
        --region $REGION
    log "Bucket $BUCKET_NAME created successfully"
    echo "Bucket created successfully"
fi

# ============================================
# Step 4 — Enable Public Access
# ============================================
log "Configuring bucket settings..."
aws s3api put-bucket-versioning \
    --bucket $BUCKET_NAME \
    --versioning-configuration Status=Enabled
log "Versioning enabled on $BUCKET_NAME"
echo "Bucket versioning enabled"

# ============================================
# Step 5 — Create test file and upload
# ============================================
log "Creating and uploading test file..."
echo "Cloud Storage Setup Complete - $(date)" > ../test-deployment.txt
aws s3 cp ../test-deployment.txt "s3://$BUCKET_NAME/test-deployment.txt"
log "Test file uploaded successfully"
echo "Test file uploaded"

# ============================================
# Step 6 — Verify deployment
# ============================================
log "Verifying deployment..."
echo ""
echo "Files in your bucket:"
echo "---------------------"
aws s3 ls "s3://$BUCKET_NAME"
log "Deployment verified successfully"

echo ""
echo "============================================"
echo "   Deployment Complete!"
echo "   Bucket: $BUCKET_NAME"
echo "   Region: $REGION"
echo "   Logs:   $LOG_FILE"
echo "============================================"
log "Automated deployment completed successfully"