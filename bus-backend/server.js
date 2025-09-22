const express = require("express");
const http = require("http");
const socketIo = require("socket.io");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: { origin: "*" }
});

app.use(cors());
app.use(express.json());

// MongoDB connect
mongoose.connect("mongodb://localhost:27017/busapp", {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

// Bus schema
const BusSchema = new mongoose.Schema({
  id: String,
  name: String,
  route: [String],
  currentLocation: {
    lat: Number,
    lng: Number,
  }
});

const Bus = mongoose.model("Bus", BusSchema);

// Search API
app.post("/search", async (req, res) => {
  const { from, to } = req.body;
  const buses = await Bus.find({
    route: { $all: [from, to] }
  });
  res.json(buses);
});

// Socket for live tracking
io.on("connection", (socket) => {
  console.log("Passenger/Driver connected");

  socket.on("subscribe_bus", (busId) => {
    socket.join(busId);
    console.log(`Passenger subscribed to ${busId}`);
  });

  socket.on("update_location", async (data) => {
    const { busId, lat, lng } = data;
    await Bus.findOneAndUpdate({ id: busId }, { currentLocation: { lat, lng } });
    io.to(busId).emit("location_update", { lat, lng });
  });

  socket.on("disconnect", () => {
    console.log("Disconnected");
  });
});

server.listen(5000, () => console.log("Backend running on http://localhost:5000"));
