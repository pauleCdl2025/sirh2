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

async function createAdminUser() {
  console.log('🔐 Création/Mise à jour de l\'utilisateur administrateur...\n');
  
  try {
    const adminEmail = 'dsi@centre-diagnostic.com';
    const adminPassword = 'Admin@2025CDL'; // Mot de passe par défaut
    
    // Vérifier si l'utilisateur existe déjà
    const existing = await pool.query('SELECT id, email, role, status FROM users WHERE email = $1', [adminEmail]);
    
    if (existing.rows.length > 0) {
      console.log(`✅ Utilisateur ${adminEmail} existe déjà (ID: ${existing.rows[0].id})`);
      
      // Mettre à jour pour être sûr qu'il est admin
      await pool.query(
        'UPDATE users SET role = $1, status = $2, first_name = $3, last_name = $4, updated_at = CURRENT_TIMESTAMP WHERE email = $5',
        ['admin', 'active', 'DSI', 'Administrateur', adminEmail]
      );
      
      // Optionnel: mettre à jour le mot de passe si nécessaire
      const updatePassword = process.argv.includes('--update-password');
      if (updatePassword) {
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(adminPassword, salt);
        await pool.query(
          'UPDATE users SET password = $1, password_changed_at = CURRENT_TIMESTAMP WHERE email = $2',
          [hashedPassword, adminEmail]
        );
        console.log('✅ Mot de passe mis à jour');
      }
      
      console.log('✅ Utilisateur mis à jour avec succès');
    } else {
      // Créer l'utilisateur
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(adminPassword, salt);
      
      const result = await pool.query(
        `INSERT INTO users (email, password, role, status, first_name, last_name, created_at, updated_at)
         VALUES ($1, $2, $3, $4, $5, $6, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
         RETURNING id, email, role`,
        [adminEmail, hashedPassword, 'admin', 'active', 'DSI', 'Administrateur']
      );
      
      console.log(`✅ Utilisateur administrateur créé: ${result.rows[0].email} (ID: ${result.rows[0].id})`);
    }
    
    // Afficher les informations de l'utilisateur
    const user = await pool.query('SELECT id, email, role, status, first_name, last_name FROM users WHERE email = $1', [adminEmail]);
    console.log('\n📋 Informations de l\'utilisateur:');
    console.log(`   Email: ${user.rows[0].email}`);
    console.log(`   Rôle: ${user.rows[0].role}`);
    console.log(`   Status: ${user.rows[0].status}`);
    console.log(`   Nom: ${user.rows[0].first_name} ${user.rows[0].last_name}`);
    
    console.log('\n✅ Opération terminée !');
    console.log(`\n💡 Vous pouvez maintenant vous connecter avec:`);
    console.log(`   Email: ${adminEmail}`);
    console.log(`   Mot de passe: ${adminPassword}`);
    
  } catch (error) {
    console.error('❌ Erreur:', error.message);
    console.error(error);
  } finally {
    await pool.end();
  }
}

createAdminUser();

