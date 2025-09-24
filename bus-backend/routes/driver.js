// routes/driver.js
const express = require('express');
const router = express.Router();

// In-memory storage for demo (replace with DB in real app)
const driverLocations = {};

// POST /api/driver/location
router.post('/location', (req, res) => {
  const { busId, busName, latitude, longitude } = req.body;

  // Basic validation
  if (!busId || !latitude || !longitude) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  // Store latest location for the bus
  driverLocations[busId] = {
    busId,
    busName,
    latitude,
    longitude,
    timestamp: new Date().toISOString(),
  };

  console.log('Location updated:', driverLocations[busId]);
  return res.status(200).json({ message: 'Location updated successfully' });
});

module.exports = router;
