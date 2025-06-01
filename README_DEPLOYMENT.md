# TICKETIFY Google Cloud Deployment Guide

This guide will help you deploy the TICKETIFY movie ticket booking application to Google Cloud Platform using Cloud Run, Redis, and Cloud Build.

## Prerequisites

1. **Google Cloud Account**: You need a Google Cloud account with billing enabled
2. **Google Cloud CLI**: Install and configure the gcloud CLI tool
3. **Docker**: Docker should be installed locally for testing
4. **Project Setup**: Create a new Google Cloud project

## Architecture Overview

The deployment uses the following Google Cloud services:

- **Cloud Run**: Serverless containers for backend and frontend
- **Cloud Memory Store (Redis)**: Managed Redis instance for caching and Celery
- **Cloud Build**: Automated build and deployment pipeline
- **Container Registry**: Docker image storage
- **Cloud SQL**: Optional managed database (currently using SQLite)

## Quick Deployment

### Step 1: Prerequisites Setup

```bash
# Install Google Cloud CLI (if not already installed)
# Follow instructions at: https://cloud.google.com/sdk/docs/install

# Authenticate with Google Cloud
gcloud auth login

# Set your project ID
gcloud config set project YOUR_PROJECT_ID

# Enable billing for your project (required for Cloud Run and Redis)
```

### Step 2: Clone and Navigate

```bash
cd TICKETIFY
```

### Step 3: Run Deployment Script

```bash
# Make the script executable
chmod +x deploy.sh

# Run the deployment
./deploy.sh
```

The script will automatically:
- Enable required Google Cloud APIs
- Create a Redis instance
- Build and deploy both backend and frontend
- Provide you with service URLs

## Manual Deployment Steps

If you prefer to deploy manually or need more control:

### 1. Enable Required APIs

```bash
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable redis.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable containerregistry.googleapis.com
```

### 2. Create Redis Instance

```bash
gcloud redis instances create ticketify-redis \
    --size=1 \
    --region=us-central1 \
    --redis-version=redis_7_0 \
    --tier=basic
```

### 3. Get Redis IP Address

```bash
REDIS_IP=$(gcloud redis instances describe ticketify-redis --region=us-central1 --format="value(host)")
echo "Redis IP: $REDIS_IP"
```

### 4. Update Configuration

Update the `cloudbuild.yaml` file to use your Redis IP:

```yaml
# Replace 10.0.0.3 with your actual Redis IP in cloudbuild.yaml
--set-env-vars', 'REDIS_URL=redis://YOUR_REDIS_IP:6379/0'
```

### 5. Build and Deploy

```bash
gcloud builds submit --config=cloudbuild.yaml .
```

### 6. Get Service URLs

```bash
# Backend URL
gcloud run services describe ticketify-backend --region=us-central1 --format="value(status.url)"

# Frontend URL
gcloud run services describe ticketify-frontend --region=us-central1 --format="value(status.url)"
```

## Configuration Details

### Environment Variables

The following environment variables are configured for production:

- `REDIS_URL`: Connection string for Redis instance
- `JWT_SECRET_KEY`: Secret key for JWT tokens (change in production!)
- `DATABASE_URL`: Database connection string
- `PORT`: Port for the application (automatically set by Cloud Run)

### Security Considerations

1. **JWT Secret**: Change the JWT secret key in production
2. **Database**: Consider migrating to Cloud SQL for production
3. **CORS**: Configure CORS settings for your domain
4. **SSL**: Cloud Run provides SSL termination automatically
5. **Authentication**: Implement proper user authentication and authorization

## Celery Workers (Background Tasks)

The current deployment includes Celery configuration, but workers need to be deployed separately:

### Option 1: Cloud Run Jobs (Recommended)

```bash
# Deploy Celery worker as a Cloud Run job
gcloud run jobs create ticketify-celery-worker \
    --image=gcr.io/YOUR_PROJECT_ID/ticketify-backend:latest \
    --task-parallelism=1 \
    --max-retries=3 \
    --region=us-central1 \
    --set-env-vars="REDIS_URL=redis://YOUR_REDIS_IP:6379/0" \
    --command="celery" \
    --args="-A,app:celery_app,worker,-l,info"

# Deploy Celery beat scheduler
gcloud run jobs create ticketify-celery-beat \
    --image=gcr.io/YOUR_PROJECT_ID/ticketify-backend:latest \
    --task-parallelism=1 \
    --max-retries=3 \
    --region=us-central1 \
    --set-env-vars="REDIS_URL=redis://YOUR_REDIS_IP:6379/0" \
    --command="celery" \
    --args="-A,app:celery_app,beat,-l,info"
```

### Option 2: Google Kubernetes Engine (GKE)

For more complex scenarios, consider deploying Celery workers on GKE.

## Monitoring and Logging

Google Cloud automatically provides:

- **Logging**: Application logs in Cloud Logging
- **Monitoring**: Basic metrics in Cloud Monitoring
- **Error Reporting**: Automatic error tracking
- **Health Checks**: Built-in health check endpoints

Access these through the Google Cloud Console.

## Scaling Configuration

The deployment is configured for automatic scaling:

### Backend (Cloud Run)
- Min instances: 1
- Max instances: 10
- CPU utilization: 60%
- Memory: 2Gi
- CPU: 2 cores

### Frontend (Cloud Run)
- Min instances: 0
- Max instances: 5
- Memory: 512Mi
- CPU: 1 core

## Database Migration (Optional)

To use Cloud SQL instead of SQLite:

1. Create a Cloud SQL instance
2. Update the `DATABASE_URL` environment variable
3. Install the appropriate database driver in requirements.txt
4. Update the connection string format

```bash
# Create Cloud SQL instance
gcloud sql instances create ticketify-db \
    --database-version=POSTGRES_13 \
    --tier=db-f1-micro \
    --region=us-central1
```

## Cost Optimization

- **Redis**: Use basic tier for development, standard for production
- **Cloud Run**: Pay only for requests and compute time
- **Cloud Build**: First 120 build-minutes per day are free
- **Storage**: Container images stored in Container Registry

## Troubleshooting

### Common Issues

1. **Redis Connection**: Ensure Redis instance is in the same region
2. **Build Failures**: Check Cloud Build logs in the console
3. **Memory Issues**: Increase memory allocation in Cloud Run
4. **Timeout Issues**: Increase timeout settings for long-running tasks

### Useful Commands

```bash
# View Cloud Run logs
gcloud logs read "resource.type=cloud_run_revision"

# Debug Cloud Build
gcloud builds list

# Check Redis instance status
gcloud redis instances list

# Update service configuration
gcloud run services update ticketify-backend --region=us-central1
```

## Production Checklist

- [ ] Change JWT secret key
- [ ] Set up custom domain
- [ ] Configure SSL certificates
- [ ] Set up monitoring and alerting
- [ ] Configure backup strategy
- [ ] Implement proper logging
- [ ] Set up CI/CD pipeline
- [ ] Configure environment-specific settings
- [ ] Test disaster recovery procedures
- [ ] Set up performance monitoring

## Support

For issues with this deployment:

1. Check Google Cloud Console for logs and errors
2. Review Cloud Build history
3. Verify Redis instance connectivity
4. Check service configurations in Cloud Run

## Next Steps

1. Set up a custom domain
2. Implement comprehensive monitoring
3. Add automated testing to the CI/CD pipeline
4. Consider migrating to Cloud SQL
5. Implement proper backup and disaster recovery
6. Set up staging environment
7. Configure alerts and notifications

The application should now be running on Google Cloud! Visit the frontend URL to access your deployed TICKETIFY application. 