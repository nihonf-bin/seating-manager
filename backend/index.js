const express = require('express');
const sqlite3 = require('sqlite3').verbose();

const app=express();
const port = 3000;

const db = new sqlite3.Database('./test.db', (err) => {
    if (err) {
      console.error('Error connecting to the database:', err.message);
    } else {
      console.log('Connected to the SQLite database.');
    }
  });
  
app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
});