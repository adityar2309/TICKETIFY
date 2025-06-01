#!/bin/bash

# TICKETIFY Google Cloud Deployment Script
# Make sure you have gcloud CLI installed and authenticated

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting TICKETIFY deployment to Google Cloud...${NC}"

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ gcloud CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Get project ID
PROJECT_ID=$(gcloud config get-value project)
if [ -z "$PROJECT_ID" ]; then
    echo -e "${RED}❌ No Google Cloud project set. Please run: gcloud config set project YOUR_PROJECT_ID${NC}"
    exit 1
fi

echo -e "${GREEN}📋 Using Google Cloud Project: ${PROJECT_ID}${NC}"

# Enable required APIs
echo -e "${YELLOW}🔧 Enabling required Google Cloud APIs...${NC}"
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable redis.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable containerregistry.googleapis.com

# Create Redis instance
echo -e "${YELLOW}🔴 Creating Redis instance...${NC}"
gcloud redis instances create ticketify-redis \
    --size=1 \
    --region=us-central1 \
    --redis-version=redis_7_0 \
    --tier=basic || echo "Redis instance may already exist"

# Wait for Redis instance to be ready
echo -e "${YELLOW}⏳ Waiting for Redis instance to be ready...${NC}"
gcloud redis instances describe ticketify-redis --region=us-central1 --format="value(state)" | grep -q "READY" || {
    echo "Waiting for Redis to be ready..."
    sleep 30
}

# Get Redis IP
REDIS_IP=$(gcloud redis instances describe ticketify-redis --region=us-central1 --format="value(host)")
echo -e "${GREEN}✅ Redis instance ready at IP: ${REDIS_IP}${NC}"

# Build and deploy using Cloud Build
echo -e "${YELLOW}🏗️ Building and deploying with Cloud Build...${NC}"

# Update cloudbuild.yaml with Redis IP
sed -i "s/10\.0\.0\.3/${REDIS_IP}/g" cloudbuild.yaml

# Submit build
gcloud builds submit --config=cloudbuild.yaml .

# Get service URLs
BACKEND_URL=$(gcloud run services describe ticketify-backend --region=us-central1 --format="value(status.url)")
FRONTEND_URL=$(gcloud run services describe ticketify-frontend --region=us-central1 --format="value(status.url)")

echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo -e "${GREEN}📱 Frontend URL: ${FRONTEND_URL}${NC}"
echo -e "${GREEN}🔙 Backend URL: ${BACKEND_URL}${NC}"
echo -e "${GREEN}🔴 Redis IP: ${REDIS_IP}${NC}"

# Update task documentation
echo -e "${YELLOW}📝 Updating task documentation...${NC}"
echo "## Deployment to Google Cloud - $(date)" >> docs/TASK.md
echo "- ✅ Deployed backend to Cloud Run: ${BACKEND_URL}" >> docs/TASK.md
echo "- ✅ Deployed frontend to Cloud Run: ${FRONTEND_URL}" >> docs/TASK.md
echo "- ✅ Created Redis instance: ${REDIS_IP}" >> docs/TASK.md
echo "" >> docs/TASK.md

echo -e "${GREEN}✅ Deployment information added to docs/TASK.md${NC}"

# Instructions for Celery workers
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "1. For Celery workers, you may want to deploy them as separate Cloud Run jobs"
echo "2. Update frontend API endpoints to point to: ${BACKEND_URL}"
echo "3. Set up Cloud SQL for production database if needed"
echo "4. Configure custom domain and SSL certificates"
echo "5. Set up monitoring and logging"

echo -e "${GREEN}🚀 TICKETIFY is now running on Google Cloud!${NC}" 