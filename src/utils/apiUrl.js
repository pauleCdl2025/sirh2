// Utilitaire centralisé pour les URLs de l'API
// Utilise les variables d'environnement avec fallback

const getApiBaseUrl = () => {
  return process.env.REACT_APP_API_URL || 'http://localhost:5000/api';
};

const getServerBaseUrl = () => {
  // Pour les URLs de serveur (sans /api)
  const apiUrl = getApiBaseUrl();
  return apiUrl.replace('/api', '');
};

export { getApiBaseUrl, getServerBaseUrl };


