# Project Planning - TICKETIFY Movie Ticket Booking App

## Project Overview
TICKETIFY is a movie ticket booking application built with Flask (backend) and Vue.js (frontend). The system allows users to book movie tickets, receive daily reminders, generate monthly reports, and export data to CSV.

## Architecture

### Backend (Flask)
- **Framework**: Flask with SQLAlchemy ORM
- **Database**: SQLite (site.db)
- **Caching**: Redis for performance optimization
- **Background Tasks**: Celery with Redis as broker
- **Authentication**: Flask-JWT-Extended
- **CORS**: Flask-CORS for frontend communication

### Frontend
- **Primary**: Vue.js with Vite (frontend-vite/)
- **Legacy**: Vue.js with traditional build (frontend/)
- **Development Server**: Runs on localhost:5174 (Vite) or localhost:8080 (legacy)

### Infrastructure
- **Redis**: Running on WSL Ubuntu (127.0.0.1:6379)
- **Background Jobs**: Celery worker and beat scheduler
- **File Export**: CSV export functionality

## File Structure
```
TICKETIFY/
├── Code/
│   ├── backend/           # Flask application
│   │   ├── app.py        # Main Flask app (25KB, 630 lines)
│   │   ├── requirements.txt
│   │   ├── site.db       # SQLite database
│   │   └── config.yml    # Configuration
│   ├── frontend-vite/    # Modern Vue.js frontend
│   ├── frontend/         # Legacy Vue.js frontend
│   ├── start.bat         # Windows startup script
│   └── start.sh          # Unix startup script
├── docs/                 # Project documentation
└── README.md
```

## Development Constraints
- **Maximum file size**: 500 lines of code per file
- **Language**: Python for backend, JavaScript/Vue.js for frontend
- **Code style**: PEP8 for Python, with type hints
- **Testing**: Pytest for unit tests in /tests directory
- **Documentation**: Google-style docstrings

## Environment Setup
1. **Windows PowerShell**: Use `;` instead of `&&` for command chaining
2. **WSL**: Required for Redis server on Windows
3. **Python**: All dependencies in requirements.txt
4. **Node.js**: NPM dependencies for frontend

## API Endpoints
- Backend runs on Flask default port (5000)
- CORS enabled for frontend communication
- JWT authentication for protected routes
- Caching layer with Redis for performance

## Background Tasks
- Daily reminders via Celery
- Monthly report generation
- Data export to CSV
- Celery beat for scheduled tasks

## Current Issues Resolved
1. ✅ Redis connection error - Redis now running on WSL
2. ✅ PowerShell syntax error - Using proper `;` syntax
3. ✅ Missing dependencies - All requirements installed

## Next Steps
- Monitor application health
- Implement comprehensive testing
- Add error handling and logging
- Document API endpoints 