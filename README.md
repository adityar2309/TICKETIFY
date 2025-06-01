# 🎭 TICKETIFY - Movie Ticket Booking Platform

<div align="center">

![TICKETIFY Logo](https://via.placeholder.com/150x150/ff6b6b/ffffff?text=🎭)

**A modern, full-stack movie ticket booking platform built with Flask and Vue.js**

[![Live Demo](https://img.shields.io/badge/🌐_Live_Demo-Netlify-00C7B7?style=for-the-badge)](https://ticketiify.netlify.app/)
[![Backend API](https://img.shields.io/badge/🔗_API-Google_Cloud-4285F4?style=for-the-badge)](https://ticketify-backend-321805997355.us-central1.run.app)
[![License](https://img.shields.io/badge/📄_License-MIT-green?style=for-the-badge)](LICENSE)

</div>

## 🌟 Overview

TICKETIFY is a comprehensive movie ticket booking platform that enables users to discover movies, book tickets, and manage their reservations. Built with modern web technologies, it features a responsive Vue.js frontend and a robust Flask backend with real-time notifications and automated reporting.

### ✨ Key Features

- 🎬 **Movie Discovery**: Browse movies by genre, rating, and showtimes
- 🎫 **Ticket Booking**: Easy and secure ticket reservation system
- 👤 **User Management**: Registration, authentication, and profile management
- 🛡️ **Admin Dashboard**: Complete theater and movie management
- 📧 **Smart Notifications**: Daily reminders and monthly reports via email
- 📊 **Data Export**: CSV export functionality for analytics
- 🔄 **Real-time Updates**: Live ticket availability and booking status
- 📱 **Responsive Design**: Optimized for desktop and mobile devices

## 🚀 Live Demo

- **🌐 Frontend**: [https://ticketiify.netlify.app/](https://ticketiify.netlify.app/)
- **🔗 Backend API**: [https://ticketify-backend-321805997355.us-central1.run.app](https://ticketify-backend-321805997355.us-central1.run.app)

### 👤 Demo Credentials

- **User Account**: 
  - Email: `user@demo.com`
  - Password: `password123`
- **Admin Account**: 
  - Email: `admin@demo.com`
  - Password: `admin123`

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Vue.js SPA    │    │   Flask API     │    │     Redis       │
│   (Netlify)     │◄──►│ (Cloud Run)     │◄──►│ (Memorystore)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │   SQLite DB     │
                       │   (File-based)  │
                       └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │ Celery Workers  │
                       │ (Background)    │
                       └─────────────────┘
```

### 🛠️ Technology Stack

#### Frontend
- **Vue.js 3** - Progressive JavaScript framework
- **Vite** - Fast build tool and dev server
- **Vue Router** - Client-side routing
- **Vuex** - State management
- **Axios** - HTTP client
- **Bootstrap 5** - CSS framework

#### Backend
- **Flask** - Python web framework
- **Flask-SQLAlchemy** - ORM for database operations
- **Flask-JWT-Extended** - JWT authentication
- **Flask-CORS** - Cross-origin resource sharing
- **Flask-Caching** - Redis-based caching
- **Celery** - Distributed task queue
- **SQLite** - Database (upgradeable to PostgreSQL/MySQL)

#### Infrastructure
- **Netlify** - Frontend hosting and CDN
- **Google Cloud Run** - Serverless backend hosting
- **Google Cloud Memorystore** - Managed Redis service
- **Docker** - Containerization
- **GitHub Actions** - CI/CD (configured)

## 📋 Prerequisites

### Development
- **Python 3.8+**
- **Node.js 16+**
- **Redis** (local development)
- **Git**

### Deployment
- **Google Cloud Account** (for backend)
- **Netlify Account** (for frontend)
- **Docker** (optional)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/TICKETIFY.git
cd TICKETIFY
```

### 2. Backend Setup

```bash
# Navigate to backend directory
cd Code/backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Start Redis (if running locally)
redis-server

# Initialize database
python -c "from app import app, db; app.app_context().push(); db.create_all()"

# Start Celery worker (new terminal)
celery -A app:celery_app worker -l info -P eventlet

# Start Celery beat scheduler (new terminal)
celery -A app:celery_app beat -l info

# Run Flask application
python app.py
```

### 3. Frontend Setup

```bash
# Navigate to frontend directory
cd Code/frontend-vite

# Install dependencies
npm install

# Create environment file
cp env.example .env.local

# Start development server
npm run dev
```

### 4. Access the Application

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:5000
- **Redis**: localhost:6379

## 🐳 Docker Setup

### Using Docker Compose

```bash
# Build and start all services
docker-compose up --build

# Run in background
docker-compose up -d

# Stop services
docker-compose down
```

### Individual Services

```bash
# Build backend
docker build -t ticketify-backend ./Code/backend

# Build frontend
docker build -t ticketify-frontend ./Code/frontend-vite

# Run backend
docker run -p 8080:8080 ticketify-backend

# Run frontend
docker run -p 80:80 ticketify-frontend
```

## 🌐 Deployment

### Backend Deployment (Google Cloud)

```bash
# Authenticate with Google Cloud
gcloud auth login

# Set project
gcloud config set project YOUR_PROJECT_ID

# Deploy using Cloud Build
gcloud builds submit --config=cloudbuild_backend.yaml .
```

### Frontend Deployment (Netlify)

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Deploy to Netlify
netlify deploy --prod --dir=Code/frontend-vite/dist
```

### Automated Deployment

The project includes automated deployment scripts:

- **PowerShell**: `./deploy.ps1`
- **Bash**: `./deploy.sh`

## 📊 Database Schema

### Core Models

```sql
-- Users
CREATE TABLE user (
    id INTEGER PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL,
    password VARCHAR(30) NOT NULL,
    role_id INTEGER NOT NULL
);

-- Movies
CREATE TABLE movie (
    id INTEGER PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    genre VARCHAR(30) NOT NULL,
    rating VARCHAR(30) NOT NULL
);

-- Theaters
CREATE TABLE theaters (
    id INTEGER PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    place VARCHAR(30) NOT NULL,
    capacity INTEGER NOT NULL
);

-- Shows
CREATE TABLE shows (
    id INTEGER PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    theater_id INTEGER NOT NULL,
    ticket_price INTEGER NOT NULL,
    available_tickets INTEGER NOT NULL,
    datetime DATETIME NOT NULL
);

-- Tickets
CREATE TABLE ticket (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    show_id INTEGER NOT NULL,
    nooftickets INTEGER NOT NULL,
    ticket_price INTEGER NOT NULL
);
```

## 🔌 API Documentation

### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/signup` | User registration |
| POST | `/login` | User authentication |
| GET | `/checklogin` | Verify JWT token |

### Movie Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/getmovies` | List all movies |
| GET | `/getmovie/<id>` | Get movie details |
| POST | `/createmovie` | Create new movie (Admin) |
| POST | `/editmovie/<id>` | Update movie (Admin) |
| POST | `/deletemovie/<id>` | Delete movie (Admin) |

### Show Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | List all shows |
| GET | `/viewshow/<id>` | Get shows for movie |
| POST | `/createshow` | Create new show (Admin) |
| POST | `/editshow/<id>` | Update show (Admin) |
| POST | `/deleteshow/<id>` | Delete show (Admin) |

### Booking Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/bookshow/<id>` | Book tickets |
| GET | `/gettickets` | User's bookings |
| POST | `/deleteticket/<id>` | Cancel booking |

### Search & Filter

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/search/<name>` | Search movies |

## 🎯 Features in Detail

### 👤 User Features

- **Registration & Login**: Secure user authentication with JWT tokens
- **Movie Browsing**: View available movies with ratings and genres
- **Show Selection**: Choose from available showtimes
- **Ticket Booking**: Reserve seats with real-time availability
- **Booking History**: View past and upcoming bookings
- **Profile Management**: Update personal information

### 🛡️ Admin Features

- **Dashboard**: Overview of system statistics
- **Movie Management**: Add, edit, and remove movies
- **Theater Management**: Manage theater information and capacity
- **Show Scheduling**: Create and manage movie showtimes
- **User Management**: View user accounts and bookings
- **Reports**: Generate and export booking reports

### 🔄 Background Tasks

- **Daily Reminders**: Email notifications for upcoming shows
- **Monthly Reports**: Automated monthly booking summaries
- **Data Export**: Scheduled CSV exports for analytics
- **Cache Management**: Automatic cache refresh and cleanup

## 🔧 Configuration

### Environment Variables

#### Backend (.env)
```bash
# Database
DATABASE_URL=sqlite:///site.db

# Redis
REDIS_URL=redis://localhost:6379/0

# JWT
JWT_SECRET_KEY=your-secret-key

# Email (for notifications)
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
```

#### Frontend (.env.local)
```bash
# API URL
VITE_API_URL=http://localhost:5000
```

## 🧪 Testing

### Backend Tests
```bash
cd Code/backend
python -m pytest tests/ -v
```

### Frontend Tests
```bash
cd Code/frontend-vite
npm run test
```

### E2E Tests
```bash
npm run test:e2e
```

## 📈 Performance

### Optimization Features

- **Redis Caching**: API response caching for faster load times
- **CDN Delivery**: Static assets served via Netlify Edge network
- **Image Optimization**: Compressed images and lazy loading
- **Code Splitting**: Dynamic imports for reduced bundle size
- **Database Indexing**: Optimized queries with proper indexes

### Monitoring

- **Frontend**: Netlify Analytics
- **Backend**: Google Cloud Monitoring
- **Uptime**: Health check endpoints
- **Error Tracking**: Structured logging and error reporting

## 🔒 Security

### Implemented Security Measures

- **JWT Authentication**: Secure token-based authentication
- **CORS Protection**: Configured cross-origin resource sharing
- **Input Validation**: Server-side validation for all inputs
- **SQL Injection Prevention**: ORM-based queries
- **XSS Protection**: Content Security Policy headers
- **HTTPS Enforcement**: SSL/TLS encryption in production

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### Code Style

- **Python**: Follow PEP 8 guidelines
- **JavaScript**: ESLint configuration included
- **Vue.js**: Vue style guide compliance
- **Commits**: Conventional commit messages

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙋‍♂️ Support

### Getting Help

- **Documentation**: Check this README and inline code comments
- **Issues**: Open a GitHub issue for bugs or feature requests
- **Discussions**: Use GitHub Discussions for questions

### Contact

- **Email**: your-email@example.com
- **GitHub**: [@your-username](https://github.com/your-username)
- **LinkedIn**: [Your Name](https://linkedin.com/in/your-profile)

## 🎉 Acknowledgments

- **Flask Community** for the excellent web framework
- **Vue.js Team** for the progressive JavaScript framework
- **Google Cloud** for reliable infrastructure
- **Netlify** for seamless frontend hosting
- **Open Source Contributors** who made this project possible

## 📅 Roadmap

### Upcoming Features

- [ ] **Payment Integration**: Stripe/PayPal payment processing
- [ ] **Seat Selection**: Interactive theater seat maps
- [ ] **Movie Reviews**: User ratings and reviews system
- [ ] **Recommendation Engine**: AI-powered movie suggestions
- [ ] **Mobile App**: React Native mobile application
- [ ] **Analytics Dashboard**: Advanced reporting and insights
- [ ] **Multi-language Support**: Internationalization (i18n)
- [ ] **Social Features**: Share bookings on social media

### Technical Improvements

- [ ] **Database Migration**: PostgreSQL/MySQL support
- [ ] **Microservices**: Break down into smaller services
- [ ] **GraphQL API**: Alternative to REST API
- [ ] **Real-time Features**: WebSocket integration
- [ ] **Performance Optimization**: Advanced caching strategies
- [ ] **Security Enhancements**: OAuth2 integration
- [ ] **Testing Coverage**: Increase test coverage to 90%+

---

<div align="center">

**⭐ Star this repository if you found it helpful!**

Made with ❤️ by [Your Name](https://github.com/your-username)

</div>
