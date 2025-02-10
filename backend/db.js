const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'pass',
  database: 'seating_manager'
});

pool.getConnection()
  .then(connection => {
    console.log('Connected to the MySQL database.');
    connection.release();
  })
  .catch(err => {
    console.error('Error connecting to the database:', err.stack);
  });

module.exports = pool;