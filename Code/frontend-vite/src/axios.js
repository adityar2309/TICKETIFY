import axios from 'axios';

// Use environment variable for API URL, fallback to localhost for development
const apiUrl = import.meta.env.VITE_API_URL || 'http://127.0.0.1:5000';
axios.defaults.baseURL = apiUrl;

// Set authorization header if token exists
let token = localStorage.getItem("token");
if (token && token !== 'null') {
    axios.defaults.headers.common['Authorization'] = 'Bearer ' + token;
}

// Add request interceptor to handle token updates
axios.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem("token");
        if (token && token !== 'null') {
            config.headers.Authorization = 'Bearer ' + token;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

// Add response interceptor to handle unauthorized responses
axios.interceptors.response.use(
    (response) => {
        return response;
    },
    (error) => {
        if (error.response && error.response.status === 401) {
            // Token is invalid, clear it and redirect to login
            localStorage.removeItem("token");
            window.location.href = '/login';
        }
        return Promise.reject(error);
    }
); 