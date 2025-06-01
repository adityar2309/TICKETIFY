<template>
  <div class="login-container">
    <div class="login-card">
      <!-- Header -->
      <div class="login-header">
        <div class="login-icon">🎭</div>
        <h1 class="login-title">Welcome Back</h1>
        <p class="login-subtitle">Sign in to your Ticketify account</p>
      </div>

      <!-- Form -->
      <form @submit.prevent="login" class="login-form">
        <div class="form-group">
          <label for="email" class="form-label">
            <span class="label-icon">📧</span>
            Email Address
          </label>
          <input 
            id="email"
            type="email" 
            class="form-input"
            placeholder="Enter your email"
            v-model="email"
            required
          >
        </div>

        <div class="form-group">
          <label for="password" class="form-label">
            <span class="label-icon">🔒</span>
            Password
          </label>
          <input 
            id="password"
            type="password" 
            class="form-input"
            placeholder="Enter your password"
            v-model="password"
            required
          >
        </div>

        <!-- Error Message -->
        <div v-if="errorMessage" class="error-message">
          <span class="error-icon">⚠️</span>
          {{ errorMessage }}
        </div>

        <!-- Submit Button -->
        <button 
          type="submit" 
          class="btn-modern login-btn"
          :disabled="isLoading"
          :class="{ 'loading': isLoading }"
        >
          <span v-if="!isLoading" class="btn-content">
            <span class="btn-icon">🚀</span>
            Sign In
          </span>
          <span v-else class="btn-content">
            <span class="spinner"></span>
            Signing In...
          </span>
        </button>
      </form>

      <!-- Footer -->
      <div class="login-footer">
        <p class="footer-text">
          Don't have an account? 
          <router-link to="/signup" class="footer-link">Sign up here</router-link>
        </p>
      </div>
    </div>

    <!-- Background Decoration -->
    <div class="decoration decoration-1"></div>
    <div class="decoration decoration-2"></div>
    <div class="decoration decoration-3"></div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: "Login",
  data() {
    return {
      email: "",
      password: "",
      isLoading: false,
      errorMessage: ""
    }
  },
  methods: {
    async login() {
      if (!this.email || !this.password) {
        this.errorMessage = "Please fill in all fields"
        return
      }

      this.isLoading = true
      this.errorMessage = ""

      try {
        const response = await axios.post('login', {
          email: this.email,
          password: this.password
        })

        if (response.data.message == "login successful") {
          console.log("login successful", response.data)
          localStorage.setItem("token", response.data.access_token)
          this.$store.commit("setcheckl", true)
          this.$router.push('/')
        } else if (response.data.message == "admin login successful") {
          console.log("admin login successful", response.data)
          localStorage.setItem("token", response.data.access_token)
          this.$store.commit("setcheckl", true)
          this.$store.commit("setcheckadmin", true)
          this.$router.push('/admin')
        } else {
          this.errorMessage = "Invalid email or password"
        }
      } catch (error) {
        console.error("Login error:", error)
        this.errorMessage = "Login failed. Please try again."
      } finally {
        this.isLoading = false
      }
    }
  }
}
</script>

<style scoped>
.login-container {
  min-height: 80vh;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
  padding: 2rem;
}

.login-card {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 24px;
  padding: 3rem;
  width: 100%;
  max-width: 450px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  position: relative;
  z-index: 10;
}

/* Header */
.login-header {
  text-align: center;
  margin-bottom: 2.5rem;
}

.login-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
  display: block;
}

.login-title {
  font-size: 2.5rem;
  font-weight: 800;
  color: #1f2937;
  margin-bottom: 0.5rem;
  background: linear-gradient(135deg, #667eea, #764ba2);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.login-subtitle {
  color: #6b7280;
  font-size: 1.1rem;
  margin: 0;
}

/* Form */
.login-form {
  margin-bottom: 2rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 600;
  color: #374151;
  margin-bottom: 0.5rem;
  font-size: 0.95rem;
}

.label-icon {
  font-size: 1.1rem;
}

.form-input {
  width: 100%;
  padding: 1rem 1.25rem;
  border: 2px solid rgba(107, 114, 128, 0.2);
  border-radius: 12px;
  font-size: 1rem;
  background: rgba(255, 255, 255, 0.8);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  backdrop-filter: blur(10px);
}

.form-input:focus {
  outline: none;
  border-color: #667eea;
  background: rgba(255, 255, 255, 0.95);
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
  transform: translateY(-1px);
}

.form-input::placeholder {
  color: #9ca3af;
}

/* Error Message */
.error-message {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background: rgba(239, 68, 68, 0.1);
  color: #dc2626;
  padding: 1rem;
  border-radius: 12px;
  margin-bottom: 1.5rem;
  border: 1px solid rgba(239, 68, 68, 0.2);
  font-weight: 500;
}

.error-icon {
  font-size: 1.1rem;
}

/* Submit Button */
.login-btn {
  width: 100%;
  padding: 1rem 1.5rem;
  font-size: 1.1rem;
  font-weight: 600;
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.login-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
}

.login-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.login-btn.loading {
  pointer-events: none;
}

.btn-content {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.btn-icon {
  font-size: 1.2rem;
}

/* Spinner */
.spinner {
  width: 20px;
  height: 20px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top: 2px solid white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Footer */
.login-footer {
  text-align: center;
  padding-top: 1.5rem;
  border-top: 1px solid rgba(107, 114, 128, 0.1);
}

.footer-text {
  color: #6b7280;
  margin: 0;
}

.footer-link {
  color: #667eea;
  text-decoration: none;
  font-weight: 600;
  transition: color 0.3s ease;
}

.footer-link:hover {
  color: #5a6fd8;
  text-decoration: underline;
}

/* Background Decorations */
.decoration {
  position: absolute;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
  z-index: 1;
}

.decoration-1 {
  width: 200px;
  height: 200px;
  top: 10%;
  left: 10%;
  animation: float 6s ease-in-out infinite;
}

.decoration-2 {
  width: 150px;
  height: 150px;
  top: 60%;
  right: 15%;
  animation: float 8s ease-in-out infinite reverse;
}

.decoration-3 {
  width: 100px;
  height: 100px;
  bottom: 20%;
  left: 20%;
  animation: float 7s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-20px); }
}

/* Responsive Design */
@media (max-width: 768px) {
  .login-container {
    padding: 1rem;
  }
  
  .login-card {
    padding: 2rem 1.5rem;
  }
  
  .login-title {
    font-size: 2rem;
  }
  
  .decoration {
    display: none;
  }
}
</style>