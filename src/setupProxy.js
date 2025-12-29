// Fichier de configuration proxy pour désactiver les WebSockets
const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function(app) {
  // Désactiver les WebSockets en redirigeant vers une route inexistante
  app.use('/ws', (req, res) => {
    res.status(404).send('WebSocket désactivé');
  });
  
  // Configuration proxy pour l'API backend
  // En production, utilisez les variables d'environnement pour la cible
  const proxyTarget = process.env.REACT_APP_API_URL?.replace('/api', '') || 'http://localhost:5000';
  app.use('/api', createProxyMiddleware({
    target: proxyTarget,
    changeOrigin: true,
    timeout: 30000,
    proxyTimeout: 30000,
    pathRewrite: {
      '^/api': '/api'
    }
  }));
};



