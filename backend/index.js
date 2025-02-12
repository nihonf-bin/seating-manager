const express = require('express');
const cors = require('cors');
const routes = require('./routes');

const app = express();
const port = 3000;

app.use(cors()); // Enable CORS for all routes
app.use(express.json());
app.use('/api', routes);

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});