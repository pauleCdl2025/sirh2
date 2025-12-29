-- ================================================================
-- Script SQL complet pour la base de données RH Portal
-- Base de données PostgreSQL
-- Créé le: 2025-01-XX
-- ================================================================

-- Configuration de l'encodage
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

-- ================================================================
-- TABLE: employees - Table principale des employés
-- ================================================================
CREATE TABLE IF NOT EXISTS employees (
  id SERIAL PRIMARY KEY,
  statut_dossier VARCHAR(255),
  matricule VARCHAR(50) UNIQUE NOT NULL,
  nom_prenom VARCHAR(255) NOT NULL,
  genre VARCHAR(10),
  date_naissance DATE,
  age INT,
  age_restant INT,
  date_retraite DATE,
  date_entree DATE,
  lieu VARCHAR(100),
  adresse VARCHAR(255),
  telephone VARCHAR(50),
  email VARCHAR(255),
  cnss_number VARCHAR(50),
  cnamgs_number VARCHAR(50),
  poste_actuel VARCHAR(255),
  type_contrat VARCHAR(50),
  date_fin_contrat DATE,
  employee_type VARCHAR(50),
  nationalite VARCHAR(100),
  functional_area VARCHAR(100),
  entity VARCHAR(50),
  responsable VARCHAR(100),
  statut_employe VARCHAR(50),
  statut_marital VARCHAR(50),
  enfants INT,
  niveau_etude VARCHAR(100),
  anciennete VARCHAR(50),
  specialisation TEXT,
  type_remuneration VARCHAR(50),
  payment_mode VARCHAR(50),
  categorie VARCHAR(50),
  salaire_base NUMERIC(10, 2),
  salaire_net NUMERIC(10, 2),
  prime_responsabilite NUMERIC(10, 2),
  prime_penibilite NUMERIC(10, 2),
  prime_logement NUMERIC(10, 2),
  prime_transport NUMERIC(10, 2),
  prime_anciennete NUMERIC(10, 2),
  prime_enfant NUMERIC(10, 2),
  prime_representation NUMERIC(10, 2),
  prime_performance NUMERIC(10, 2),
  prime_astreinte NUMERIC(10, 2),
  honoraires NUMERIC(10, 2),
  indemnite_stage NUMERIC(10, 2),
  timemoto_id VARCHAR(50),
  password VARCHAR(255),
  emergency_contact VARCHAR(100),
  emergency_phone VARCHAR(50),
  last_login TIMESTAMP,
  password_initialized BOOLEAN DEFAULT FALSE,
  first_login_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour employees
CREATE INDEX IF NOT EXISTS idx_employees_matricule ON employees(matricule);
CREATE INDEX IF NOT EXISTS idx_employees_statut ON employees(statut_employe);
CREATE INDEX IF NOT EXISTS idx_employees_departement ON employees(functional_area);

-- ================================================================
-- TABLE: employee_documents - Documents des employés
-- ================================================================
CREATE TABLE IF NOT EXISTS employee_documents (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER REFERENCES employees(id) ON DELETE CASCADE,
  document_type VARCHAR(50) NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(255) NOT NULL,
  upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_employee FOREIGN KEY (employee_id) REFERENCES employees(id)
);

-- ================================================================
-- TABLE: users - Utilisateurs RH
-- ================================================================
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(100) UNIQUE,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  nom_prenom VARCHAR(255),
  role VARCHAR(50) DEFAULT 'user',
  status VARCHAR(20) DEFAULT 'active',
  last_login TIMESTAMP,
  password_changed_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_by VARCHAR(255),
  updated_by VARCHAR(255)
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_status ON users(status);

-- ================================================================
-- TABLE: login_history - Historique des connexions
-- ================================================================
CREATE TABLE IF NOT EXISTS login_history (
  id SERIAL PRIMARY KEY,
  user_type VARCHAR(20) NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  matricule VARCHAR(50),
  role VARCHAR(50),
  ip_address VARCHAR(45),
  user_agent TEXT,
  login_status VARCHAR(20) NOT NULL,
  failure_reason TEXT,
  login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  logout_time TIMESTAMP,
  session_duration INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_login_history_user_type ON login_history(user_type);
CREATE INDEX IF NOT EXISTS idx_login_history_user_id ON login_history(user_id);
CREATE INDEX IF NOT EXISTS idx_login_history_login_time ON login_history(login_time DESC);
CREATE INDEX IF NOT EXISTS idx_login_history_email ON login_history(email);
CREATE INDEX IF NOT EXISTS idx_login_history_matricule ON login_history(matricule);

-- ================================================================
-- TABLE: audit_logs - Journal d'audit pour toutes les actions
-- ================================================================
CREATE TABLE IF NOT EXISTS audit_logs (
  id SERIAL PRIMARY KEY,
  action_type VARCHAR(50) NOT NULL,
  entity_type VARCHAR(50) NOT NULL,
  entity_id VARCHAR(255) NOT NULL,
  entity_name VARCHAR(255),
  user_type VARCHAR(20) NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  user_email VARCHAR(255),
  changes JSONB,
  description TEXT,
  ip_address VARCHAR(45),
  user_agent TEXT,
  status VARCHAR(20) DEFAULT 'success',
  error_message TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_audit_logs_action_type ON audit_logs(action_type);
CREATE INDEX IF NOT EXISTS idx_audit_logs_entity_type ON audit_logs(entity_type);
CREATE INDEX IF NOT EXISTS idx_audit_logs_entity_id ON audit_logs(entity_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_type ON audit_logs(user_type);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON audit_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_entity_type_action ON audit_logs(entity_type, action_type);

-- ================================================================
-- TABLE: contrats - Contrats des employés
-- ================================================================
CREATE TABLE IF NOT EXISTS contrats (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER,
  nom_employe VARCHAR(255) NOT NULL,
  type_contrat VARCHAR(100) NOT NULL,
  date_debut DATE NOT NULL,
  date_fin DATE,
  poste VARCHAR(255) DEFAULT '',
  service VARCHAR(255) DEFAULT '',
  statut VARCHAR(50) DEFAULT 'Actif',
  contrat_content TEXT,
  salaire DECIMAL(10,2),
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_contrat_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_contrats_employee_id ON contrats(employee_id);
CREATE INDEX IF NOT EXISTS idx_contrats_statut ON contrats(statut);
CREATE INDEX IF NOT EXISTS idx_contrats_date_debut ON contrats(date_debut);

-- ================================================================
-- TABLE: contrat_history - Historique des actions sur les contrats
-- ================================================================
CREATE TABLE IF NOT EXISTS contrat_history (
  id SERIAL PRIMARY KEY,
  contrat_id INTEGER NOT NULL,
  action VARCHAR(100) NOT NULL,
  description TEXT,
  user_name VARCHAR(255),
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_contrat_history_contrat FOREIGN KEY (contrat_id) REFERENCES contrats(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_contrat_history_contrat_id ON contrat_history(contrat_id);
CREATE INDEX IF NOT EXISTS idx_contrat_history_timestamp ON contrat_history(timestamp);
CREATE INDEX IF NOT EXISTS idx_contrat_history_action ON contrat_history(action);

-- ================================================================
-- TABLE: conges - Congés des employés
-- ================================================================
CREATE TABLE IF NOT EXISTS conges (
  id SERIAL PRIMARY KEY,
  nom_employe VARCHAR(255) NOT NULL,
  service VARCHAR(255),
  poste VARCHAR(255),
  date_embauche DATE,
  jours_conges_annuels INTEGER,
  date_demande DATE DEFAULT CURRENT_DATE,
  date_debut DATE NOT NULL,
  date_fin DATE NOT NULL,
  motif TEXT,
  date_retour DATE,
  jours_pris INTEGER,
  jours_restants INTEGER,
  date_prochaine_attribution DATE,
  type_conge VARCHAR(50) DEFAULT 'Congé payé',
  statut VARCHAR(20) DEFAULT 'En attente',
  date_traitement TIMESTAMP,
  document_path VARCHAR(255)
);

CREATE INDEX IF NOT EXISTS idx_conges_employee ON conges(nom_employe);
CREATE INDEX IF NOT EXISTS idx_conges_status ON conges(statut);

-- ================================================================
-- TABLE: leave_requests - Demandes de congé
-- ================================================================
CREATE TABLE IF NOT EXISTS leave_requests (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER NOT NULL,
  leave_type VARCHAR(50) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  days_requested INTEGER,
  reason TEXT,
  status VARCHAR(50) DEFAULT 'pending',
  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  approved_by INTEGER,
  rejected_by INTEGER,
  approval_date TIMESTAMP,
  rejection_date TIMESTAMP,
  rejection_reason TEXT,
  CONSTRAINT fk_leave_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_leave_requests_employee_id ON leave_requests(employee_id);
CREATE INDEX IF NOT EXISTS idx_leave_requests_status ON leave_requests(status);

-- ================================================================
-- TABLE: absence - Absences des employés
-- ================================================================
CREATE TABLE IF NOT EXISTS absence (
  id SERIAL PRIMARY KEY,
  nom_employe VARCHAR(255) NOT NULL,
  service VARCHAR(255),
  poste VARCHAR(255),
  type_absence VARCHAR(100),
  motif TEXT,
  date_debut DATE NOT NULL,
  date_fin DATE NOT NULL,
  statut VARCHAR(20) DEFAULT 'En attente',
  date_traitement TIMESTAMP,
  document_path VARCHAR(255),
  date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_retour DATE,
  remuneration VARCHAR(50),
  date_modification TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_absences_employe ON absence(nom_employe);
CREATE INDEX IF NOT EXISTS idx_absences_date ON absence(date_debut);

-- ================================================================
-- TABLE: employee_requests - Demandes des employés
-- ================================================================
CREATE TABLE IF NOT EXISTS employee_requests (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER NOT NULL,
  request_type VARCHAR(50) NOT NULL,
  request_details TEXT,
  start_date DATE,
  end_date DATE,
  reason TEXT,
  status VARCHAR(20) DEFAULT 'pending',
  request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  response_date TIMESTAMP,
  response_comments TEXT,
  start_time TIME,
  end_time TIME,
  CONSTRAINT fk_employee_requests_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_employee_requests_employee_id ON employee_requests(employee_id);
CREATE INDEX IF NOT EXISTS idx_employee_requests_status ON employee_requests(status);
CREATE INDEX IF NOT EXISTS idx_employee_requests_type ON employee_requests(request_type);

-- ================================================================
-- TABLE: request_files - Fichiers associés aux demandes
-- ================================================================
CREATE TABLE IF NOT EXISTS request_files (
  id SERIAL PRIMARY KEY,
  request_id INTEGER NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  original_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(500) NOT NULL,
  file_size INTEGER NOT NULL,
  file_type VARCHAR(100) NOT NULL,
  upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  uploaded_by INTEGER NOT NULL,
  description TEXT,
  is_approved BOOLEAN DEFAULT FALSE,
  approval_date TIMESTAMP,
  approved_by INTEGER,
  approval_comments TEXT,
  CONSTRAINT fk_request_files_request_id FOREIGN KEY (request_id) REFERENCES employee_requests(id) ON DELETE CASCADE,
  CONSTRAINT fk_request_files_uploaded_by FOREIGN KEY (uploaded_by) REFERENCES employees(id) ON DELETE CASCADE,
  CONSTRAINT fk_request_files_approved_by FOREIGN KEY (approved_by) REFERENCES employees(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_request_files_request_id ON request_files(request_id);
CREATE INDEX IF NOT EXISTS idx_request_files_uploaded_by ON request_files(uploaded_by);
CREATE INDEX IF NOT EXISTS idx_request_files_is_approved ON request_files(is_approved);

-- ================================================================
-- TABLE: file_comments - Commentaires sur les fichiers
-- ================================================================
CREATE TABLE IF NOT EXISTS file_comments (
  id SERIAL PRIMARY KEY,
  file_id INTEGER NOT NULL,
  commenter_id INTEGER NOT NULL,
  comment_text TEXT NOT NULL,
  comment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_internal BOOLEAN DEFAULT FALSE,
  CONSTRAINT fk_file_comments_file_id FOREIGN KEY (file_id) REFERENCES request_files(id) ON DELETE CASCADE,
  CONSTRAINT fk_file_comments_commenter_id FOREIGN KEY (commenter_id) REFERENCES employees(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_file_comments_file_id ON file_comments(file_id);
CREATE INDEX IF NOT EXISTS idx_file_comments_commenter_id ON file_comments(commenter_id);

-- ================================================================
-- TABLE: sanctions_table - Sanctions
-- ================================================================
CREATE TABLE IF NOT EXISTS sanctions_table (
  id SERIAL PRIMARY KEY,
  nom_employe VARCHAR(100) NOT NULL,
  type_sanction VARCHAR(50) NOT NULL,
  contenu_sanction TEXT NOT NULL,
  date DATE NOT NULL,
  statut VARCHAR(20) NOT NULL DEFAULT 'En cours',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_sanctions_nom_employe ON sanctions_table(nom_employe);
CREATE INDEX IF NOT EXISTS idx_sanctions_date ON sanctions_table(date);

-- ================================================================
-- TABLE: notes - Notes de service
-- ================================================================
CREATE TABLE IF NOT EXISTS notes (
  id SERIAL PRIMARY KEY,
  full_note_number VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL,
  title VARCHAR(100) NOT NULL,
  content TEXT NOT NULL,
  is_public BOOLEAN DEFAULT FALSE,
  created_by VARCHAR(100) DEFAULT 'Admin RH',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- TABLE: messages - Messages entre RH et employés
-- ================================================================
CREATE TABLE IF NOT EXISTS messages (
  id SERIAL PRIMARY KEY,
  sender_id INTEGER NOT NULL,
  sender_name VARCHAR(255) NOT NULL,
  sender_type VARCHAR(50) NOT NULL CHECK (sender_type IN ('rh', 'employee')),
  receiver_id INTEGER NOT NULL,
  receiver_name VARCHAR(255) NOT NULL,
  receiver_type VARCHAR(50) NOT NULL CHECK (receiver_type IN ('rh', 'employee')),
  content TEXT NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_messages_sender ON messages(sender_id, sender_type);
CREATE INDEX IF NOT EXISTS idx_messages_receiver ON messages(receiver_id, receiver_type);
CREATE INDEX IF NOT EXISTS idx_messages_timestamp ON messages(timestamp DESC);

-- ================================================================
-- TABLE: employee_notifications - Notifications pour les employés
-- ================================================================
CREATE TABLE IF NOT EXISTS employee_notifications (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER NOT NULL,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT,
  data JSONB,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  read_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT fk_employee_notifications_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_employee_notifications_employee_id ON employee_notifications(employee_id);
CREATE INDEX IF NOT EXISTS idx_employee_notifications_type ON employee_notifications(type);
CREATE INDEX IF NOT EXISTS idx_employee_notifications_is_read ON employee_notifications(is_read);

-- ================================================================
-- TABLE: password_reset_tokens - Tokens de réinitialisation
-- ================================================================
CREATE TABLE IF NOT EXISTS password_reset_tokens (
  id SERIAL PRIMARY KEY,
  matricule VARCHAR(20) NOT NULL,
  token VARCHAR(255) NOT NULL UNIQUE,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  used_at TIMESTAMP NULL,
  CONSTRAINT fk_employee_matricule FOREIGN KEY (matricule) REFERENCES employees(matricule) ON DELETE CASCADE,
  CONSTRAINT unique_active_token UNIQUE (matricule, token)
);

CREATE INDEX IF NOT EXISTS idx_reset_tokens_matricule ON password_reset_tokens(matricule);
CREATE INDEX IF NOT EXISTS idx_reset_tokens_token ON password_reset_tokens(token);
CREATE INDEX IF NOT EXISTS idx_reset_tokens_expires ON password_reset_tokens(expires_at);

-- ================================================================
-- TABLE: tasks - Tâches
-- ================================================================
CREATE TABLE IF NOT EXISTS tasks (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  assignee VARCHAR(255) NOT NULL,
  priority VARCHAR(50) DEFAULT 'medium',
  status VARCHAR(50) DEFAULT 'pending',
  due_date DATE NOT NULL,
  category VARCHAR(100),
  estimated_hours INTEGER,
  progress INTEGER DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_tasks_assignee ON tasks(assignee);
CREATE INDEX IF NOT EXISTS idx_tasks_due_date ON tasks(due_date);

-- ================================================================
-- TABLE: interviews - Entretiens
-- ================================================================
CREATE TABLE IF NOT EXISTS interviews (
  id SERIAL PRIMARY KEY,
  candidate_name VARCHAR(255) NOT NULL,
  position VARCHAR(255) NOT NULL,
  interviewer VARCHAR(255) NOT NULL,
  interview_date DATE NOT NULL,
  interview_time TIME NOT NULL,
  duration INTEGER DEFAULT 60,
  interview_type VARCHAR(50) DEFAULT 'face_to_face',
  status VARCHAR(50) DEFAULT 'scheduled',
  notes TEXT,
  location VARCHAR(255),
  department VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_interviews_status ON interviews(status);
CREATE INDEX IF NOT EXISTS idx_interviews_date ON interviews(interview_date);

-- ================================================================
-- TABLE: historique_recrutement - Historique de recrutement
-- ================================================================
CREATE TABLE IF NOT EXISTS historique_recrutement (
  id SERIAL PRIMARY KEY,
  nom VARCHAR(100) NOT NULL,
  prenom VARCHAR(100) NOT NULL,
  departement VARCHAR(100) NOT NULL,
  motif_recrutement VARCHAR(100) NOT NULL,
  date_recrutement DATE NOT NULL,
  type_contrat VARCHAR(50) NOT NULL,
  poste VARCHAR(100) NOT NULL,
  superieur_hierarchique VARCHAR(100) NOT NULL,
  date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  cv_path VARCHAR(255),
  notes TEXT
);

CREATE INDEX IF NOT EXISTS idx_nom_prenom ON historique_recrutement(nom, prenom);
CREATE INDEX IF NOT EXISTS idx_date_recrutement ON historique_recrutement(date_recrutement);

-- ================================================================
-- TABLE: recrutement_history - Nouvelle table de recrutement
-- ================================================================
CREATE TABLE IF NOT EXISTS recrutement_history (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER,
  nom_prenom VARCHAR(255),
  date_recrutement DATE NOT NULL,
  date_fin DATE,
  poste_recrute VARCHAR(100) NOT NULL,
  type_contrat VARCHAR(100),
  salaire_propose DECIMAL(10,2),
  source_recrutement VARCHAR(100),
  notes TEXT,
  statut VARCHAR(50) DEFAULT 'En cours',
  email VARCHAR(255),
  telephone VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_recrutement_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
  CONSTRAINT check_recrutement_statut CHECK (statut IN ('En cours', 'Recruté', 'Parti', 'Annulé'))
);

CREATE INDEX IF NOT EXISTS idx_recrutement_employee_id ON recrutement_history(employee_id);
CREATE INDEX IF NOT EXISTS idx_recrutement_date ON recrutement_history(date_recrutement);

-- ================================================================
-- TABLE: historique_departs - Historique des départs
-- ================================================================
CREATE TABLE IF NOT EXISTS historique_departs (
  id SERIAL PRIMARY KEY,
  nom VARCHAR(100) NOT NULL,
  prenom VARCHAR(100) NOT NULL,
  departement VARCHAR(100) NOT NULL,
  statut VARCHAR(50) NOT NULL,
  poste VARCHAR(100) NOT NULL,
  date_depart DATE NOT NULL,
  motif_depart VARCHAR(100) NOT NULL,
  commentaire TEXT,
  date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_nom_prenom_depart ON historique_departs(nom, prenom);
CREATE INDEX IF NOT EXISTS idx_date_depart ON historique_departs(date_depart);

-- ================================================================
-- TABLE: depart_history - Nouvelle table des départs
-- ================================================================
CREATE TABLE IF NOT EXISTS depart_history (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER,
  date_depart DATE NOT NULL,
  motif_depart TEXT,
  type_depart VARCHAR(100) DEFAULT 'Démission',
  notes TEXT,
  nom_prenom VARCHAR(255),
  matricule VARCHAR(50),
  poste_actuel VARCHAR(255),
  departement VARCHAR(100),
  statut VARCHAR(50),
  email VARCHAR(255),
  telephone VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_by VARCHAR(255),
  CONSTRAINT fk_depart_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_depart_employee_id ON depart_history(employee_id);
CREATE INDEX IF NOT EXISTS idx_depart_date ON depart_history(date_depart);

-- ================================================================
-- TABLE: evenements - Événements
-- ================================================================
CREATE TABLE IF NOT EXISTS evenements (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  date DATE NOT NULL,
  location VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- TABLE: visites_medicales - Visites médicales
-- ================================================================
CREATE TABLE IF NOT EXISTS visites_medicales (
  id SERIAL PRIMARY KEY,
  nom VARCHAR(100) NOT NULL,
  prenom VARCHAR(100) NOT NULL,
  poste VARCHAR(100) NOT NULL,
  date_derniere_visite DATE NOT NULL,
  date_prochaine_visite DATE NOT NULL,
  statut VARCHAR(50) NOT NULL DEFAULT 'À venir',
  notes TEXT,
  date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- TABLE: onboarding_history - Historique d'onboarding
-- ================================================================
CREATE TABLE IF NOT EXISTS onboarding_history (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER NOT NULL,
  date_integration DATE NOT NULL,
  checklist JSONB DEFAULT '{}',
  documents TEXT[] DEFAULT '{}',
  notes TEXT,
  statut VARCHAR(50) DEFAULT 'Terminé',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_onboarding_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
  CONSTRAINT check_onboarding_statut CHECK (statut IN ('En cours', 'Terminé', 'Annulé'))
);

CREATE INDEX IF NOT EXISTS idx_onboarding_employee_id ON onboarding_history(employee_id);
CREATE INDEX IF NOT EXISTS idx_onboarding_date ON onboarding_history(date_integration);

-- ================================================================
-- TABLE: offboarding_history - Historique d'offboarding
-- ================================================================
CREATE TABLE IF NOT EXISTS offboarding_history (
  id SERIAL PRIMARY KEY,
  employee_id INTEGER NOT NULL,
  date_depart DATE NOT NULL,
  motif_depart TEXT,
  checklist JSONB DEFAULT '{}',
  documents TEXT[] DEFAULT '{}',
  notes TEXT,
  statut VARCHAR(50) DEFAULT 'Terminé',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_offboarding_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
  CONSTRAINT check_offboarding_statut CHECK (statut IN ('En cours', 'Terminé', 'Annulé'))
);

CREATE INDEX IF NOT EXISTS idx_offboarding_employee_id ON offboarding_history(employee_id);
CREATE INDEX IF NOT EXISTS idx_offboarding_date ON offboarding_history(date_depart);

-- ================================================================
-- FONCTIONS ET TRIGGERS
-- ================================================================

-- Fonction pour mettre à jour updated_at automatiquement
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger pour users
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger pour absence
CREATE OR REPLACE FUNCTION update_absence_timestamp()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = now();
   NEW.date_modification = now();
   RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_absence_timestamp ON absence;
CREATE TRIGGER update_absence_timestamp
BEFORE UPDATE ON absence
FOR EACH ROW
EXECUTE FUNCTION update_absence_timestamp();

-- Trigger pour sanctions
CREATE OR REPLACE FUNCTION update_sanctions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_sanctions_timestamp ON sanctions_table;
CREATE TRIGGER update_sanctions_timestamp
BEFORE UPDATE ON sanctions_table
FOR EACH ROW
EXECUTE FUNCTION update_sanctions_updated_at();

-- Trigger pour messages
CREATE OR REPLACE FUNCTION update_messages_updated_at()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_messages_modtime ON messages;
CREATE TRIGGER update_messages_modtime
BEFORE UPDATE ON messages
FOR EACH ROW
EXECUTE FUNCTION update_messages_updated_at();

-- Trigger pour evenements
CREATE OR REPLACE FUNCTION update_evenement_modtime()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = now(); 
   RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_evenement_modtime ON evenements;
CREATE TRIGGER update_evenement_modtime
BEFORE UPDATE ON evenements
FOR EACH ROW
EXECUTE FUNCTION update_evenement_modtime();

-- Trigger pour historique_recrutement
CREATE OR REPLACE FUNCTION update_date_modification()
RETURNS TRIGGER AS $$
BEGIN
   NEW.date_modification = CURRENT_TIMESTAMP; 
   RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_historique_recrutement_date_modification ON historique_recrutement;
CREATE TRIGGER update_historique_recrutement_date_modification
BEFORE UPDATE ON historique_recrutement
FOR EACH ROW
EXECUTE FUNCTION update_date_modification();

-- Trigger pour historique_departs
CREATE OR REPLACE FUNCTION update_historique_departs_modtime()
RETURNS TRIGGER AS $$
BEGIN
   NEW.date_modification = NOW(); 
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_historique_departs_modtime ON historique_departs;
CREATE TRIGGER update_historique_departs_modtime
BEFORE UPDATE ON historique_departs
FOR EACH ROW
EXECUTE FUNCTION update_historique_departs_modtime();

-- ================================================================
-- VUES UTILES (optionnel)
-- ================================================================

-- Vue pour les employés avec onboarding
CREATE OR REPLACE VIEW v_employees_onboarding AS
SELECT 
  e.id,
  e.matricule,
  e.nom_prenom,
  e.email,
  e.poste_actuel,
  e.entity,
  e.functional_area as departement,
  e.type_contrat,
  e.date_entree,
  e.statut_employe as statut,
  oh.date_integration,
  oh.checklist as onboarding_checklist,
  oh.documents as onboarding_documents,
  oh.notes as onboarding_notes
FROM employees e
LEFT JOIN onboarding_history oh ON e.id = oh.employee_id
WHERE e.statut_employe = 'Actif'
ORDER BY e.nom_prenom;

-- Vue pour les employés avec offboarding
CREATE OR REPLACE VIEW v_employees_offboarding AS
SELECT 
  e.id,
  e.matricule,
  e.nom_prenom,
  e.poste_actuel,
  e.entity,
  e.functional_area as departement,
  e.date_fin_contrat as date_depart,
  oh.date_depart as offboarding_date,
  oh.motif_depart,
  oh.checklist as offboarding_checklist,
  oh.documents as offboarding_documents,
  oh.notes as offboarding_notes
FROM employees e
LEFT JOIN offboarding_history oh ON e.id = oh.employee_id
WHERE e.statut_employe = 'Inactif'
ORDER BY e.date_fin_contrat DESC;

-- ================================================================
-- FIN DU SCRIPT
-- ================================================================


