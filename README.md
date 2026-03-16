# Cloud File Storage System

## Overview
A cloud-based file storage system built with AWS S3 and Bash scripting.
Similar to Dropbox/Google Drive - allows users to upload, download, list and manage files.

## Tools Used
- AWS S3 - Cloud storage
- AWS CLI - Command line interface
- Bash Scripting - Automation
- GitHub Actions - CI/CD pipeline

## Features
- Create S3 storage bucket
- Upload files to cloud
- Download files from cloud
- List all files in storage
- Delete files from storage
- Automated logging of all operations
- Automated deployment with GitHub Actions

## How to Run Locally
1. Install AWS CLI
2. Run aws configure with your credentials
3. Run the management script:
cd scripts
chmod +x manage.sh
./manage.sh

## How to Deploy Automatically
Push any change to main branch - GitHub Actions handles everything automatically.

## Project Structure
- scripts/manage.sh - Interactive file storage manager
- scripts/deploy.sh - Automated deployment script
- logs/storage.log - Operation logs
- screenshots/ - Deployment screenshots

## Screenshots
See screenshots folder for deployment proof.