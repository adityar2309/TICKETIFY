const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
  transpileDependencies: true,
  
  chainWebpack: config => {
    // Remove only PWA-related plugins that cause conflicts
    config.plugins.delete('pwa')
    config.plugins.delete('workbox')
  },
  
  devServer: {
    port: 8080,
    host: 'localhost'
  }
}) 