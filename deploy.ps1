# TICKETIFY Google Cloud Deployment Script (PowerShell)
# Make sure you have gcloud CLI installed and authenticated

$ErrorActionPreference = "Stop"

Write-Host "Starting TICKETIFY deployment to Google Cloud..." -ForegroundColor Green

# Check if gcloud is installed
$gcloudExists = Get-Command gcloud -ErrorAction SilentlyContinue
if (-not $gcloudExists) {
    Write-Host "gcloud CLI is not installed. Please install it first." -ForegroundColor Red
    Write-Host "Download from: https://cloud.google.com/sdk/docs/install" -ForegroundColor Yellow
    exit 1
}

# Get project ID
$PROJECT_ID = gcloud config get-value project --quiet
if (-not $PROJECT_ID) {
    Write-Host "No Google Cloud project set. Please run: gcloud config set project YOUR_PROJECT_ID" -ForegroundColor Red
    exit 1
}

Write-Host "Using Google Cloud Project: $PROJECT_ID" -ForegroundColor Green

# Enable required APIs
Write-Host "Enabling required Google Cloud APIs..." -ForegroundColor Yellow
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable redis.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable containerregistry.googleapis.com

# Create Redis instance
Write-Host "Creating Redis instance..." -ForegroundColor Yellow
$redisResult = gcloud redis instances create ticketify-redis --size=1 --region=us-central1 --redis-version=redis_7_0 --tier=basic 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Redis instance may already exist or failed to create" -ForegroundColor Yellow
}

# Wait for Redis instance to be ready
Write-Host "Waiting for Redis instance to be ready..." -ForegroundColor Yellow
do {
    Start-Sleep -Seconds 10
    $redisState = gcloud redis instances describe ticketify-redis --region=us-central1 --format="value(state)" --quiet
    Write-Host "Redis state: $redisState" -ForegroundColor Cyan
} while ($redisState -ne "READY")

# Get Redis IP
$REDIS_IP = gcloud redis instances describe ticketify-redis --region=us-central1 --format="value(host)" --quiet
Write-Host "Redis instance ready at IP: $REDIS_IP" -ForegroundColor Green

# Update cloudbuild.yaml with Redis IP
Write-Host "Updating cloudbuild.yaml with Redis IP..." -ForegroundColor Yellow
(Get-Content cloudbuild.yaml) -replace '10\.0\.0\.3', $REDIS_IP | Set-Content cloudbuild.yaml

# Submit build
Write-Host "Building and deploying with Cloud Build..." -ForegroundColor Yellow
gcloud builds submit --config=cloudbuild.yaml .

# Get service URLs
$BACKEND_URL = gcloud run services describe ticketify-backend --region=us-central1 --format="value(status.url)" --quiet
$FRONTEND_URL = gcloud run services describe ticketify-frontend --region=us-central1 --format="value(status.url)" --quiet

Write-Host "Deployment completed successfully!" -ForegroundColor Green
Write-Host "Frontend URL: $FRONTEND_URL" -ForegroundColor Green
Write-Host "Backend URL: $BACKEND_URL" -ForegroundColor Green
Write-Host "Redis IP: $REDIS_IP" -ForegroundColor Green

# Update task documentation
Write-Host "Updating task documentation..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path "docs/TASK.md" -Value ""
Add-Content -Path "docs/TASK.md" -Value "## Deployment to Google Cloud - $timestamp"
Add-Content -Path "docs/TASK.md" -Value "- Deployed backend to Cloud Run: $BACKEND_URL"
Add-Content -Path "docs/TASK.md" -Value "- Deployed frontend to Cloud Run: $FRONTEND_URL"
Add-Content -Path "docs/TASK.md" -Value "- Created Redis instance: $REDIS_IP"
Add-Content -Path "docs/TASK.md" -Value ""

Write-Host "Deployment information added to docs/TASK.md" -ForegroundColor Green

# Instructions for Celery workers
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. For Celery workers, you may want to deploy them as separate Cloud Run jobs"
Write-Host "2. Update frontend API endpoints to point to: $BACKEND_URL"
Write-Host "3. Set up Cloud SQL for production database if needed"
Write-Host "4. Configure custom domain and SSL certificates"
Write-Host "5. Set up monitoring and logging"

Write-Host "TICKETIFY is now running on Google Cloud!" -ForegroundColor Green 