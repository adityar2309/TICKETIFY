import os
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from flask_jwt_extended import JWTManager, jwt_required, get_jwt_identity, create_access_token, verify_jwt_in_request, get_jwt
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime
from functools import wraps
from flask_caching import Cache
import redis
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email import encoders
import smtplib
from celery import Celery
from celery.schedules import crontab

app = Flask(__name__)

# Production configuration with environment variables
app.config['JWT_SECRET_KEY'] = os.environ.get('JWT_SECRET_KEY', 'fallback-secret-key')
basedir = os.path.abspath(os.path.dirname(__file__))

# Use Cloud SQL in production if available, otherwise SQLite
database_url = os.environ.get('DATABASE_URL', f'sqlite:///{os.path.join(basedir, "site.db")}')
app.config['SQLALCHEMY_DATABASE_URI'] = database_url
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Redis configuration from environment
redis_url = os.environ.get('REDIS_URL', 'redis://localhost:6379/0')
redis_host = redis_url.split('//')[1].split(':')[0] if '//' in redis_url else 'localhost'
redis_port = int(redis_url.split(':')[-1].split('/')[0]) if ':' in redis_url else 6379

# Cache configuration
cache_config = {
    'CACHE_TYPE': 'RedisCache',
    'CACHE_REDIS_HOST': redis_host,
    'CACHE_REDIS_PORT': redis_port,
    'CACHE_REDIS_DB': 0
}
cache = Cache(app, config=cache_config)
cache.init_app(app)

db = SQLAlchemy(app)
CORS(app)
jwt = JWTManager(app)

# Redis client
redis_client = redis.Redis(host=redis_host, port=redis_port, db=0)

# Celery configuration
celery_app = Celery('tasks', broker=redis_url, backend=redis_url.replace('/0', '/1'))
celery_app.conf.timezone = 'UTC'  # Use UTC for production
app.config['CELERY_BEAT_TIMEZONE'] = 'UTC'

@celery_app.on_after_configure.connect
def daily_task(sender, **kwargs):
    """
    Configure periodic tasks for production.
    
    Args:
        sender: Celery app instance
        **kwargs: Additional keyword arguments
    """
    sender.add_periodic_task(crontab(hour=8, minute=0), dailyreminder.s(), name='send_daily_reminder')
    sender.add_periodic_task(crontab(day_of_month=1, hour=8, minute=0), monthlyreport.s(), name='send_monthly_report')
    sender.add_periodic_task(crontab(day_of_month=1, hour=8, minute=0), export.s(), name='export_data')

# Import all models and routes from the original app
# (Copy all the model definitions from the original app.py)

# ... existing code ... (copy all models: User, Movie, Shows, Role, Ticket, Theaters)

# ... existing code ... (copy all helper functions: admin_required, user_required)

# ... existing code ... (copy all Celery tasks: monthlyreport, dailyreminder, export)

# ... existing code ... (copy all routes)

# Health check endpoint for Cloud Run
@app.route('/health')
def health_check():
    """
    Health check endpoint for load balancer.
    
    Returns:
        dict: Health status
    """
    try:
        # Test Redis connection
        redis_client.ping()
        return jsonify({"status": "healthy", "timestamp": datetime.utcnow().isoformat()}), 200
    except Exception as e:
        return jsonify({"status": "unhealthy", "error": str(e)}), 500

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    
    # Use environment port for Cloud Run
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port, debug=False) 