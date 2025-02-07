const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

app.use(bodyParser.json());

const db = new sqlite3.Database('./project.db', (err) => {
  if (err) {
    console.error('Error connecting to the database:', err.message);
  } else {
    console.log('Connected to the SQLite database.');
  }
});

app.get('/', (req, res) => {
  const query = 'SELECT * FROM employeedb';
  db.all(query, [], (err, rows) => {
    if (err) {
      console.error('Error fetching data:', err.message);
      res.status(500).send('Error fetching data');
    } else {
      console.log('Fetched rows:', rows);
      res.send(`
        <h1>Employee Data</h1>
        <ul>
          ${rows.map(row => `<li>emploeid: ${row.employeeid}, employeename: ${row.employeename}, teamcolour: ${row.teamcolour}</li>`).join('')}
        </ul>
      `);
    }
  });
});

app.post('/employees', (req, res) => {
  const { employeeid, employeename, companyname, teamcolour } = req.body;
  const query = 'INSERT INTO employeedb (employeeid, employeename, companyname, teamcolour) VALUES (?, ?, ?, ?)';
  db.run(query, [employeeid, employeename, companyname, teamcolour], function(err) {
    if (err) {
      console.error('Error inserting data:', err.message);
      res.status(500).send('Error inserting data');
    } else {
      res.status(201).send(`Employee added with ID: ${this.lastID}`);
    }
  });
});

app.get('/employees', (req, res) => {
  const query = 'SELECT * FROM employeedb';
  db.all(query, [], (err, rows) => {
    if (err) {
      console.error('Error fetching data:', err.message);
      res.status(500).send('Error fetching data');
    } else {
      res.json(rows);
    }
  });
});

app.get('/employees/:id', (req, res) => {
  const query = 'SELECT * FROM employeedb WHERE employeeid = ?';
  db.get(query, [req.params.id], (err, row) => {
    if (err) {
      console.error('Error fetching data:', err.message);
      res.status(500).send('Error fetching data');
    } else {
      res.json(row);
    }
  });
});

app.put('/employees/:id', (req, res) => {
  const { employeename, companyname, teamcolour } = req.body;
  const query = 'UPDATE employeedb SET employeename = ?, companyname = ?, teamcolour = ? WHERE employeeid = ?';
  db.run(query, [employeename, companyname, teamcolour, req.params.id], function(err) {
    if (err) {
      console.error('Error updating data:', err.message);
      res.status(500).send('Error updating data');
    } else {
      res.send(`Employee updated with ID: ${req.params.id}`);
    }
  });
});

app.delete('/employees/:id', (req, res) => {
  const query = 'DELETE FROM employeedb WHERE employeeid = ?';
  db.run(query, [req.params.id], function(err) {
    if (err) {
      console.error('Error deleting data:', err.message);
      res.status(500).send('Error deleting data');
    } else {
      res.send(`Employee deleted with ID: ${req.params.id}`);
    }
  });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});