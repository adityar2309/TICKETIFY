<script>
import axios from 'axios';

export default{
  name:"App",
  methods:{
    logout(){
      this.$store.state.checkl = false;
      this.$store.state.checkadmin = false;
      localStorage.setItem("token", null);
      this.$router.push('/login');
    }
  }
}
</script>

<template>
  <div id="app">
    <!-- Modern Header with Gradient -->
    <header class="modern-header">
      <nav class="nav-container">
        <!-- Brand Logo -->
        <div class="brand-section">
          <router-link 
            :to="$store.state.checkadmin ? '/viewmovies' : '/'" 
            class="brand-link"
          >
            <div class="logo">
              <span class="logo-icon">🎭</span>
              <span class="logo-text">Ticketify</span>
            </div>
          </router-link>
        </div>

        <!-- Navigation Links -->
        <div class="nav-links">
          <!-- Guest Navigation -->
          <template v-if="!$store.state.checkl">
            <router-link to="/login" class="nav-item">
              <span class="nav-icon">👤</span>
              Login
            </router-link>
            <router-link to="/signup" class="nav-item nav-item-primary">
              <span class="nav-icon">✨</span>
              Sign Up
            </router-link>
          </template>

          <!-- User Navigation -->
          <template v-else-if="$store.state.checkl && !$store.state.checkadmin">
            <router-link to="/tickets" class="nav-item">
              <span class="nav-icon">🎫</span>
              My Tickets
            </router-link>
            <router-link to="/theaters" class="nav-item">
              <span class="nav-icon">🏛️</span>
              Theaters
            </router-link>
            <router-link to="/search" class="nav-item">
              <span class="nav-icon">🔍</span>
              Search
            </router-link>
            <button @click="logout" class="nav-item nav-item-logout">
              <span class="nav-icon">🚪</span>
              Logout
            </button>
          </template>

          <!-- Admin Navigation -->
          <template v-else-if="$store.state.checkl && $store.state.checkadmin">
            <router-link to="/viewmovies" class="nav-item">
              <span class="nav-icon">🎬</span>
              Movies
            </router-link>
            <router-link to="/admin" class="nav-item">
              <span class="nav-icon">🎭</span>
              Shows
            </router-link>
            <router-link to="/viewtheater" class="nav-item">
              <span class="nav-icon">🏛️</span>
              Theaters
            </router-link>
            <button @click="logout" class="nav-item nav-item-logout">
              <span class="nav-icon">🚪</span>
              Logout
            </button>
          </template>
        </div>
      </nav>
    </header>

    <!-- Main Content Area -->
    <main class="main-content">
      <router-view v-slot="{ Component }">
        <transition name="page" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </main>

    <!-- Footer -->
    <footer class="modern-footer">
      <div class="footer-content">
        <p>&copy; 2024 Ticketify - Your Ultimate Entertainment Hub</p>
      </div>
    </footer>
  </div>
</template>

<style>
/* Global Styles */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

#app {
  font-family: 'Inter', 'Segoe UI', system-ui, -apple-system, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  flex-direction: column;
}

/* Modern Header */
.modern-header {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 1rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

/* Brand Section */
.brand-section {
  display: flex;
  align-items: center;
}

.brand-link {
  text-decoration: none;
}

.logo {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.logo-icon {
  font-size: 2rem;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.logo-text {
  font-size: 1.75rem;
  font-weight: 800;
  background: linear-gradient(135deg, #667eea, #764ba2);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: -0.02em;
}

/* Navigation Links */
.nav-links {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.25rem;
  border-radius: 12px;
  text-decoration: none;
  font-weight: 500;
  font-size: 0.95rem;
  color: #374151;
  background: transparent;
  border: none;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.nav-item:hover {
  background: rgba(102, 126, 234, 0.1);
  color: #667eea;
  transform: translateY(-1px);
}

.nav-item-primary {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white !important;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
}

.nav-item-primary:hover {
  background: linear-gradient(135deg, #5a6fd8, #6a42a0);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
}

.nav-item-logout {
  background: rgba(239, 68, 68, 0.1);
  color: #dc2626;
}

.nav-item-logout:hover {
  background: rgba(239, 68, 68, 0.2);
  color: #b91c1c;
}

.nav-icon {
  font-size: 1.1rem;
}

.router-link-active {
  background: rgba(102, 126, 234, 0.15);
  color: #667eea !important;
}

/* Main Content */
.main-content {
  flex: 1;
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

/* Page Transitions */
.page-enter-active,
.page-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.page-enter-from {
  opacity: 0;
  transform: translateY(20px);
}

.page-leave-to {
  opacity: 0;
  transform: translateY(-20px);
}

/* Footer */
.modern-footer {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 1.5rem 2rem;
  margin-top: auto;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  text-align: center;
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.9rem;
}

/* Responsive Design */
@media (max-width: 768px) {
  .nav-container {
    padding: 1rem;
    flex-direction: column;
    gap: 1rem;
  }

  .nav-links {
    flex-wrap: wrap;
    justify-content: center;
  }

  .main-content {
    padding: 1rem;
  }

  .logo-text {
    font-size: 1.5rem;
  }
}

/* Utility Classes */
.card {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 16px;
  padding: 2rem;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  margin-bottom: 2rem;
}

.btn-modern {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
}

.btn-modern:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
}

.btn-secondary {
  background: rgba(107, 114, 128, 0.1);
  color: #374151;
  border: 1px solid rgba(107, 114, 128, 0.2);
}

.btn-secondary:hover {
  background: rgba(107, 114, 128, 0.2);
}
</style>
