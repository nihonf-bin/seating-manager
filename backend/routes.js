const express = require('express');
const { generateExcel } = require('./excelGenerator');
const path = require('path');
const db = require('./db'); 

const router = express.Router();

// Fetch all employees
router.get('/employees', (req, res) => {
  const query = 'SELECT * FROM employeedb';
  db.query(query)
    .then(([rows]) => {
      res.json(rows);
    })
    .catch(err => {
      console.error('Error fetching data:', err.message);
      res.status(500).send('Error fetching data');
    });
});

// Fetch a specific employee by ID
router.get('/employees/:id', (req, res) => {
  const query = 'SELECT * FROM employeedb WHERE employeeid = ?';
  db.query(query, [req.params.id])
    .then(([rows]) => {
      if (rows.length > 0) {
        res.json(rows[0]);
      } else {
        res.status(404).send('Employee not found');
      }
    })
    .catch(err => {
      console.error('Error fetching data:', err.message);
      res.status(500).send('Error fetching data');
    });
});

// Add a new employee
router.post('/employees', (req, res) => {
  const { employeeid, employeename, companyname, teamcolour } = req.body;
  const query = 'INSERT INTO employeedb (employeeid, employeename, companyname, teamcolour) VALUES (?, ?, ?, ?)';
  db.query(query, [employeeid, employeename, companyname, teamcolour])
    .then(([results]) => {
      res.status(201).send(`Employee added with ID: ${results.insertId}`);
    })
    .catch(err => {
      console.error('Error inserting data:', err.message);
      res.status(500).send('Error inserting data');
    });
});

// Update an existing employee
router.put('/employees/:id', (req, res) => {
  const { employeename, companyname, teamcolour } = req.body;
  const query = 'UPDATE employeedb SET employeename = ?, companyname = ?, teamcolour = ? WHERE employeeid = ?';
  db.query(query, [employeename, companyname, teamcolour, req.params.id])
    .then(([results]) => {
      if (results.affectedRows > 0) {
        res.send(`Employee updated with ID: ${req.params.id}`);
      } else {
        res.status(404).send('Employee not found');
      }
    })
    .catch(err => {
      console.error('Error updating data:', err.message);
      res.status(500).send('Error updating data');
    });
});

// Delete an employee
router.delete('/employees/:id', (req, res) => {
  const query = 'DELETE FROM employeedb WHERE employeeid = ?';
  db.query(query, [req.params.id])
    .then(([results]) => {
      if (results.affectedRows > 0) {
        res.send(`Employee deleted with ID: ${req.params.id}`);
      } else {
        res.status(404).send('Employee not found');
      }
    })
    .catch(err => {
      console.error('Error deleting data:', err.message);
      res.status(500).send('Error deleting data');
    });
});

// Fetch all schedules
router.get('/schedule', (req, res) => {
  const query = 'SELECT * FROM schedules';
  db.query(query)
    .then(([rows]) => {
      res.json(rows);
    })
    .catch(err => {
      console.error('Error fetching data:', err.message);
      res.status(500).send('Error fetching data');
    });
});

// Fetch a specific schedule by person ID
router.get('/schedule/:id', (req, res) => {
  const query = 'SELECT * FROM schedules WHERE person_id = ?';
  db.query(query, [req.params.id])
    .then(async ([rows]) => {
      if (rows.length === 0) {
        res.status(404).send('No schedule found for the given employee ID');
      } else {
        const filePath = path.join(__dirname, `${req.params.id}_schedule.xlsx`);
        await generateExcel(rows, filePath);
        res.download(filePath);
      }
    })
    .catch(err => {
      console.error('Error fetching data:', err.message);
      res.status(500).send('Error fetching data');
    });
});

// Login route
router.post('/login', async (req, res) => {
  const { username, password } = req.body;

  try {
    const [result] = await db.query(
      'SELECT * FROM logincredentials WHERE username = ? AND password = ?',
      [username, password]
    );

    if (result.length > 0) {
      res.json({ success: true });
    } else {
      res.json({ success: false });
    }
  } catch (error) {
    console.error('Database error:', error.message); 
    res.status(500).json({ error: 'Database error', details: error.message });
  }
});

module.exports = router;