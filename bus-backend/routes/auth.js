const express = require('express');
const router = express.Router();

router.post('/signup', (req, res) => {
  const { name, email, password } = req.body;
  // For now, just echo back the data
  res.json({ message: 'Signup route', name, email });
});

module.exports = router;
