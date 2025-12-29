const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_NAME || 'rh_portal',
  password: process.env.DB_PASSWORD || 'Cdl@2025',
  port: parseInt(process.env.DB_PORT) || 5432,
});

async function checkUsersTable() {
  console.log('🔍 Vérification de la table users...\n');
  
  try {
    // 1. Vérifier si la table existe
    console.log('1️⃣ Vérification de l\'existence de la table...');
    const tableExists = await pool.query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'users'
      );
    `);
    
    if (!tableExists.rows[0].exists) {
      console.log('❌ Table users n\'existe PAS');
      console.log('💡 Vous devez exécuter le script database_complete.sql pour créer la table');
      await pool.end();
      return;
    }
    
    console.log('✅ Table users existe');
    
    // 2. Vérifier la structure de la table
    console.log('\n2️⃣ Structure de la table users:');
    const structure = await pool.query(`
      SELECT column_name, data_type, is_nullable, column_default
      FROM information_schema.columns
      WHERE table_name = 'users'
      ORDER BY ordinal_position
    `);
    
    structure.rows.forEach(col => {
      console.log(`   - ${col.column_name}: ${col.data_type} (nullable: ${col.is_nullable})`);
    });
    
    // 3. Compter les utilisateurs
    console.log('\n3️⃣ Nombre d\'utilisateurs dans la table:');
    const count = await pool.query('SELECT COUNT(*) as total FROM users');
    console.log(`   Total: ${count.rows[0].total}`);
    
    // 4. Compter par rôle
    const countByRole = await pool.query(`
      SELECT role, COUNT(*) as count 
      FROM users 
      GROUP BY role
      ORDER BY count DESC
    `);
    console.log('\n4️⃣ Répartition par rôle:');
    countByRole.rows.forEach(row => {
      console.log(`   - ${row.role || 'NULL'}: ${row.count}`);
    });
    
    // 5. Vérifier si la colonne nom_prenom existe
    console.log('\n5️⃣ Vérification de la colonne nom_prenom:');
    const nomPrenomExists = await pool.query(`
      SELECT column_name 
      FROM information_schema.columns 
      WHERE table_name = 'users' AND column_name = 'nom_prenom'
    `);
    console.log(`   Colonne nom_prenom existe: ${nomPrenomExists.rows.length > 0 ? 'OUI' : 'NON'}`);
    
    // 6. Récupérer tous les utilisateurs RH et Admin
    console.log('\n6️⃣ Utilisateurs RH et Admin:');
    let rhQuery = `
      SELECT 
        id, 
        email, 
        COALESCE(first_name, '') as first_name, 
        COALESCE(last_name, '') as last_name,
        COALESCE(role, 'rh') as role, 
        COALESCE(status, 'active') as status, 
        last_login, 
        created_at
    `;
    
    if (nomPrenomExists.rows.length > 0) {
      rhQuery += `, COALESCE(nom_prenom, '') as nom_prenom`;
    }
    
    rhQuery += `
      FROM users 
      WHERE role IN ('admin', 'rh')
      ORDER BY COALESCE(created_at, '1970-01-01'::timestamp) DESC
    `;
    
    const rhUsers = await pool.query(rhQuery);
    
    console.log(`   Nombre d'utilisateurs RH/Admin: ${rhUsers.rows.length}`);
    if (rhUsers.rows.length > 0) {
      console.log('\n   Liste des utilisateurs:');
      rhUsers.rows.forEach((user, index) => {
        console.log(`   ${index + 1}. ID: ${user.id}, Email: ${user.email}, Role: ${user.role}, Nom: ${user.nom_prenom || `${user.first_name} ${user.last_name}`.trim() || 'N/A'}, Status: ${user.status}`);
      });
    } else {
      console.log('   ⚠️ Aucun utilisateur RH ou Admin trouvé dans la table');
      console.log('   💡 Vous devez créer des utilisateurs RH/Admin dans la table');
    }
    
    // 7. Vérifier tous les utilisateurs (tous rôles)
    console.log('\n7️⃣ Tous les utilisateurs (tous rôles):');
    const allUsers = await pool.query('SELECT id, email, role, status FROM users ORDER BY id');
    if (allUsers.rows.length > 0) {
      allUsers.rows.forEach(user => {
        console.log(`   - ID: ${user.id}, Email: ${user.email}, Role: ${user.role || 'NULL'}, Status: ${user.status || 'NULL'}`);
      });
    } else {
      console.log('   ⚠️ La table users est vide');
    }
    
  } catch (error) {
    console.error('❌ Erreur:', error.message);
    console.error(error);
  } finally {
    await pool.end();
  }
}

checkUsersTable();

