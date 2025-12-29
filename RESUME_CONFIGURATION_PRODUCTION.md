# Résumé de la Configuration de Production

## ✅ Modifications Effectuées

### 1. Utilitaire Centralisé
- **`src/utils/apiUrl.js`** : Nouvel utilitaire pour gérer les URLs de l'API
  - `getApiBaseUrl()` : Retourne l'URL de base de l'API
  - `getServerBaseUrl()` : Retourne l'URL du serveur (sans /api)

### 2. Configuration Backend
- **`backend/server.js`** : CORS mis à jour pour accepter `http://172.16.3.52:3000`
- Ajout du support des variables d'environnement pour CORS_ORIGIN

### 3. Fichiers de Configuration
- **`.env.production.example`** : Template pour la configuration frontend
- **`backend/.env.production.example`** : Template pour la configuration backend
- **`DEPLOIEMENT_PRODUCTION.md`** : Guide complet de déploiement

### 4. Fichiers Modifiés

#### URLs Hardcodées Remplacées
Les fichiers suivants utilisent maintenant `getApiBaseUrl()` ou les variables d'environnement :

1. `src/components/employees/EmployeePortal.js`
   - URLs de documents et photos corrigées

2. `src/components/contracts/ContratPDFManager.jsx`
   - Toutes les URLs API corrigées

3. `src/components/auth/ResetPassword.jsx`
   - URLs de réinitialisation corrigées

4. `src/components/auth/ForgotPasswordModal.jsx`
   - URL de demande de réinitialisation corrigée

5. `src/components/requests/EmployeeRequests.jsx`
   - URL de suppression corrigée

6. `src/hooks/useUnreadMessages.js`
   - URLs de statistiques de messages corrigées

7. `src/components/hr/RHMessagingSimple.jsx`
   - Toutes les URLs de messagerie corrigées

8. `src/components/employees/EmployeeMessagingSimple.jsx`
   - Toutes les URLs de messagerie corrigées

9. `src/services/employeeService.js`
   - URL de base mise à jour pour utiliser les variables d'env

10. `src/setupProxy.js`
    - Configuration proxy mise à jour pour la production

#### Fichiers Déjà Configurés
Ces fichiers utilisent déjà les variables d'environnement correctement :
- `src/services/unifiedAuthService.js`
- `src/services/adminAuthService.js`
- `src/services/adminService.js`
- `src/services/absenceService.js`
- `src/services/congeService.js`
- `src/config/apiConfig.js`
- `src/components/dashboard/StatisticsCharts.jsx`
- `src/components/employees/ContractAlerts.jsx`

## 📋 Checklist de Déploiement

### Frontend
- [ ] Créer `.env.production` avec `REACT_APP_API_URL=http://172.16.3.52:5000/api`
- [ ] Exécuter `npm run build`
- [ ] Déployer le dossier `build` sur le serveur
- [ ] Configurer le serveur web pour servir sur le port 3000

### Backend
- [ ] Créer `backend/.env` avec la configuration de production
- [ ] Configurer `CORS_ORIGIN=http://172.16.3.52:3000`
- [ ] Vérifier la connexion à PostgreSQL
- [ ] Démarrer le serveur backend (port 5000)
- [ ] Configurer PM2 ou un gestionnaire de processus

### Base de Données
- [ ] Exécuter `database_complete.sql` si nécessaire
- [ ] Vérifier les migrations
- [ ] Configurer les backups

### Réseau
- [ ] Ouvrir le port 3000 (frontend)
- [ ] Ouvrir le port 5000 (backend)
- [ ] Vérifier le pare-feu

### Sécurité
- [ ] Changer `JWT_SECRET` en production
- [ ] Changer `SESSION_SECRET` en production
- [ ] Configurer HTTPS (recommandé)

## 🔍 Vérification Post-Déploiement

1. Tester l'accès au frontend : http://172.16.3.52:3000
2. Tester l'authentification
3. Vérifier les appels API dans la console du navigateur
4. Tester les principales fonctionnalités
5. Vérifier les logs du backend

## 📝 Notes Importantes

- Les URLs sont maintenant centralisées via les variables d'environnement
- Le fallback vers `localhost:5000` reste pour le développement local
- Tous les fichiers critiques ont été mis à jour
- Les fichiers de test/diagnostic peuvent garder localhost

## 🚀 Commandes Rapides

```bash
# Frontend - Build
npm run build

# Frontend - Serve local (test)
npx serve -s build -l 3000

# Backend - Démarrer
cd backend
node server.js

# Backend - Avec PM2
pm2 start server.js --name rh-backend
```

## 📞 Support

En cas de problème, vérifier :
1. Les variables d'environnement sont correctement définies
2. Les ports 3000 et 5000 sont accessibles
3. CORS est configuré correctement
4. La base de données est accessible
5. Les logs du serveur pour les erreurs


