# Guide de Déploiement en Production

## Configuration pour http://172.16.3.52:3000

> **Note importante** : Tous les fichiers avec des URLs hardcodées ont été mis à jour pour utiliser les variables d'environnement. Les services utilisent automatiquement `REACT_APP_API_URL` en production.

### 1. Configuration Frontend

#### Fichier `.env.production`
Créez un fichier `.env.production` à la racine du projet avec :

```env
REACT_APP_API_URL=http://172.16.3.52:5000/api
REACT_APP_API_BASE_URL=http://172.16.3.52:5000/api
FAST_REFRESH=false
GENERATE_SOURCEMAP=false
```

#### Build de production
```bash
npm run build
```

Le dossier `build` contiendra les fichiers statiques à déployer.

### 2. Configuration Backend

#### Fichier `backend/.env`
Créez un fichier `.env` dans le dossier `backend` avec :

```env
PORT=5000
NODE_ENV=production

DB_USER=postgres
DB_HOST=localhost
DB_NAME=rh_portal
DB_PASSWORD=Cdl202407
DB_PORT=5432

CORS_ORIGIN=http://172.16.3.52:3000
JWT_SECRET=your-super-secret-jwt-key-here-change-in-production
```

#### Mise à jour CORS
Le fichier `backend/server.js` a été mis à jour pour accepter les requêtes depuis `http://172.16.3.52:3000`.

### 3. URLs mises à jour

✅ **Tous les fichiers suivants ont été mis à jour pour utiliser les variables d'environnement :**

**Services :**
- `src/services/employeeService.js` ✅
- `src/services/unifiedAuthService.js` ✅ (utilise déjà les variables d'env)
- `src/services/adminAuthService.js` ✅ (utilise déjà les variables d'env)
- `src/services/adminService.js` ✅ (utilise déjà les variables d'env)
- `src/services/absenceService.js` ✅ (utilise déjà les variables d'env)
- `src/services/congeService.js` ✅ (utilise déjà les variables d'env)

**Composants :**
- `src/components/employees/EmployeePortal.js` ✅
- `src/components/contracts/ContratPDFManager.jsx` ✅
- `src/components/auth/ResetPassword.jsx` ✅
- `src/components/auth/ForgotPasswordModal.jsx` ✅
- `src/components/requests/EmployeeRequests.jsx` ✅
- `src/hooks/useUnreadMessages.js` ✅
- `src/components/hr/RHMessagingSimple.jsx` ✅
- `src/components/employees/EmployeeMessagingSimple.jsx` ✅
- `src/components/dashboard/StatisticsCharts.jsx` ✅ (utilise déjà les variables d'env)
- `src/components/employees/ContractAlerts.jsx` ✅ (utilise déjà les variables d'env)

**Configuration :**
- `src/utils/apiUrl.js` ✅ (nouvel utilitaire centralisé)
- `src/setupProxy.js` ✅ (mis à jour pour la production)

### 4. Utilitaire centralisé

Un nouveau fichier `src/utils/apiUrl.js` a été créé pour centraliser la gestion des URLs :
- `getApiBaseUrl()` - Retourne l'URL de base de l'API
- `getServerBaseUrl()` - Retourne l'URL du serveur (sans /api)

### 5. Déploiement

#### Frontend (Node.js/Serveur statique)
```bash
# Build
npm run build

# Serveur avec serve
npx serve -s build -l 3000

# Ou avec pm2
pm2 serve build 3000 --spa
```

#### Backend
```bash
cd backend
npm install
node server.js
# Ou avec pm2
pm2 start server.js --name rh-backend
```

### 6. Vérifications

1. ✅ CORS configuré pour `http://172.16.3.52:3000`
2. ✅ Variables d'environnement configurées
3. ✅ URLs hardcodées remplacées par des variables d'environnement
4. ✅ Base de données PostgreSQL accessible
5. ✅ Ports 3000 (frontend) et 5000 (backend) ouverts

### 7. Firewall

Assurez-vous que les ports suivants sont ouverts :
- **3000** : Frontend React
- **5000** : Backend API
- **5432** : PostgreSQL (si accès distant nécessaire)

### 8. Variables d'environnement critiques

⚠️ **IMPORTANT** : Changez ces valeurs en production :
- `JWT_SECRET` - Utilisez une clé secrète forte et unique
- `DB_PASSWORD` - Mot de passe de la base de données
- `SESSION_SECRET` - Clé secrète pour les sessions

### 9. Build et test

```bash
# Frontend
npm run build
# Test local du build
npx serve -s build -l 3000

# Backend
cd backend
node server.js
```

### 10. Production Checklist

- [ ] Variables d'environnement configurées
- [ ] Base de données PostgreSQL configurée
- [ ] CORS configuré pour l'IP de production
- [ ] Build frontend généré
- [ ] Backend démarré avec PM2 ou système similaire
- [ ] Logs configurés
- [ ] Backup de la base de données configuré
- [ ] SSL/HTTPS configuré (recommandé)
- [ ] Monitoring configuré

