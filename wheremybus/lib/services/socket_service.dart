import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? socket;

  static void connect() {
    socket = IO.io("http://10.0.2.2:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
  }

  static void subscribeToBus(String busId, Function(double, double) callback) {
    socket!.emit("subscribe_bus", busId);
    socket!.on("location_update", (data) {
      double lat = data["lat"];
      double lng = data["lng"];
      callback(lat, lng);
    });
  }

  static void disconnect() {
    socket?.disconnect();
  }
}
