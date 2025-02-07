const express = require('express');
const { generateExcel } = require('./excelGenerator');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();

const router = express.Router();

const db = new sqlite3.Database('./project.db', (err) => {
  if (err) {
    console.error('Error connecting to the database:', err.message);
  } else {
    console.log('Connected to the SQLite database.');
  }
});

router.get('/', (req, res) => {
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

router.post('/employees', (req, res) => {
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

router.get('/employees', (req, res) => {
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

router.get('/employees/:id', (req, res) => {
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

router.put('/employees/:id', (req, res) => {
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

router.delete('/employees/:id', (req, res) => {
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

router.get('/schedule', (req, res) => {
    const query = 'SELECT * FROM schedulesdb';
    db.all(query, [], (err, rows) => {
      if (err) {
        console.error('Error fetching data:', err.message);
        res.status(500).send('Error fetching data');
      } else {
        res.json(rows);
      }
    });
});

router.get('/schedule/:id', (req, res) => {
  const query = 'SELECT * FROM schedulesdb WHERE person_id = ?';
  db.all(query, [req.params.id], async (err, rows) => {
    if (err) {
      console.error('Error fetching data:', err.message);
      res.status(500).send('Error fetching data');
    } else {
      if (rows.length === 0) {
        res.status(404).send('No schedule found for the given employee ID');
      } else {
        const filePath = path.join(__dirname, `${req.params.id}_schedule.xlsx`);
        await generateExcel(rows, filePath);
        res.download(filePath);
      }
    }
  });
});

module.exports = router;