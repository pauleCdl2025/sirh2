const { Pool } = require('pg');
require('dotenv').config();
const bcrypt = require('bcryptjs');

const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_NAME || 'rh_portal',
  password: process.env.DB_PASSWORD || 'Cdl@2025',
  port: parseInt(process.env.DB_PORT) || 5432,
});

async function createTestUsers() {
  console.log('🔐 Création d\'utilisateurs de test...\n');
  
  try {
    // Vérifier si la table existe
    const tableCheck = await pool.query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'users'
      );
    `);
    
    if (!tableCheck.rows[0].exists) {
      console.log('❌ Table users n\'existe pas. Veuillez exécuter database_complete.sql d\'abord.');
      await pool.end();
      return;
    }
    
    // Vérifier les utilisateurs existants
    const existingUsers = await pool.query('SELECT email, role FROM users');
    console.log(`📊 Utilisateurs existants: ${existingUsers.rows.length}`);
    
    // Liste des utilisateurs à créer
    const usersToCreate = [
      {
        email: 'administrateur@centrediagnostic.ga',
        password: 'Admin@2025CDL',
        role: 'admin',
        first_name: 'Administrateur',
        last_name: 'Système',
        status: 'active'
      },
      {
        email: 'rh@centre-diagnostic.com',
        password: 'Rh@2025CDL',
        role: 'rh',
        first_name: 'RH',
        last_name: 'Utilisateur',
        status: 'active'
      }
    ];
    
    for (const userData of usersToCreate) {
      // Vérifier si l'utilisateur existe déjà
      const existing = await pool.query('SELECT id FROM users WHERE email = $1', [userData.email]);
      
      if (existing.rows.length > 0) {
        console.log(`⚠️ Utilisateur ${userData.email} existe déjà (ID: ${existing.rows[0].id})`);
        
        // Mettre à jour le rôle et le statut si nécessaire
        await pool.query(
          'UPDATE users SET role = $1, status = $2, first_name = $3, last_name = $4, updated_at = CURRENT_TIMESTAMP WHERE email = $5',
          [userData.role, userData.status, userData.first_name, userData.last_name, userData.email]
        );
        console.log(`✅ Utilisateur ${userData.email} mis à jour`);
        continue;
      }
      
      // Hasher le mot de passe
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(userData.password, salt);
      
      // Créer l'utilisateur
      const result = await pool.query(
        `INSERT INTO users (email, password, role, status, first_name, last_name, created_at, updated_at)
         VALUES ($1, $2, $3, $4, $5, $6, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
         RETURNING id, email, role`,
        [userData.email, hashedPassword, userData.role, userData.status, userData.first_name, userData.last_name]
      );
      
      console.log(`✅ Utilisateur créé: ${result.rows[0].email} (ID: ${result.rows[0].id}, Role: ${result.rows[0].role})`);
    }
    
    // Afficher tous les utilisateurs
    console.log('\n📋 Liste de tous les utilisateurs:');
    const allUsers = await pool.query('SELECT id, email, role, status, first_name, last_name FROM users ORDER BY id');
    allUsers.rows.forEach(user => {
      console.log(`   - ID: ${user.id}, Email: ${user.email}, Role: ${user.role}, Nom: ${user.first_name} ${user.last_name}, Status: ${user.status}`);
    });
    
    console.log('\n✅ Création terminée !');
    
  } catch (error) {
    console.error('❌ Erreur:', error.message);
    console.error(error);
  } finally {
    await pool.end();
  }
}

createTestUsers();

