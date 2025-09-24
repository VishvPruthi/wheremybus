require('dotenv').config();
const express = require('express');
const http = require('http');
const cors = require('cors');
const socketIo = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIo(server, { cors: { origin: '*' } });

app.use(cors());
app.use(express.json());

// ==================== SAMPLE DATA ====================

// Bus schedules
const busSchedules = [
  {
    busId: "101",
    busName: "Rohtak City",
    source: "Jhajjar",
    destination: "Rohtak",
    days: ["Runs Daily"],
    departureTime: "06:00",
    arrivalTime: "07:05",
  },
  {
    busId: "101",
    busName: "Rohtak City",
    source: "Jhajjar",
    destination: "Rohtak",
    days: ["Runs Daily"],
    departureTime: "08:00",
    arrivalTime: "09:15",
  },
  {
    busId: "102",
    busName: "Bahadurgarh City",
    source: "Jhajjar",
    destination: "Bahadurgarh",
    days: ["Runs Daily"],
    departureTime: "09:30",
    arrivalTime: "10:42",
  },
  {
    busId: "103",
    busName: "Rewari Express",
    source: "Jhajjar",
    destination: "Rewari",
    days: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
    departureTime: "09:02",
    arrivalTime: "10:33",
  },
  {
    busId: "104",
    busName: "Gurugram Daily",
    source: "Jhajjar",
    destination: "Gurugram",
    days: ["Runs Daily"],
    departureTime: "07:05",
    arrivalTime: "08:40",
  },
  {
    busId: "105",
    busName: "Haridwar Morning",
    source: "Jhajjar",
    destination: "Haridwar",
    days: ["Sat", "Sun"],
    departureTime: "05:00",
    arrivalTime: "11:00",
  },
];

// Live locations { busId: { busName, latitude, longitude } }
const busLocations = {};

// ==================== BUS ROUTES ====================
const busRoutes = {
  "101": [
    { stopName: "Jhajjar", time: "06:00", eta: "On Time", distance: "0 km", isCurrent: true },
    { stopName: "Gudda", time: "06:20", eta: "06:25", distance: "2 km" },
    { stopName: "Dujana", time: "06:40", eta: "06:45", distance: "12 km" },
    { stopName: "Dighal", time: "07:00", eta: "07:05", distance: "19 km" },
    { stopName: "Rohtak", time: "07:30", eta: "07:35", distance: "32 km" }
  ],
  "102": [
    { stopName: "Jhajjar", time: "09:30", eta: "On Time", distance: "0 km", isCurrent: true },
    { stopName: "Kablana", time: "09:50", eta: "09:55", distance: "15 km" },
    { stopName: "Dulhera", time: "10:10", eta: "10:15", distance: "20 km" },
    { stopName: "Daboda", time: "10:25", eta: "10:32", distance: "25 km" },
    { stopName: "Nuna Majra", time: "10:40", eta: "10:42", distance: "30 km" }
  ],
  "103": [
    { stopName: "Jhajjar", time: "09:02", eta: "On Time", distance: "0 km", isCurrent: true },
    { stopName: "Machhrauli", time: "09:25", eta: "09:30", distance: "18 km" },
    { stopName: "Pataudi", time: "09:55", eta: "10:00", distance: "35 km" },
    { stopName: "Rewari", time: "10:30", eta: "10:33", distance: "50 km" }
  ],
  "104": [
    { stopName: "Jhajjar", time: "07:05", eta: "On Time", distance: "0 km", isCurrent: true },
    { stopName: "Silana", time: "07:25", eta: "07:45", distance: "6 km" },
    { stopName: "Aurangpur", time: "07:45", eta: "08:15", distance: "13 km" },
    { stopName: "Farukhnagar", time: "08:10", eta: "08:42", distance: "25 km" },
    { stopName: "Gurugram", time: "08:40", eta: "08:42", distance: "50 km" }
  ],
  "105": [
    { stopName: "Jhajjar", time: "05:00", eta: "On Time", distance: "0 km", isCurrent: true },
    { stopName: "Sampla", time: "05:35", eta: "05:38", distance: "25 km" },
    { stopName: "Sonipat", time: "06:30", eta: "06:35", distance: "50 km" },
    { stopName: "Baraut", time: "08:00", eta: "08:07", distance: "120 km" },
    { stopName: "Mujjafarnagar", time: "09:15", eta: "On Time", distance: "160 km" },
    { stopName: "Roorkee", time: "10:20", eta: "On Time", distance: "230 km" },
    { stopName: "Haridwar", time: "11:00", eta: "On Time", distance: "255 km" }
  ]
};

// ==================== ROUTES ====================

// Root test
app.get('/', (req, res) => {
  res.send('🚍 Bus Tracking Server is running!');
});

// Driver updates location
app.post('/api/driver/location', (req, res) => {
  console.log("📍 Driver update received:", req.body); 
  const { busId, busName, latitude, longitude } = req.body;

  if (!busId || latitude === undefined || longitude === undefined) {
    return res.status(400).json({ error: 'busId, latitude, and longitude are required' });
  }

  busLocations[busId] = { busName, latitude, longitude };

  // Broadcast to all connected passengers
  io.emit('locationUpdated', { busId, busName, latitude, longitude });

  res.json({ message: 'Location updated' });
});

// Get all live bus locations
app.get('/api/buses/locations', (req, res) => {
  res.json(busLocations);
});

// 🔎 Search buses by source & destination (supports intermediate stops)
app.get('/api/buses/search', (req, res) => {
  const { source, destination } = req.query;
  if (!source || !destination) {
    return res.status(400).json({ error: 'source and destination are required' });
  }

  const src = source.toLowerCase();
  const dest = destination.toLowerCase();
  const results = [];

  for (const bus of busSchedules) {
    const route = busRoutes[bus.busId];
    if (route) {
      const srcIndex = route.findIndex(stop => stop.stopName.toLowerCase().includes(src));
      const destIndex = route.findIndex(stop => stop.stopName.toLowerCase().includes(dest));

      // Valid if both stops exist AND source comes before destination
      if (srcIndex !== -1 && destIndex !== -1 && srcIndex < destIndex) {
        results.push(bus);
      }
    }
  }

  res.json(results);
});

// Get route + ETA for a bus
app.get('/api/buses/:busId/route', (req, res) => {
  const { busId } = req.params;
  const route = busRoutes[busId];

  if (!route) {
    return res.status(404).json({ error: `No route found for busId ${busId}` });
  }

  res.json(route);
});

// ==================== SOCKET.IO ====================
io.on('connection', socket => {
  console.log('Passenger connected:', socket.id);

  socket.on('disconnect', () => {
    console.log('Passenger disconnected:', socket.id);
  });
});

// ==================== START SERVER ====================
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => console.log(`✅ Server running on http://localhost:${PORT}`));
