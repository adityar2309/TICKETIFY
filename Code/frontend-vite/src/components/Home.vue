<template>
  <div class="home-container">
    <!-- Hero Section -->
    <section class="hero-section" v-if="$store.state.checkl">
      <div class="hero-content">
        <h1 class="hero-title">
          Welcome to <span class="gradient-text">Ticketify</span>
        </h1>
        <p class="hero-subtitle">
          Discover amazing shows and book your tickets instantly
        </p>
        <div class="hero-stats">
          <div class="stat-item">
            <span class="stat-number">{{ shows.length }}</span>
            <span class="stat-label">Available Shows</span>
          </div>
          <div class="stat-item">
            <span class="stat-number">50+</span>
            <span class="stat-label">Theaters</span>
          </div>
          <div class="stat-item">
            <span class="stat-number">1M+</span>
            <span class="stat-label">Happy Customers</span>
          </div>
        </div>
      </div>
    </section>

    <!-- Shows Grid -->
    <section class="shows-section" v-if="$store.state.checkl">
      <div class="section-header">
        <h2 class="section-title">🎬 Featured Shows</h2>
        <p class="section-subtitle">Book your favorite entertainment</p>
      </div>

      <div class="shows-grid" v-if="shows.length > 0">
        <div v-for="show in shows" :key="show.id" class="show-card">
          <div class="card-header">
            <div class="show-genre">{{ show.genre }}</div>
            <div class="show-rating">
              <span class="rating-icon">⭐</span>
              {{ show.rating }}
            </div>
          </div>
          
          <div class="card-body">
            <h3 class="show-title">{{ show.name }}</h3>
            <p class="show-description">
              Experience the magic of {{ show.name }} - a captivating {{ show.genre.toLowerCase() }} production.
            </p>
          </div>
          
          <div class="card-footer">
            <router-link 
              :to="{name: 'viewshow', params: {id: show.id}}" 
              class="btn-modern view-show-btn"
            >
              <span class="btn-icon">🎭</span>
              View Showtimes
            </router-link>
          </div>
        </div>
      </div>

      <!-- Empty State -->
      <div v-else class="empty-state">
        <div class="empty-icon">🎭</div>
        <h3>No Shows Available</h3>
        <p>Check back later for exciting new shows!</p>
      </div>
    </section>

    <!-- Login Prompt -->
    <section class="login-prompt" v-else>
      <div class="prompt-card">
        <div class="prompt-icon">🎬</div>
        <h2 class="prompt-title">Welcome to Ticketify</h2>
        <p class="prompt-subtitle">
          Please log in to discover amazing shows and book your tickets
        </p>
        <div class="prompt-actions">
          <router-link to="/login" class="btn-modern">
            <span class="btn-icon">👤</span>
            Log In
          </router-link>
          <router-link to="/signup" class="btn-secondary">
            <span class="btn-icon">✨</span>
            Sign Up
          </router-link>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'Home',
  data() {
    return {
      shows: []
    }
  },
  methods: {
    async checklogin() {
      let token = localStorage.getItem("token")
      try {
        const response = await axios.get("/checklogin", {
          headers: {
            Authorization: "Bearer " + token
          }
        })

        console.log(response.data)
        if (response.data.message == "success") {
          this.$store.commit("setcheckl", true)
          console.log(response, this.checkl)
        } else if (response.data.message == "failed") {
          this.$store.commit("setcheckl", false)
          console.log(response)
          this.$router.push('/login')
        }
      } catch (error) {
        console.error('Login check failed:', error)
        this.$store.commit("setcheckl", false)
      }
    },

    async getmovies() {
      let token = localStorage.getItem("token")
      try {
        const response = await axios.get("getmovies", {
          headers: {
            Authorization: "Bearer " + token
          }
        })
        this.shows = response.data.movies
        console.log(response)
      } catch (error) {
        console.error('Failed to fetch movies:', error)
      }
    }
  },
  mounted() {
    this.getmovies()
  },
  created() {
    this.checklogin()
  },
  beforeCreate() {
    if (this.$store.state.checkl == false) {
      this.$router.push('/login')
    }
  }
}
</script>

<style scoped>
.home-container {
  min-height: 80vh;
}

/* Hero Section */
.hero-section {
  text-align: center;
  padding: 4rem 0;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 24px;
  margin-bottom: 3rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.hero-content {
  max-width: 800px;
  margin: 0 auto;
}

.hero-title {
  font-size: 3.5rem;
  font-weight: 800;
  color: white;
  margin-bottom: 1rem;
  line-height: 1.1;
}

.gradient-text {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.hero-subtitle {
  font-size: 1.25rem;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 3rem;
  line-height: 1.6;
}

.hero-stats {
  display: flex;
  justify-content: center;
  gap: 3rem;
  flex-wrap: wrap;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.stat-number {
  font-size: 2.5rem;
  font-weight: 800;
  color: white;
}

.stat-label {
  font-size: 0.9rem;
  color: rgba(255, 255, 255, 0.7);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

/* Shows Section */
.shows-section {
  margin-bottom: 3rem;
}

.section-header {
  text-align: center;
  margin-bottom: 3rem;
}

.section-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: white;
  margin-bottom: 0.5rem;
}

.section-subtitle {
  font-size: 1.1rem;
  color: rgba(255, 255, 255, 0.7);
}

.shows-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 2rem;
}

.show-card {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 0;
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
}

.show-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem 1.5rem 0;
}

.show-genre {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-size: 0.85rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.show-rating {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  background: rgba(251, 191, 36, 0.1);
  color: #d97706;
  padding: 0.5rem 0.75rem;
  border-radius: 12px;
  font-weight: 600;
}

.rating-icon {
  font-size: 1rem;
}

.card-body {
  padding: 1.5rem;
}

.show-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1f2937;
  margin-bottom: 0.75rem;
}

.show-description {
  color: #6b7280;
  line-height: 1.6;
  margin-bottom: 0;
}

.card-footer {
  padding: 0 1.5rem 1.5rem;
}

.view-show-btn {
  width: 100%;
  justify-content: center;
  background: linear-gradient(135deg, #667eea, #764ba2);
}

.view-show-btn:hover {
  background: linear-gradient(135deg, #5a6fd8, #6a42a0);
}

/* Empty State */
.empty-state {
  text-align: center;
  padding: 4rem 2rem;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
}

.empty-state h3 {
  color: white;
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
}

.empty-state p {
  color: rgba(255, 255, 255, 0.7);
}

/* Login Prompt */
.login-prompt {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 60vh;
}

.prompt-card {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 24px;
  padding: 3rem;
  text-align: center;
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  max-width: 500px;
  width: 100%;
}

.prompt-icon {
  font-size: 4rem;
  margin-bottom: 1.5rem;
}

.prompt-title {
  font-size: 2rem;
  font-weight: 700;
  color: #1f2937;
  margin-bottom: 1rem;
}

.prompt-subtitle {
  color: #6b7280;
  line-height: 1.6;
  margin-bottom: 2rem;
}

.prompt-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}

.btn-icon {
  font-size: 1.1rem;
}

/* Responsive Design */
@media (max-width: 768px) {
  .hero-title {
    font-size: 2.5rem;
  }
  
  .hero-stats {
    gap: 2rem;
  }
  
  .shows-grid {
    grid-template-columns: 1fr;
  }
  
  .prompt-card {
    padding: 2rem;
    margin: 1rem;
  }
  
  .prompt-actions {
    flex-direction: column;
  }
}
</style>