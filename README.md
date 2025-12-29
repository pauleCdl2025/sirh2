# 🏢 Système d'Information des Ressources Humaines (SIRH)
## Centre Diagnostic - Portail RH

Application complète de gestion des ressources humaines développée pour le Centre Diagnostic. Plateforme web moderne permettant de gérer l'ensemble du cycle de vie des employés, des processus RH et de l'administration du personnel.

---

## 📋 Table des matières

- [Fonctionnalités principales](#-fonctionnalités-principales)
- [Technologies utilisées](#-technologies-utilisées)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Démarrage](#-démarrage)
- [Structure du projet](#-structure-du-projet)
- [Types d'utilisateurs](#-types-dutilisateurs)
- [Dépannage](#-dépannage)
- [Déploiement en production](#-déploiement-en-production)

---

## ✨ Fonctionnalités principales

### Pour les Administrateurs RH
- ✅ **Gestion complète des employés** (CRUD, profils détaillés)
- ✅ **Gestion des congés et absences** avec validation
- ✅ **Suivi des contrats** avec alertes automatiques d'expiration
- ✅ **Recrutement et onboarding/offboarding** automatisés
- ✅ **Suivi médical** et visites médicales
- ✅ **Gestion des événements** d'entreprise
- ✅ **Notes de service** et communication interne
- ✅ **Gestion des demandes** des employés
- ✅ **Sanctions disciplinaires** et suivi
- ✅ **Rapports et statistiques** avancés
- ✅ **Messagerie interne** en temps réel
- ✅ **Portail administrateur** avec traçabilité complète

### Pour les Employés
- ✅ **Portail employé** autonome
- ✅ **Consultation des documents** personnels
- ✅ **Demandes de congés** en ligne
- ✅ **Suivi des demandes** et statuts
- ✅ **Consultation des notes de service**
- ✅ **Calendrier des événements**
- ✅ **Gestion du profil** et changement de mot de passe
- ✅ **Messagerie interne**

### Portail Administrateur Système
- ✅ **Gestion des utilisateurs** (RH et Employés)
- ✅ **Statistiques globales** du système
- ✅ **Historique de connexion** détaillé
- ✅ **Traçabilité des suppressions** (audit log)
- ✅ **Alertes système**
- ✅ **Gestion des accès** (blocage/déblocage)

---

## 🛠 Technologies utilisées

### Frontend
- **React 18.2** - Framework JavaScript moderne
- **React Router** - Routage des pages
- **Axios** - Client HTTP
- **Bootstrap 5** - Framework CSS
- **Chart.js** - Graphiques et statistiques
- **React Icons** - Icônes

### Backend
- **Node.js** - Runtime JavaScript
- **Express.js** - Framework web
- **PostgreSQL** - Base de données relationnelle
- **JWT** - Authentification par tokens
- **Multer** - Gestion des uploads de fichiers
- **PDFKit** - Génération de PDFs
- **Socket.io** - Communication temps réel

---

## 📦 Prérequis

Avant de commencer, assurez-vous d'avoir installé :

- **Node.js** (version 14 ou supérieure) - [Télécharger](https://nodejs.org/)
- **npm** (généralement inclus avec Node.js)
- **PostgreSQL** (version 12 ou supérieure) - [Télécharger](https://www.postgresql.org/download/)
- **Git** - [Télécharger](https://git-scm.com/)

---

## 🚀 Installation

### 1. Cloner le dépôt

```bash
git clone https://github.com/pauleCdl2025/sirh2.git
cd sirh2
```

### 2. Installer les dépendances Frontend

```bash
npm install
```

### 3. Installer les dépendances Backend

```bash
cd backend
npm install
cd ..
```

### 4. Configuration de la base de données

#### Créer la base de données PostgreSQL

```bash
# Se connecter à PostgreSQL
psql -U postgres

# Créer la base de données
CREATE DATABASE rh_portal;

# Quitter psql
\q
```

#### Importer le schéma SQL

```bash
# Importer le script SQL complet
psql -U postgres -d rh_portal < database_complete.sql
```

**Alternative** : Si vous préférez exécuter le script manuellement :
```bash
psql -U postgres -d rh_portal -f database_complete.sql
```

---

## ⚙️ Configuration

### 1. Configuration Backend

Créez un fichier `.env` dans le dossier `backend/` :

```bash
cp backend/config.env.example backend/.env
```

Éditez `backend/.env` avec vos paramètres :

```env
# Configuration du serveur
PORT=5000
NODE_ENV=development

# Configuration de la base de données PostgreSQL
DB_USER=postgres
DB_HOST=localhost
DB_NAME=rh_portal
DB_PASSWORD=votre_mot_de_passe
DB_PORT=5432

# Configuration CORS
FRONTEND_URL=http://localhost:3000
CORS_ORIGIN=http://localhost:3000

# Configuration de sécurité
JWT_SECRET=votre-secret-jwt-tres-securise-changez-cela
JWT_EXPIRES_IN=24h

# Configuration des timeouts
REQUEST_TIMEOUT=300000
```

### 2. Configuration Frontend (Optionnel)

Pour le développement local, le frontend utilisera automatiquement `http://localhost:5000/api` comme URL de l'API.

Si vous voulez changer cela, créez un fichier `.env` à la racine :

```env
REACT_APP_API_URL=http://localhost:5000/api
REACT_APP_API_BASE_URL=http://localhost:5000/api
```

---

## ▶️ Démarrage

### Développement Local

#### Terminal 1 - Backend

```bash
cd backend
npm start
```

Le serveur backend démarrera sur `http://localhost:5000`

#### Terminal 2 - Frontend

```bash
npm start
```

Le frontend démarrera sur `http://localhost:3000` et s'ouvrira automatiquement dans votre navigateur.

### Scripts de démarrage automatique (Windows)

Vous pouvez également utiliser les scripts fournis :

```bash
# Démarrage complet (Backend + Frontend)
start_servers.bat

# Ou pour PowerShell
.\start_servers.ps1
```

---

## 📁 Structure du projet

```
sirh2/
├── backend/                 # Application backend Node.js
│   ├── routes/             # Routes API
│   ├── auth/               # Authentification
│   ├── db/                 # Scripts SQL
│   ├── scripts/            # Scripts utilitaires
│   ├── server.js           # Point d'entrée du serveur
│   ├── package.json        # Dépendances backend
│   └── .env                # Configuration backend (à créer)
│
├── src/                    # Application frontend React
│   ├── components/         # Composants React
│   │   ├── admin/         # Composants portail admin
│   │   ├── auth/          # Authentification
│   │   ├── employees/     # Gestion employés
│   │   ├── contracts/     # Gestion contrats
│   │   └── ...
│   ├── services/          # Services API
│   ├── context/           # Contextes React
│   ├── utils/             # Utilitaires
│   └── styles/            # Styles CSS
│
├── public/                 # Fichiers statiques
├── database_complete.sql  # Script SQL complet
├── package.json           # Dépendances frontend
└── README.md             # Ce fichier
```

---

## 👥 Types d'utilisateurs

### 1. Administrateur RH
- **URL** : `http://localhost:3000/login`
- **Accès** : Interface complète de gestion RH
- **Fonctionnalités** : Toutes les fonctionnalités RH disponibles

### 2. Employé
- **URL** : `http://localhost:3000/login` (sélectionner "Employé")
- **Accès** : Portail employé avec fonctionnalités limitées
- **Fonctionnalités** : Consultation documents, demandes de congés, profil

### 3. Administrateur Système
- **URL** : `http://localhost:3000/admin-login`
- **Accès** : Portail administrateur système
- **Fonctionnalités** : Gestion utilisateurs, statistiques, audit logs

### 4. Médecin
- **URL** : `http://localhost:3000/medical-login`
- **Accès** : Suivi des dossiers médicaux
- **Fonctionnalités** : Gestion des visites médicales et procédures

---

## 🔧 Dépannage

### Le backend ne démarre pas

**Erreur : Port déjà utilisé**
```bash
# Vérifier quel processus utilise le port 5000
netstat -ano | findstr :5000

# Tuer le processus (remplacer PID par l'ID du processus)
taskkill /PID <PID> /F
```

**Erreur : Connexion à la base de données échoue**
- Vérifiez que PostgreSQL est démarré
- Vérifiez les identifiants dans `backend/.env`
- Vérifiez que la base de données `rh_portal` existe

### Le frontend ne démarre pas

**Erreur : Port 3000 déjà utilisé**
```bash
# Utiliser un autre port
set PORT=3001
npm start
```

**Erreur : Module non trouvé**
```bash
# Réinstaller les dépendances
rm -rf node_modules package-lock.json
npm install
```

### Erreurs de compilation

**ESLint warnings**
- Les warnings ESLint n'empêchent pas l'application de fonctionner
- Pour les corriger, suivez les suggestions dans la console

**Erreurs de build**
```bash
# Nettoyer le cache
npm cache clean --force
rm -rf node_modules
npm install
```

---

## 🌐 Déploiement en production

Pour déployer en production, consultez le guide détaillé :

📄 [Guide de Déploiement Production](DEPLOIEMENT_PRODUCTION.md)

### Résumé rapide

1. **Configurer les variables d'environnement** de production
2. **Builder le frontend** : `npm run build`
3. **Configurer le serveur** backend avec `.env` de production
4. **Déployer les fichiers** `build/` sur votre serveur web
5. **Démarrer le backend** en mode production

---

## 📚 Documentation complémentaire

- [Manuel d'utilisation complet](MANUEL_UTILISATEUR_COMPLET.md)
- [Guide de configuration production](DEPLOIEMENT_PRODUCTION.md)
- [Résumé configuration production](RESUME_CONFIGURATION_PRODUCTION.md)

---

## 🔒 Sécurité

⚠️ **IMPORTANT** : 
- Ne commitez jamais les fichiers `.env` sur Git
- Changez tous les mots de passe par défaut en production
- Utilisez des secrets JWT forts et uniques
- Configurez correctement CORS pour votre environnement

---

## 📝 Scripts disponibles

### Frontend
- `npm start` - Démarrer le serveur de développement
- `npm run build` - Construire pour la production
- `npm test` - Lancer les tests

### Backend
- `npm start` - Démarrer le serveur (depuis `backend/`)
- `npm run dev` - Démarrer avec nodemon (auto-reload)

---

## 🤝 Contribution

Ce projet est développé pour le Centre Diagnostic. Pour toute question ou suggestion, veuillez contacter l'équipe de développement.

---

## 📄 Licence

Propriétaire - Centre Diagnostic

---

## ✅ Checklist d'installation

- [ ] Node.js et npm installés
- [ ] PostgreSQL installé et démarré
- [ ] Dépôt cloné
- [ ] Dépendances frontend installées (`npm install`)
- [ ] Dépendances backend installées (`cd backend && npm install`)
- [ ] Base de données créée (`rh_portal`)
- [ ] Script SQL exécuté (`database_complete.sql`)
- [ ] Fichier `backend/.env` créé et configuré
- [ ] Backend démarré et fonctionne
- [ ] Frontend démarré et fonctionne
- [ ] Application accessible sur `http://localhost:3000`

---

**🎉 Félicitations ! Votre application SIRH est maintenant prête à être utilisée !**
