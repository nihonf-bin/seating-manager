const express = require('express');
const { generateExcel } = require('./excelGenerator');
const path = require('path');
const db = require('./db'); 

const router = express.Router();

router.get('/', (req, res) => {
  const query = 'SELECT * FROM employeedb';
  db.query(query)
    .then(([rows]) => {
      console.log('Fetched rows:', rows);
      res.send(`
        <h1>Employee Data</h1>
        <ul>
          ${rows.map(row => `<li>employeeid: ${row.employeeid}, employeename: ${row.employeename}, teamcolour: ${row.teamcolour}</li>`).join('')}
        </ul>
      `);
    })
    .catch(err => {
      console.error('Error fetching data:', err.message);
      res.status(500).send('Error fetching data');
    });
});

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

router.get('/employees/:id', (req, res) => {
  const query = 'SELECT * FROM employeedb WHERE employeeid = ?';
  db.query(query, [req.params.id])
    .then(([rows]) => {
      res.json(rows[0]);
    })
    .catch(err => {
      console.error('Error fetching data:', err.message);
      res.status(500).send('Error fetching data');
    });
});

router.put('/employees/:id', (req, res) => {
  const { employeename, companyname, teamcolour } = req.body;
  const query = 'UPDATE employeedb SET employeename = ?, companyname = ?, teamcolour = ? WHERE employeeid = ?';
  db.query(query, [employeename, companyname, teamcolour, req.params.id])
    .then(() => {
      res.send(`Employee updated with ID: ${req.params.id}`);
    })
    .catch(err => {
      console.error('Error updating data:', err.message);
      res.status(500).send('Error updating data');
    });
});

router.delete('/employees/:id', (req, res) => {
  const query = 'DELETE FROM employeedb WHERE employeeid = ?';
  db.query(query, [req.params.id])
    .then(() => {
      res.send(`Employee deleted with ID: ${req.params.id}`);
    })
    .catch(err => {
      console.error('Error deleting data:', err.message);
      res.status(500).send('Error deleting data');
    });
});

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