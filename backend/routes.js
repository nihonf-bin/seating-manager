const express = require('express');
const { generateExcel } = require('./excelGenerator');
const path = require('path');
const db = require('./db'); // Import the MySQL database connection

const router = express.Router();

router.get('/', (req, res) => {
  const query = 'SELECT * FROM employeedb';
  db.query(query, (err, rows) => {
    if (err) {
      console.error('Error fetching data:', err.message);
      res.status(500).send('Error fetching data');
    } else {
      console.log('Fetched rows:', rows);
      res.send(`
        <h1>Employee Data</h1>
        <ul>
          ${rows.map(row => `<li>employeeid: ${row.employeeid}, employeename: ${row.employeename}, teamcolour: ${row.teamcolour}</li>`).join('')}
        </ul>
      `);
    }
  });
});

router.post('/employees', (req, res) => {
  const { employeeid, employeename, companyname, teamcolour } = req.body;
  const query = 'INSERT INTO employeedb (employeeid, employeename, companyname, teamcolour) VALUES (?, ?, ?, ?)';
  db.query(query, [employeeid, employeename, companyname, teamcolour], (err, results) => {
    if (err) {
      console.error('Error inserting data:', err.message);
      res.status(500).send('Error inserting data');
    } else {
      res.status(201).send(`Employee added with ID: ${results.insertId}`);
    }
  });
});

router.get('/employees', (req, res) => {
  const query = 'SELECT * FROM employeedb';
  db.query(query, (err, rows) => {
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
  db.query(query, [req.params.id], (err, rows) => {
    if (err) {
      console.error('Error fetching data:', err.message);
      res.status(500).send('Error fetching data');
    } else {
      res.json(rows[0]);
    }
  });
});

router.put('/employees/:id', (req, res) => {
  const { employeename, companyname, teamcolour } = req.body;
  const query = 'UPDATE employeedb SET employeename = ?, companyname = ?, teamcolour = ? WHERE employeeid = ?';
  db.query(query, [employeename, companyname, teamcolour, req.params.id], (err, results) => {
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
  db.query(query, [req.params.id], (err, results) => {
    if (err) {
      console.error('Error deleting data:', err.message);
      res.status(500).send('Error deleting data');
    } else {
      res.send(`Employee deleted with ID: ${req.params.id}`);
    }
  });
});

router.get('/schedule', (req, res) => {
  const query = 'SELECT * FROM schedules';
  db.query(query, (err, rows) => {
    if (err) {
      console.error('Error fetching data:', err.message);
      res.status(500).send('Error fetching data');
    } else {
      res.json(rows);
    }
  });
});

router.get('/schedule/:id', (req, res) => {
  const query = 'SELECT * FROM schedules WHERE person_id = ?';
  db.query(query, [req.params.id], async (err, rows) => {
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