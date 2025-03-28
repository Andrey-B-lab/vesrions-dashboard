const express = require('express');
const app = express();

app.get('/', (req, res) => res.send('Node App is running'));
app.get('/version', (req, res) => res.send(process.env.APP_VERSION || 'unknown'));

app.listen(80, () => console.log('Node app running on port 80'));
